#!/bin/bash
# Stop hook: Lightweight quality check when Claude finishes responding
# Warns about uncommitted changes but does NOT block

# Check for uncommitted changes
if git status --porcelain 2>/dev/null | grep -q '^'; then
  CHANGED_COUNT=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  echo "{\"systemMessage\": \"Note: ${CHANGED_COUNT} uncommitted file(s). Consider committing or running /save before /clear.\"}"
fi

exit 0
