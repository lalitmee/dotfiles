---
alwaysApply: false
description: "Generate comprehensive tests for a target function, class, or module"
---

# Test Generation

## Purpose
Create thorough tests (happy path, edge, error cases) aligned with project conventions.

## Steps
1) Analyze the target (signature, behavior, branches, dependencies).
2) Detect test framework and patterns from existing tests if present.
3) Generate tests:
   - Happy paths
   - Edge cases and boundary conditions
   - Error/exception handling
   - Integration as applicable
4) Ensure coverage for branches and conditions; use Arrange-Act-Assert style.
5) Match project structure, imports, and setup/teardown conventions.

## Output
A complete test file ready to paste, including imports and any setup code.
