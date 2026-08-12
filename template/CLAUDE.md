# {{PROJECT_NAME}}

> One paragraph: what this project is, who it's for, and what makes it worth building.

## Current Phase

**Phase 0 — Discovery**
Status: Not started.
Next: BA spec for Phase 1.

Full phase detail: `.claude/phases.md`
Architecture decisions (read before any tech choice): `.claude/decisions.md`

## Tech stack

> Fill this in as the architect-agent records ADRs. Every dev agent reads this section
> instead of hardcoding a stack, so keep it accurate.

- **Backend:**
- **Frontend:**
- **Data:**
- **External services:**

## Running locally

```bash
# TODO: the single command that starts everything
# TODO: seed / migrate
# TODO: run tests
# TODO: build / typecheck
```

## Visual language

> The design-agent and frontend-dev read this section. If the project has no UI, delete it.
> If it has a UI, define it here — palette, typography, spacing, tone — so agents never
> invent one. Name the token/theme file; agents must use tokens, never raw hex values.

## Non-obvious rules

> Project-specific conventions an agent could not infer from the code. Keep it short —
> every line here is read by every agent on every task.

- Code Reviewer approves before any commit. QA passes before human gate.
- **Tech-auditor runs automatically before every human gate.** When a phase's deliverables are complete, the orchestrator MUST invoke the tech-auditor agent without being asked. The auditor's verdict (HEALTHY / DEGRADED / BLOCKED) is reported to the user before they are asked to approve the gate. Do not present a phase as ready for human gate until the tech-auditor has run and its findings are visible.
- No phase advances without the previous phase's human gate being recorded in `.claude/phases.md`.

### Spec approval gate
- **BA spec must be approved by the user BEFORE any dev agent is invoked.** Present the spec (user stories + interface contract + ACs + Security section) and wait for explicit user sign-off. The human gate at phase end should confirm, not discover.
- Use `.claude/spec_template.md` as the canonical structure for every new spec. Specs live in `specs/phaseN_spec.md`.

### Tiered code review
- Config / env / docs changes → lightweight scan (correctness only).
- New utility functions → standard review (correctness + conventions).
- New API routes → deep review (correctness + security + error handling).
- LLM agents / prompts → deep review + manual eval of a sample output.
- Auth / secrets / payments → maximum depth + mandatory security pass before code-reviewer.

### Security is a phase-1 concern, not a phase-8 concern
- Every BA spec must include a `§ Security` section: inputs + validation, threat model, rate limiting decision, secrets handling.
- Dependency audits run as part of every QA gate. Zero new HIGH or CRITICAL findings before the gate passes.

### Mid-phase light audit
- After the first working deliverable of a phase: run a lightweight tech-auditor pass.
- Full tech-auditor still runs at end-of-phase as the gate.

### Phase regression check
- QA must re-run the prior phase's critical ACs as part of the current phase gate.
- All prior-phase ACs must still pass before the human gate is presented.

### Risk-first spike
- Every phase spec must name the riskiest assumption.
- Validate it with a thin vertical slice (target: < 2 hours, < $0.10 LLM cost) before full build.
- User confirms spike output before full phase build begins.

## Builder agents

Use the specialist subagents in `.claude/agents/` for each role. Invoke explicitly:
_"Use the ba-agent to write the spec for Phase 1"_
_"Use the code-reviewer to review the diff"_

Roster: ba-agent, architect-agent, design-agent, frontend-dev, backend-dev, devops-agent,
code-reviewer, qa-agent, phase-verifier, tech-auditor.

Pipeline and gates: `docs/agent_workflow.md` in the agent-office repo is the canonical
diagram. When an agent is added, removed, retooled or re-tiered here, mirror the change
back to https://github.com/SosoBidzinashvili/agent-office (`template/.claude/` and
`docs/agent_workflow.md`) so the next project inherits the improvement.

## When compacting

Always preserve: current phase status, list of files modified this session, any failing tests or blockers.
