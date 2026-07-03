---
name: debug
description: Analyzes error logs, stack traces, and provides systematic debugging strategies and solutions
---

Help debug the issue described by the user.

## CRITICAL FORMAT REQUIREMENTS

1. Present a structured debugging plan with clear steps
2. Include specific commands and tools for the relevant technology stack
3. Provide minimal reproduction cases where possible
4. Include prevention strategies to avoid recurrence
5. Document findings and verification steps
6. MUST use the `question` tool for EVERY user interaction — never ask questions as plain text

## Workflow

### 1. Error Analysis
- Parse and interpret the error message/stack trace
- Identify the root cause and error location
- Determine error type (syntax, runtime, logic, etc.)
- Check recent commits for potential causes: Run `git log --oneline -5`

### 2. Context Gathering
- Check current branch and status: Run `git status --porcelain`
- Look for recent changes in related files
- Examine log files if available: Run `find . -name "*.log" -newer -1 | head -5`
- Check environment configuration

### 3. Systematic Debugging Steps
- **Step 1:** Reproduce the issue consistently
- **Step 2:** Isolate the problematic code section
- **Step 3:** Add strategic logging/debugging statements
- **Step 4:** Use debugging tools appropriate for the technology stack
- **Step 5:** Test potential fixes incrementally

### 4. Common Issue Patterns
- Check for null/undefined reference errors
- Look for async/await and Promise handling issues
- Verify variable scope and closure problems
- Check for type mismatches and casting issues
- Examine dependency version conflicts

### 5. Technology-Specific Debugging
- **JavaScript/Node.js:** Check console logs, use debugger statements
- **Python:** Use pdb, check traceback carefully
- **Java:** Examine stack trace, check classpath issues
- **Database:** Query execution plans, check connections
- **Network:** Check API endpoints, authentication, CORS

### 6. Tools and Techniques
- Recommend appropriate debugging tools for the tech stack
- Suggest logging strategies and instrumentation
- Provide breakpoint placement recommendations
- Recommend profiling tools if performance-related

### 7. Verification Steps
- Create minimal reproduction case
- Test fix in isolation
- Verify no regression in related functionality
- Add tests to prevent future occurrences

### 8. Prevention Strategies
- Suggest code improvements to prevent similar issues
- Recommend better error handling patterns
- Identify missing validation or checks
- Suggest monitoring and alerting improvements

### 9. Documentation
- Document the debugging process for team knowledge
- Create troubleshooting guide for similar issues
- Update error handling documentation

Provide a step-by-step debugging plan with specific commands, tools, and verification steps tailored to the error and technology stack.
