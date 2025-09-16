# VectorCode Smart Vectorization

This repository uses VectorCode with smart vectorization that automatically indexes your code changes for semantic search and AI assistance.

## How It Works

The pre-commit hook automatically determines which files to vectorize based on:

1. **File location**: Files in `src/`, `lib/`, `app/`, `components/`, `pages/`, `routes/` directories
2. **File type**: Source code files (`.py`, `.js`, `.ts`, etc.) and documentation (`.md`)
3. **File importance**: Configuration files, package definitions, and documentation

## Control Methods

### 1. Automatic Mode (Default)
Only high-value files are vectorized automatically:
```bash
git add .
git commit -m "Update feature"
```

### 2. Manual Trigger
Vectorize all staged files for this commit only:
```bash
touch .vectorize-trigger
git commit -m "Major refactoring"
# Or use the helper:
vectorize-control trigger
git commit -m "Major refactoring"
```

### 3. Environment Variable
Vectorize all staged files:
```bash
VECTORIZE_ALL=1 git commit -m "Comprehensive update"
```

### 4. Temporary Disable
Skip vectorization for this commit:
```bash
touch .vectorize-disable
git commit -m "Minor typo fix"
# Or use the helper:
vectorize-control disable
git commit -m "Minor typo fix"
```

### 5. Helper Script
Use the `vectorize-control` script for easier management:
```bash
vectorize-control help      # Show help
vectorize-control status    # Show current status
vectorize-control list      # Show what would be auto-vectorized
vectorize-control clean     # Clean up control files
```

## File Selection Rules

### Always Vectorized (Manual/Environment Mode):
- All files except dependencies and build artifacts

### Auto-Vectorized Files:
- Source code in `src/`, `lib/`, `app/` directories (excluding tests)
- Documentation files (`README.md`, `docs/*.md`, etc.)
- Key configuration files (`package.json`, `Dockerfile`, etc.)

### Never Vectorized:
- Test files (`*.test.*`, `*.spec.*`, `test/`, `__tests__/`)
- Dependencies (`node_modules/`)
- Build artifacts (`build/`, `dist/`, `target/`)