#!/usr/bin/env python3
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[4] / "tmux/.config/tmux/scripts/popup/ai/chat-sessions.py"


class SessionsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.project = self.home / "project with spaces"
        self.project.mkdir()
        self.env = {**os.environ, "HOME": str(self.home)}

    def run_adapter(self, *args):
        return subprocess.run(
            ["python3", str(SCRIPT), *args], env=self.env,
            text=True, capture_output=True,
        )

    def test_pi_selects_specific_session_and_first_user_prompt(self):
        directory = self.home / ".pi/agent/sessions" / ("--" + str(self.project).lstrip("/").replace("/", "-") + "--")
        directory.mkdir(parents=True)
        for session, prompt in [("one", "first request"), ("two", "other request")]:
            entries = [
                {"type": "session", "version": 3, "id": session, "cwd": str(self.project)},
                {"type": "message", "id": "1", "parentId": None, "message": {"role": "assistant", "content": "ignore"}},
                {"type": "message", "id": "2", "parentId": "1", "message": {"role": "user", "content": [{"type": "text", "text": prompt}]}},
            ]
            (directory / f"2026_{session}.jsonl").write_text("".join(json.dumps(e) + "\n" for e in entries))
        listed = self.run_adapter("list", "pi", str(self.project))
        self.assertEqual(listed.returncode, 0, listed.stderr)
        self.assertEqual({x["id"] for x in json.loads(listed.stdout)}, {"one", "two"})
        result = self.run_adapter("prompt", "pi", str(self.project), "one")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout), "first request")

    def test_opencode_uses_json_cli_and_exports_only_selected_session(self):
        fake_bin = self.home / "bin"
        fake_bin.mkdir()
        log = self.home / "calls"
        cli = fake_bin / "opencode"
        cli.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "with open(os.environ['CALL_LOG'], 'a') as f: f.write(json.dumps(sys.argv[1:]) + '\\n')\n"
            "if sys.argv[1:3] == ['session', 'list']:\n"
            " print(json.dumps([{'id':'s1','title':'first'}, {'id':'s2','title':'second'}]))\n"
            "else:\n"
            " print(json.dumps({'info': {'id':'s1'}, 'messages':["
            "{'role':'system','parts':[{'type':'text','text':'ignore'}]},"
            "{'role':'user','parts':[{'type':'text','text':'first prompt'}]},"
            "{'role':'assistant','parts':[{'type':'text','text':'ignore'}]}]}))\n"
        )
        cli.chmod(0o755)
        self.env.update({"PATH": f"{fake_bin}:{os.environ['PATH']}", "CALL_LOG": str(log)})
        listed = self.run_adapter("list", "opencode", str(self.project))
        self.assertEqual(listed.returncode, 0, listed.stderr)
        self.assertEqual(json.loads(listed.stdout), [
            {"id": "s1", "title": "first"}, {"id": "s2", "title": "second"},
        ])
        result = self.run_adapter("prompt", "opencode", str(self.project), "s1")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout), "first prompt")
        calls = [json.loads(line) for line in log.read_text().splitlines()]
        self.assertEqual(calls[0][:3], ["session", "list", "--format"])
        self.assertEqual(calls[1], ["session", "export", "s1"])

    def test_claude_fails_closed_when_sdk_is_unavailable(self):
        result = self.run_adapter("list", "claude", str(self.project))
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")

    def test_codex_uses_app_server_thread_picker_and_read(self):
        fake_bin = self.home / "bin"
        fake_bin.mkdir()
        log = self.home / "codex-calls"
        cli = fake_bin / "codex"
        cli.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "for line in sys.stdin:\n"
            " m=json.loads(line); method=m.get('method'); i=m.get('id')\n"
            " with open(os.environ['CODEX_LOG'], 'a') as f: f.write(json.dumps(m) + '\\n')\n"
            " if i is None: continue\n"
            " if method == 'initialize': r={'serverInfo': {'name':'codex','version':'test'}}\n"
            " elif method == 'thread/list':\n"
            "  print(json.dumps({'jsonrpc':'2.0','method':'thread/started','params':{'threadId':'thread-1'}}), flush=True)\n"
            "  r={'data':[{'id':'thread-1','preview':'first prompt'}], 'nextCursor':None}\n"
            " elif method == 'thread/read': r={'thread': {'id':'thread-1','turns':[{'id':'turn-1','items':["
            "{'type':'userMessage','content':[{'type':'text','text':'first prompt'}]},"
            "{'type':'assistantMessage','text':'do not use'}]}]}}\n"
            " else: r={}\n"
            " print(json.dumps({'jsonrpc':'2.0','id':i,'result':r}), flush=True)\n"
        )
        cli.chmod(0o755)
        self.env.update({"PATH": f"{fake_bin}:{os.environ['PATH']}", "CODEX_LOG": str(log)})
        listed = self.run_adapter("list", "codex", str(self.project))
        self.assertEqual(listed.returncode, 0, listed.stderr)
        self.assertEqual(json.loads(listed.stdout), [{"id": "thread-1", "title": "first prompt"}])
        prompt = self.run_adapter("prompt", "codex", str(self.project), "thread-1")
        self.assertEqual(prompt.returncode, 0, prompt.stderr)
        self.assertEqual(json.loads(prompt.stdout), "first prompt")
        calls = [json.loads(line) for line in log.read_text().splitlines()]
        self.assertEqual([c["method"] for c in calls if "method" in c], [
            "initialize", "initialized", "thread/list",
            "initialize", "initialized", "thread/read",
        ])

    def test_unknown_session_fails_without_disclosing_content(self):
        result = self.run_adapter("prompt", "pi", str(self.project), "unknown")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")

    def test_pi_malformed_and_missing_prompt_fail_without_content(self):
        directory = self.home / ".pi/agent/sessions" / ("--" + str(self.project).lstrip("/").replace("/", "-") + "--")
        directory.mkdir(parents=True)
        bad = directory / "bad.jsonl"
        bad.write_text('{"type":"session","id":"bad","cwd":"' + str(self.project) + '"}\nnot json\n')
        missing = directory / "missing.jsonl"
        missing.write_text(
            json.dumps({"type": "session", "id": "missing", "cwd": str(self.project)}) + "\n"
            + json.dumps({"type": "message", "id": "1", "message": {"role": "user", "content": " "}}) + "\n"
        )
        result = self.run_adapter("prompt", "pi", str(self.project), "missing")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        result = self.run_adapter("prompt", "pi", str(self.project), "bad")
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("not json", result.stderr)


if __name__ == "__main__":
    unittest.main()
