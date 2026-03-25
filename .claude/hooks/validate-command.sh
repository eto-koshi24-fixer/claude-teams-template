#!/bin/bash
# PreToolUse hook: Block dangerous Bash commands
# Exit code 0 = allow, Exit code 2 = block

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Block destructive patterns
BLOCKED_PATTERNS=(
  'rm -rf /'
  'rm -rf \.'
  'rm -rf \*'
  'sudo '
  'git push --force'
  'git push -f '
  'git reset --hard'
  'git clean -fd'
  'git checkout -- \.'
  ':(){:|:&};:'
  'mkfs\.'
  'dd if='
  '> /dev/sd'
  'chmod -R 777'
  'curl.*| ?sh'
  'wget.*| ?sh'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "Blocked: Dangerous command detected — $pattern" >&2
    exit 2
  fi
done

exit 0
