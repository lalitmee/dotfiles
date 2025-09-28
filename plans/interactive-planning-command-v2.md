# Feature Implementation Plan: Interactive Planning Command v2

## 📋 Todo Checklist
- [ ] Create a new interactive planning command file.
- [ ] Implement the new interactive prompt.
- [ ] Test the new interactive planning command.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The `gemini-cli` tool uses `.toml` files in the `gemini-cli/.gemini/commands` directory to define slash commands. Each `.toml` file contains a `description` and a `prompt`. The `prompt` is a template that is sent to the language model.

### Current Architecture
The current `plan/new.toml` contains a very long, static prompt. The user wants a more interactive experience where the model can ask questions if it has doubts. Instead of overwriting the existing file, we will create a new file `plan/interactive.toml` for this new command.

### Dependencies & Integration Points
This change involves creating a new file `gemini-cli/.gemini/commands/plan/interactive.toml`. It will not affect any other files.

### Considerations & Challenges
The main challenge is to craft a prompt that encourages the model to ask questions when it is uncertain, without making it overly hesitant. The prompt needs to strike a balance between autonomous investigation and seeking user input.

## 📝 Implementation Plan

### Prerequisites
None.

### Step-by-Step Implementation
1. **Create the new command file**:
   - Files to create: `gemini-cli/.gemini/commands/plan/interactive.toml`
   - Changes needed: Create a new file with a description and an interactive prompt.

2. **Implement the new interactive prompt**:
   - Files to modify: `gemini-cli/.gemini/commands/plan/interactive.toml`
   - Changes needed: Add the following content to the new file. The prompt is designed to encourage the model to ask questions when it encounters uncertainty.

   **Content for `plan/interactive.toml`:**
   ```toml
   description = "Highly interactive planning mode. Creates a feature implementation plan with user collaboration."
   prompt = """
   You are operating in a specialized **Collaborative Planning Mode**. Your role is to act as a senior engineer, working closely with the user to create a comprehensive and accurate implementation plan.

   Your primary goal is to have a dialogue with the user. If you have any questions or doubts at any point, you should stop and ask for clarification.

   # Core Principles of Collaborative Planning

   - **Dialogue over Monologue:** Your primary mode of operation is a conversation. Ask questions whenever you are unsure.
   - **User is the Oracle:** The user has the context. If you are missing information or need to make an assumption, ask the user first.
   - **Transparency:** Be open about what you are investigating and why.

   # Collaborative Planning Steps

   1.  **Acknowledge & Scope:**
       - Acknowledge the user's feature request: "{{args}}".
       - Ask initial clarifying questions to understand the feature and its requirements.

   2.  **Propose Investigation Plan:**
       - Based on the feature description, propose a list of files and directories you intend to investigate.
       - **If you are unsure about where to start, ask the user for guidance.**
       - Ask the user for approval before proceeding.

   3.  **Investigate & Analyze:**
       - Once the user approves, perform the investigation.
       - **If you encounter anything unexpected or have questions during your investigation, stop and ask the user.**
       - Present a concise analysis of your findings.
       - Ask the user to confirm your analysis.

   4.  **Propose Plan Outline:**
       - Based on your analysis, present a high-level outline of the implementation plan.
       - Ask the user for approval to create the detailed plan.

   5.  **Get Plan Filename:**
       - Ask the user for a filename for the plan (e.g., `improve-slash-command`).

   6.  **Generate Detailed Plan:**
       - Generate the full, detailed implementation plan.
       - **If you have any final questions while writing the plan, include them in a 'Questions for the User' section within the plan itself.**
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
1. Run the `/plan interactive` command in the `gemini-cli`.
2. Provide a vague or ambiguous feature description to encourage the model to ask questions.
3. Verify that the model asks for clarification before proceeding.
4. Follow the rest of the interactive prompts.
5. Check the final plan for a "Questions for the User" section if the model had any final doubts.

## 🎯 Success Criteria
The feature is complete when:
- A new command `/plan interactive` is available.
- The command is highly interactive and asks questions when it is uncertain.
- The model successfully creates a detailed implementation plan based on the interactive conversation.
- The final plan is saved to a file in the `plans/` directory.
