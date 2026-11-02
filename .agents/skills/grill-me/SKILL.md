---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

# grill-me

Interview the user relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

## Hard Rules

1. **Question tool mandatory:** You MUST ask each question using the environment's structured question/input tool (`ask_question` in Antigravity, `AskQuestion` in Cursor, `ask_user` in Gemini CLI, or whichever interactive question tool your runtime provides), exactly one at a time.
2. **Never substitute chat prose or lists:** Even if the user claims to be on mobile, in a hurry, or asks to bypass widgets, you MUST NOT ask questions as plain chat text or bulleted/lettered lists when a question tool exists in your toolset. If your runtime has NO question tool whatsoever, only then may you ask in chat.
3. **Recommended answer first:** Include a minimum of 2 options. Put your recommended answer first and mark it with `(Recommended)`.
4. **One question per turn:** Wait for the user's response to the tool call before proceeding to the next node. Never batch questions.
5. **Explore code first:** If a question can be answered by exploring the codebase, explore the codebase instead of asking.

## How to run the session

1. **Scope**: Confirm the artifact under review (plan doc, design, ADR, ticket, or in-chat outline). If missing, ask once for the minimum context needed to start.
2. **Order**: Decompose into a decision tree. Work depth-first: finish one branch (parent → children) before opening a sibling branch, unless a dependency forces reordering.
3. **One question per turn**: Invoke the question tool with a single focused question and options.
4. **Codebase over questions**: If the answer is knowable from the repo (paths, patterns, owners, existing APIs), search/read first and report findings; only ask the user for judgment calls, product intent, or facts not in code.
5. **Close the loop**: After each answer, state the **resolved decision** in one line, then move to the next open node. When all branches are resolved, give a short **shared understanding summary** (bullet list of decisions + any explicit non-goals or deferred items).

## Stop conditions

- End when the decision tree is fully walked and the summary is accepted, or the user ends the session.
- If blocked on missing access (private systems, people), record the blocker as an open node and continue with branches that are unblocked.
