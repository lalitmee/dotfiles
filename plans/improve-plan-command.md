# Feature Implementation Plan: Interactive Planning Command

## 📋 Todo Checklist
- [ ] Update the `plan/new.toml` prompt to be interactive.
- [ ] Test the new interactive planning command.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The `gemini-cli` tool uses `.toml` files in the `gemini-cli/.gemini/commands` directory to define slash commands. Each `.toml` file contains a `description` and a `prompt`. The `prompt` is a template that is sent to the language model.

### Current Architecture
The current `plan/new.toml` contains a very long, static prompt that instructs the model to act as a senior engineer and create a plan. This is not interactive. The `explain/interactive.toml` file, however, provides a model for creating an interactive, conversational command. It does this by instructing the model to ask questions, decompose problems, and guide the user through a process.

### Dependencies & Integration Points
This change only affects the `gemini-cli/.gemini/commands/plan/new.toml` file. There are no other dependencies.

### Considerations & Challenges
The main challenge is to craft a prompt that reliably guides the language model to have a conversation with the user. The prompt needs to be very clear about the desired conversational flow.

## 📝 Implementation Plan

### Prerequisites
None.

### Step-by-Step Implementation
1. **Update the `plan/new.toml` prompt**:
   - Files to modify: `gemini-cli/.gemini/commands/plan/new.toml`
   - Changes needed: Replace the existing static prompt with a new interactive prompt. The new prompt will instruct the model to:
      1. Acknowledge the user's feature request and ask clarifying questions to define the scope.
      2. Propose an investigation plan (which files to read, etc.) and ask for user approval.
      3. Perform the investigation and present a summary of its findings, asking for confirmation.
      4. Propose a high-level outline of the implementation plan and ask for approval.
      5. Ask the user for a filename for the plan.
      6. Generate the detailed plan and save it to the specified file in the `plans/` directory.

   The new prompt will be based on the successful interactive pattern found in `explain/interactive.toml`.

   **New `prompt` for `plan/new.toml`:**
   ```toml
   description = "Interactive planning mode. Interactively creates a feature implementation plan."
   prompt = """
   You are operating in a specialized **Interactive Planning Mode**. Your role is to act as a senior engineer, collaborating with the user to create a comprehensive implementation plan.

   Your primary goal is to guide the user through a structured planning process, ensuring the final plan is well-researched, well-defined, and aligned with the user's goals.

   # Core Principles of Interactive Planning

   - **Conversational Approach:** You do not generate a plan from a single instruction. You engage in a conversation to understand, investigate, and then plan.
   - **User-Guided Investigation:** You propose what you will investigate, but the user has the final say.
   - **Iterative Refinement:** You present your findings and a plan outline for user feedback before generating the final detailed plan.

   # Interactive Planning Steps

   1.  **Acknowledge & Scope:**
       - Acknowledge the user's feature request: "{{args}}".
       - Ask clarifying questions to fully understand the feature and its requirements.

   2.  **Propose Investigation Plan:**
       - Based on the feature description, propose a list of files and directories you intend to investigate.
       - Ask the user for approval before proceeding.

   3.  **Investigate & Analyze:**
       - Once the user approves, perform the investigation.
       - Present a concise analysis of your findings, including any potential challenges or important discoveries.
       - Ask the user to confirm your analysis.

   4.  **Propose Plan Outline:**
       - Based on your analysis, present a high-level outline of the implementation plan (e.g., a list of the main steps).
       - Ask the user for approval to create the detailed plan.

   5.  **Get Plan Filename:**
       - Ask the user for a filename for the plan (e.g., `improve-slash-command`).

   6.  **Generate Detailed Plan:**
       - Generate the full, detailed implementation plan, following the standard plan format.
       - Write the plan to `plans/<filename>.md`.
       - Confirm that the plan has been saved, and then end the conversation.

   ## Available Tools

   To complete the task, you have been granted access to the following tools. You are expected to use them as needed.

   The tools available for this command are:
   - `filesystem`
   - `git`
   - `github`
   - `fetch`
   - `sequential-thinking`
   - `crash`
   - `context7`
   """
   ```

### Testing Strategy
To test the new interactive command:
1. Run the `/plan new` command in the `gemini-cli`.
2. Provide a feature description (e.g., "Add a new button to the main page").
3. Follow the interactive prompts from the model:
   - Answer its clarifying questions.
   - Approve its investigation plan.
   - Confirm its analysis.
   - Approve its plan outline.
   - Provide a filename.
4. Verify that the model creates a detailed plan in the `plans/` directory with the correct filename and content.

## 🎯 Success Criteria
The feature is complete when:
- The `/plan new` command is interactive and guides the user through the planning process.
- The model successfully creates a detailed implementation plan based on the interactive conversation.
- The final plan is saved to a file in the `plans/` directory.
