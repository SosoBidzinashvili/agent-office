---
name: phase-gate
description: Validate that a completed phase meets all acceptance criteria before marking it approved. Runs tests, exercises the running system, and produces a pass/fail report per criterion.
---

Validate Phase $ARGUMENTS against its acceptance criteria.

1. Read `specs/phase$ARGUMENTS_spec.md` for the acceptance criteria checklist
2. Use the qa-agent to run the test suite and map results to each criterion
3. Use the code-reviewer to review the diff for this phase
4. Use the tech-auditor for the mandatory pre-gate audit — its verdict must be visible to the user
5. For interface criteria: exercise the running system using the commands in `CLAUDE.md` § Running locally
6. Produce a final gate report:

```
PHASE $ARGUMENTS GATE REPORT

Acceptance criteria:
- [PASS/FAIL] each criterion with evidence

Phase N-1 regression: PASS / FAIL
Code review:  PASS / FAIL WITH FINDINGS
Tech audit:   HEALTHY / DEGRADED / BLOCKED

Overall: APPROVED / BLOCKED
Blockers: list if any
```

If APPROVED: update the gate log in `.claude/phases.md` with today's date.
If BLOCKED: list exactly what must be fixed before re-running this gate.
