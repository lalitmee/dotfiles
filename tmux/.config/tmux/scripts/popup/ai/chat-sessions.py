#!/usr/bin/env python3
"""Read first prompts from supported local agent sessions."""

import json
import os
from pathlib import Path
import queue
import subprocess
import sys
import threading
import time


def run_cli(command, directory):
    return subprocess.run(
        command, cwd=directory, text=True, capture_output=True, timeout=15, check=True,
    ).stdout


def text_from_parts(parts):
    if not isinstance(parts, list):
        return ""
    return "\n".join(
        part.get("text", "") for part in parts
        if isinstance(part, dict) and part.get("type") == "text"
    ).strip()


def opencode_sessions(directory):
    data = json.loads(run_cli(["opencode", "session", "list", "--format", "json"], directory))
    if not isinstance(data, list):
        raise ValueError("Invalid session list")
    sessions = []
    for item in data:
        if isinstance(item, dict) and isinstance(item.get("id"), str):
            sessions.append({"id": item["id"], "title": str(item.get("title") or item["id"])})
    return sessions


def opencode_prompt(directory, session_id):
    data = json.loads(run_cli(["opencode", "session", "export", session_id], directory))
    messages = data.get("messages") if isinstance(data, dict) else None
    if not isinstance(messages, list):
        raise ValueError("Invalid session export")
    for message in messages:
        if not isinstance(message, dict):
            continue
        info = message.get("info", message)
        if isinstance(info, dict) and info.get("role") == "user":
            text = text_from_parts(message.get("parts"))
            if text:
                return text
    raise ValueError("No user prompt available")


def codex_request(directory, method, params):
    process = subprocess.Popen(
        ["codex", "app-server"], cwd=directory, stdin=subprocess.PIPE,
        stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, bufsize=1,
    )
    responses = queue.Queue()

    def read_responses():
        for line in process.stdout:
            responses.put(line)

    threading.Thread(target=read_responses, daemon=True).start()

    def request(request_id, name, values):
        process.stdin.write(json.dumps({
            "jsonrpc": "2.0", "id": request_id, "method": name, "params": values,
        }) + "\n")
        process.stdin.flush()
        deadline = time.monotonic() + 15
        while time.monotonic() < deadline:
            try:
                line = responses.get(timeout=max(0, deadline - time.monotonic()))
            except queue.Empty:
                break
            response = json.loads(line)
            if response.get("id") != request_id:
                continue
            if "error" in response:
                raise ValueError("Codex app-server request failed")
            return response.get("result", {})
        raise ValueError("Codex app-server timed out")

    try:
        request(1, "initialize", {
            "clientInfo": {"name": "tmux-chat-name", "title": "tmux chat naming", "version": "1"},
            "capabilities": {"experimentalApi": False},
        })
        process.stdin.write(json.dumps({"jsonrpc": "2.0", "method": "initialized", "params": {}}) + "\n")
        process.stdin.flush()
        return request(2, method, params)
    finally:
        process.stdin.close()
        process.terminate()
        try:
            process.wait(timeout=2)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()


def codex_sessions(directory):
    result = codex_request(directory, "thread/list", {"cwd": str(directory), "limit": 100})
    threads = result.get("data", [])
    if not isinstance(threads, list):
        raise ValueError("Invalid Codex thread list")
    return [
        {"id": thread["id"], "title": str(thread.get("preview") or thread.get("name") or thread["id"])}
        for thread in threads if isinstance(thread, dict) and isinstance(thread.get("id"), str)
    ]


def codex_prompt(directory, session_id):
    result = codex_request(directory, "thread/read", {"threadId": session_id, "includeTurns": True})
    thread = result.get("thread", {})
    for turn in thread.get("turns", []):
        for item in turn.get("items", []):
            if not isinstance(item, dict) or item.get("type") != "userMessage":
                continue
            content = item.get("content", item.get("input", []))
            text = text_from_parts(content)
            if text:
                return text
    raise ValueError("No user prompt available")


def pi_sessions(directory):
    encoded = str(directory).lstrip("/").replace("/", "-").replace("\\", "-").replace(":", "-")
    root = Path.home() / ".pi" / "agent" / "sessions" / f"--{encoded}--"
    for path in sorted(root.glob("*.jsonl"), reverse=True):
        try:
            with path.open(encoding="utf-8") as file:
                header = json.loads(next(file))
            if header.get("type") == "session" and header.get("cwd") == str(directory):
                title = header.get("name")
                if not title:
                    try:
                        title = pi_prompt(path).splitlines()[0][:80]
                    except (OSError, ValueError, TypeError, KeyError, AttributeError, json.JSONDecodeError):
                        title = header["id"]
                yield header["id"], path, str(title)
        except (OSError, ValueError, KeyError, StopIteration, AttributeError):
            continue


def pi_prompt(path):
    with path.open(encoding="utf-8") as file:
        for line in file:
            entry = json.loads(line)
            message = entry.get("message", {})
            if entry.get("type") != "message" or message.get("role") != "user":
                continue
            content = message.get("content", "")
            if isinstance(content, list):
                content = "\n".join(
                    block.get("text", "") for block in content
                    if isinstance(block, dict) and block.get("type") == "text"
                )
            if isinstance(content, str) and content.strip():
                return content
    raise ValueError("No user prompt available")


def main():
    if len(sys.argv) not in (4, 5):
        raise ValueError("Invalid arguments")
    action, provider, directory = sys.argv[1:4]
    directory = Path(os.path.abspath(directory))
    if provider not in ("pi", "opencode", "codex"):
        raise ValueError(f"Session access for {provider} is not available")
    if action == "list" and len(sys.argv) == 4:
        if provider == "opencode":
            result = opencode_sessions(directory)
        elif provider == "codex":
            result = codex_sessions(directory)
        else:
            result = [{"id": ident, "title": title} for ident, _, title in pi_sessions(directory)]
    elif action == "prompt" and len(sys.argv) == 5:
        session_id = sys.argv[4]
        if provider == "opencode":
            result = opencode_prompt(directory, session_id)
        elif provider == "codex":
            result = codex_prompt(directory, session_id)
        else:
            matches = [path for ident, path, _ in pi_sessions(directory) if ident == session_id]
            if len(matches) != 1:
                raise ValueError("Session not found or ambiguous")
            result = pi_prompt(matches[0])
    else:
        raise ValueError("Invalid arguments")
    print(json.dumps(result))


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, TypeError, KeyError, AttributeError, subprocess.SubprocessError, json.JSONDecodeError):
        print("Unable to read the requested session or prompt", file=sys.stderr)
        sys.exit(1)
