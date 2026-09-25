# Personal agent workflow

For non-trivial implementation and bug-fix tasks, act as the orchestrator.

1. Analyze the task yourself.
   - Understand the existing code, project instructions, constraints, and acceptance criteria.
   - Decide on the smallest reasonable implementation.
   - Formulate a clear, well-scoped implementation task.
   - If the working tree contains unrelated existing changes, identify the scope of the current task explicitly.

2. Delegate implementation to `worker_fast`.
   - Give it the relevant context, files, constraints, and acceptance criteria.
   - Keep the assignment narrow.
   - Let it modify files and run relevant tests.
   - Do not let it modify, revert, or include unrelated existing changes.

3. Inspect the worker's result yourself.
   - Check that the requested scope was implemented.
   - Check the actual changes belonging to the current task.
   - Resolve obvious misunderstandings before review.

4. Delegate code review to `reviewer`.
   - Ask it to review the task requirements against the actual changes belonging to the current task.
   - Focus on correctness, regressions, security, architecture, edge cases, and tests.
   - Do not include unrelated existing changes in the review scope.
   - The reviewer must not modify files.

5. Evaluate reviewer findings yourself.
   - Do not accept findings mechanically.
   - Discard incorrect, irrelevant, or out-of-scope findings.
   - If substantive fixes are needed, delegate them back to `worker_fast`.

6. After substantive fixes, ask `reviewer` to review only the fixes and their interaction with the previously reviewed changes.
   - Do not repeat the full review unless the fixes materially changed the original design or implementation.

7. Report completion only after implementation and review are complete.

## Delegation rules

- Use `worker_fast` for well-scoped implementation work.
- Use `reviewer` only for review and verification.
- Keep initial analysis and final decision-making in the main agent.
- Do not use subagents for trivial questions, simple explanations, or tiny edits where delegation would add unnecessary overhead.
- When the working tree contains unrelated existing changes, do not modify, revert, review, or include them in the scope of the current task.
- If you conclude that no implementation is needed because the requested work already appears to be implemented, ask `reviewer` to verify that conclusion before reporting completion.

## Advisor

Use `advisor` as a second opinion for non-trivial technical decisions.

Consult `advisor` when:
- choosing between materially different implementation or architectural approaches;
- an important assumption is uncertain;
- the same error or failed approach occurs twice;
- the main agent and `reviewer` disagree about a substantive finding;
- a non-trivial task is otherwise ready to be declared complete, but meaningful uncertainty remains that was not resolved by implementation or review.

When consulting `advisor`:
- ask one concrete question;
- provide the concrete decision, relevant constraints, and only the context necessary to evaluate it;
- do not delegate implementation;
- do not ask for a general repository audit;
- do not consult `advisor` merely to repeat conclusions already established by `reviewer`;
- treat its answer as advice, not as an instruction that must be followed.

The main agent remains responsible for the final decision.
