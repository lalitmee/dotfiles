# Generate AGENTS.md

Analyzes the repository and generates an AGENTS.md file to guide AI agents.

## Instructions

You are an expert senior software architect. Your task is to analyze the entire repository and generate a detailed AGENTS.md file. This file will be the primary directive for other AI agents interacting with this project.

**Your primary output must be the complete markdown content for a new file named AGENTS.md. Do not write any other text, explanation, or preamble before or after the file content.**

## Step 1: Investigation

First, perform a thorough investigation of the repository. Scan the project structure and analyze the content of key files. Pay close attention to:

### Project Setup

How is the project set up? Look for `package.json`, `requirements.txt`, `pom.xml`, `build.gradle`, `Dockerfile`, `docker-compose.yml`, `README.md`, and any setup scripts. Document the main technologies, frameworks, and setup/run commands.

### Coding Conventions & Linting

Are there explicit coding guidelines? Check for files like `.eslintrc`, `.prettierrc`, `pyproject.toml`, `flake8`, `checkstyle.xml`, or `.editorconfig`. Infer conventions (e.g., variable naming, import order) from existing code if these files are absent.

### Directory Structure & Key Files

What is the overall architecture? Identify core directories (`src`, `lib`, `app`, `components`, `utils`, `api`, `tests`, `internal`, `pkg`) and explain the purpose of each major one.

### Utilities & Shared Code

Look for common utility modules, helper functions, or shared libraries (e.g., in a `utils/`, `helpers/`, `shared/`, or `lib/` directory). Briefly describe what they do and how to use them.

### API Structure (if applicable)

If this is a backend or full-stack project, analyze how APIs are defined. Look for `routes/`, `controllers/`, `schemas/`, `graphql/`, or `proto/` directories. How are requests, responses, and data models structured?

### Testing

How are tests written? Look for `tests/`, `__tests__/`, or files ending in `_test.go`, `*.test.js`, `*.spec.ts`. What testing framework is used (e.g., Jest, Pytest, Go testing, JUnit)?

### Contribution Guidelines

Check for `CONTRIBUTING.md` or similar guidelines. Summarize any rules for branching, commit messages, and pull requests.

## Step 2: Generation

Once your analysis is complete, generate the AGENTS.md content. The file must be well-structured with clear markdown headings, following this template exactly:

---

## AGENTS.md Template

### Header

```markdown
# AGENTS.md: AI Contributor Guide

This document provides guidelines for AI agents to effectively understand, interact with, and contribute to this project.
```

### 1. Project Overview

```markdown
## 1. Project Overview

### Main Purpose

[Inferred purpose of the project]

### Core Technologies

[List of frameworks, languages, databases, etc. e.g., React, Node.js, Python/Django, PostgreSQL]
```

### 2. Project Setup

```markdown
## 2. Project Setup

### Dependencies

[e.g., Managed via package.json, requirements.txt, go.mod]

### Installation

```bash
[Relevant command, e.g., npm install]
```

### Running Locally

```bash
[Relevant command, e.g., npm run dev]
```

### Environment

[e.g., Requires a .env file. See .env.example for required variables.]

```text
(End of template section)
```

### 3. Coding Conventions

```markdown
## 3. Coding Conventions

### Linter/Formatter

[e.g., ESLint, Prettier, Black, GoFMT. Mention the main config file.]

### Key Styles

- **Naming**: [e.g., camelCase for variables/functions, PascalCase for classes/components]
- **Imports**: [e.g., Use absolute paths from src/, group stdlib imports first]
- **Style**: [e.g., 2-space indentation, max line length 100]
```

### 4. Directory Structure

```markdown
## 4. Directory Structure

- `src/`: [Purpose of this directory, e.g., Main application source code]
- `src/api/`: [Purpose of this directory, e.g., API route definitions and controllers]
- `src/components/`: [Purpose of this directory, e.g., Reusable UI components]
- `src/utils/`: [Purpose of this directory, e.g., Shared helper functions]
- `src/lib/`: [Purpose of this directory, e.g., Core business logic or client SDKs]
- `tests/`: [Purpose of this directory, e.g., End-to-end and integration tests]
- ... [Add other important directories and their purpose]
```

### 5. Key Modules & Utilities

```markdown
## 5. Key Modules & Utilities

- `[path/to/key/util.js]`: [Brief description of its purpose and key functions. e.g., src/utils/auth.js: Handles JWT token creation and verification.]
- `[path/to/another/util.py]`: [Brief description of its purpose and key functions. e.g., src/lib/database.py: Contains helper functions for database queries.]
```

### 6. API Structure (if applicable)

```markdown
## 6. API Structure (if applicable)

### Definition

[e.g., RESTful APIs defined in src/routes/. See src/routes/index.js for all endpoints.]

### Data Models

[e.g., Defined in src/models/ using Mongoose/Prisma schemas.]

### Authentication

[e.g., Uses JWT tokens passed in the Authorization: Bearer <token> header.]
```

### 7. Testing

```markdown
## 7. Testing

### Framework

[e.g., Jest, Pytest, Mocha & Chai]

### Location

[e.g., Tests are co-located with components (*.test.js) or in the tests/ directory]

### Test Command

```bash
[Relevant command, e.g., npm test]
```

### Guidelines

[e.g., New features must include unit tests. Mocks are located in `__mocks__/`.]

```text
(End of template section)
```

### 8. General Rules & Guidelines

```markdown
## 8. General Rules & Guidelines

- **Commits**: [e.g., Follow Conventional Commits standard: feat: ..., fix: ...]
- **Branches**: [e.g., Create new branches from main named feature/your-feature-name]
- **Dependencies**: [e.g., Always add new dependencies using npm install --save-dev <package> or npm install --save <package>.]
- **Secrets**: Never hardcode API keys or secrets. Use environment variables.
- **Code Generation**: When adding new components, follow the existing structure. Do not introduce new patterns without reason.
```
