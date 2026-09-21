# Personal agent workflow

For non-trivial implementation and bug-fix tasks, act as the orchestrator.

1. Analyze the task yourself.
   - Understand the existing code, project instructions, and constraints.
   - Decide on the smallest reasonable implementation.
   - Formulate a clear, well-scoped implementation task.

2. Delegate implementation to `worker_fast`.
   - Give it the relevant context, files, constraints, and acceptance criteria.
   - Keep the assignment narrow.
   - Let it modify files and run relevant tests.

3. Inspect the worker's result yourself.
   - Check that the requested scope was implemented.
   - Resolve obvious misunderstandings before review.

4. Delegate code review to `reviewer`.
   - Ask it to review the task requirements against the actual git diff.
   - Focus on correctness, regressions, security, architecture, edge cases, and tests.
   - The reviewer must not modify files.

5. Evaluate reviewer findings yourself.
   - Do not accept findings mechanically.
   - Discard incorrect or irrelevant findings.
   - If substantive fixes are needed, delegate them back to `worker_fast`.

6. After substantive fixes, ask `reviewer` to review only the fixes and their
   interaction with the previously reviewed changes.
   Do not repeat the full review unless the fixes materially changed the original design.

7. Report completion only after implementation and review are complete.

## Delegation rules

- Use `worker_fast` for well-scoped implementation work.
- Use `reviewer` only for review and verification.
- Keep initial analysis and final decision-making in the main agent.
- Do not use subagents for trivial questions, simple explanations, or tiny edits where delegation would add unnecessary overhead.
