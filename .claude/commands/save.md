Save the current work state. This command handles both mid-task pauses and task completions.

## Steps

1. **Generate work report**: Create a report file at `.claude/docs/progress/reports/YYYY-MM-DD-HHmm.md` with:
   - Summary of what was done this session
   - Files changed (list with brief description of each change)
   - Decisions made and their rationale
   - Current status (completed / in progress / blocked)
   - If in progress: what remains to be done
   - If blocked: what is blocking and suggested resolution

2. **Update sprint progress**: Update `.claude/docs/progress/current-sprint.md`:
   - Mark completed tasks as done
   - Add notes on in-progress tasks
   - Add any newly discovered tasks

3. **Show summary**: Display a brief summary of what was saved

4. **Remind about clear**: End your response with:
   ```
   ---
   作業状態を保存しました。次のタスクに移る場合は /clear でコンテキストをリセットできます。
   ```
