#!/bin/bash
# PostToolUse hook: Auto-run lint/format after file edits
# Customize the LINT_COMMAND and FORMAT_COMMAND for your project

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# ============================================================
# TODO: Customize these commands for your project
# ============================================================
# Examples:
#   LINT_COMMAND="npx eslint --fix"        # Node.js
#   LINT_COMMAND="ruff check --fix"        # Python
#   LINT_COMMAND="gofmt -w"               # Go
#   FORMAT_COMMAND="npx prettier --write"  # Node.js
#   FORMAT_COMMAND="black"                 # Python

LINT_COMMAND=""
FORMAT_COMMAND=""

# ============================================================
# Auto-lint (skip if not configured)
# ============================================================
if [ -n "$LINT_COMMAND" ]; then
  $LINT_COMMAND "$FILE_PATH" 2>/dev/null
fi

# ============================================================
# Auto-format (skip if not configured)
# ============================================================
if [ -n "$FORMAT_COMMAND" ]; then
  $FORMAT_COMMAND "$FILE_PATH" 2>/dev/null
fi

exit 0
