---
description: Analyzes the current project directory recursively and generate a comprehensive GEMINI.md file
agent: build
---

You are an expert software architect and project analysis assistant. Analyze the current project directory recursively and generate a comprehensive GEMINI.md file. This file will serve as a foundational context guide for any future AI model, like yourself, that interacts with this project. The goal is to ensure that future AI-generated code, analysis, and modifications are consistent with the project's established standards and architecture.

+ Scan and Analyze: Recursively scan the entire file and folder structure starting from the provided root directory.
+ Identify Key Artifacts: Pay close attention to configuration files (package.json, requirements.txt, pom.xml, Dockerfile, .eslintrc, prettierrc, etc.), READMEs, folder hierarchy, documentation files, and source code files.
+ Incorporate Contribution & Development Guidelines: Search for and parse any files related to development, testing, or contributions (e.g., CONTRIBUTING.md, DEVELOPMENT.md, TESTING.md). The instructions within these guides are critical and must be summarized and included in the final output.
+ Infer Standards: Do not just list files. You must infer the project's implicit and explicit standards from its structure and code.

Output a single, well-formatted Markdown file named GEMINI.md. The content of this file must be structured according to the following template. Populate each section based on your analysis. If you cannot confidently determine the information for a section, state that it is inferred and note your confidence level, or suggest it as an area for the human developer to complete.

FILE STRUCTURE TO GENERATE:
# GEMINI.MD: AI Collaboration Guide

This document provides essential context for AI models interacting with this project. Adhering to these guidelines will ensure consistency and maintain code quality.

## 1. Project Overview & Purpose

* **Primary Goal:** [Analyze the README.md, documentation, and folder names to infer and summarize the project's main purpose and what it's designed to do. For example: "This is a REST API backend for a social media application."]
* **Business Domain:** [Describe the domain the project operates in, e.g., "E-commerce," "Fintech," "Healthcare Analytics."]

## 2. Core Technologies & Stack

* **Languages:** [List primary programming languages and specific versions detected, e.g., "TypeScript," "Python 3.11."]
* **Frameworks & Runtimes:** [List major frameworks and the runtime environment, e.g., "Node.js v20," "React 18," "Spring Boot 3.0," "Django 4.2."]
* **Databases:** [Identify the database systems used, e.g., "PostgreSQL," "Redis for caching," "MongoDB."]
* **Key Libraries/Dependencies:** [List the most critical libraries that define the project's functionality, e.g., "Pandas," "Express.js," "SQLAlchemy," "Axios."]
* **Package Manager(s):** [Identify the package managers used, e.g., "npm," "pip," "Maven."]

## 3. Architectural Patterns

* **Overall Architecture:** [Infer the high-level architecture. State your reasoning. Examples: "Monolithic Application," "Microservices Architecture," "Model-View-Controller (MVC)," "Serverless Functions."]
* **Directory Structure Philosophy:** [Explain the purpose of the main directories. Example:
    * `/src`: Contains all primary source code.
    * `/iac`: Contains Infrastructure as Code (e.g., Terraform).
    * `/tests`: Contains all unit and integration tests.
    * `/config`: Holds environment and configuration files.]

## 4. Coding Conventions & Style Guide

* **Formatting:** [Infer from source files and any linter configs like `.prettierrc` or `.eslintrc`. Note any standard style guides mentioned (e.g., PEP 8 for Python). Example: "Indentation: 2 spaces. Adhere to PEP 8 style guide."]
* **Naming Conventions:** [Analyze variable, function, class, and file names. Example:
    * `variables`, `functions`: camelCase (`myVariable`)
    * `classes`, `components`: PascalCase (`MyClass`)
    * `files`: kebab-case (`my-component.js`)]
* **API Design:** [If applicable, describe the API style. Example: "RESTful principles. Endpoints are plural nouns. Uses standard HTTP verbs (GET, POST, PUT, DELETE). JSON for request/response bodies."]
* **Error Handling:** [Observe common error handling patterns. Example: "Uses async/await with try...catch blocks. Custom error classes are defined in `/src/errors`."]

## 5. Key Files & Entrypoints

* **Main Entrypoint(s):** [Identify the starting point of the application, e.g., `src/index.js`, `app.py`.]
* **Configuration:** [List the primary files for environment and application configuration, e.g., `.env`, `config/application.yml`, `settings.py`.]
* **CI/CD Pipeline:** [Identify the continuous integration configuration file, e.g., `.github/workflows/main.yml`, `.gitlab-ci.yml`.]

## 6. Development & Testing Workflow

* **Local Development Environment:** [Summarize the standard procedure for setting up and running the project locally. Note key tools or commands (e.g., `skaffold dev`, `docker-compose up`).]
* **Testing:** [Describe how tests are run. Note any specific commands or frameworks. Example: "Run tests via `npm test`. New code requires corresponding unit tests."]
* **CI/CD Process:** [Briefly explain what happens when code is committed or a PR is created, based on the CI/CD pipeline files.]

## 7. Specific Instructions for AI Collaboration

* **Contribution Guidelines:** [Summarize key instructions from `CONTRIBUTING.md` or similar files. Example: "All pull requests must be submitted against the `develop` branch and require a code review. Sign the CLA."]
* **Infrastructure (IaC):** [Note if an Infrastructure as Code directory (e.g., `/iac`) exists. Add a warning. Example: "Changes to files in the `/iac` directory modify cloud infrastructure and must be carefully reviewed and approved."]
* **Security:** [Add a general reminder about security best practices. Example: "Be mindful of security. Do not hardcode secrets or keys. Ensure any changes to authentication logic (e.g., JWTs) are secure and vetted."]
* **Dependencies:** [Explain the process for adding new dependencies. Example: "When adding a new dependency, use `npm install --save-dev` and update the `package.json` file."]
* **Commit Messages:** [If a `.git` directory exists, analyze the commit history for patterns. Example: "Follow the Conventional Commits specification (e.g., `feat:`, `fix:`, `docs:`)."]