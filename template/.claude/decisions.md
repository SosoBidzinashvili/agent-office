# Architecture Decisions — {{PROJECT_NAME}}

Read this before making any tech choice. Every non-obvious decision gets an ADR here,
recorded by the architect-agent at the time the decision is made — not retroactively.

Format:

## ADR-NNN — Title
**Date:**
**Status:** proposed | accepted | superseded by ADR-NNN
**Context:** what forced the decision
**Decision:** what we chose
**Alternatives considered:** what we rejected and why
**Consequences:** what this makes easy, what it makes hard

---

## ADR-001 — Agent workflow scheme

**Date:** {{DATE}}
**Status:** accepted
**Context:** New project. A multi-agent SDLC scheme with mandatory quality gates was
already proven on a prior project and extracted into a reusable template.
**Decision:** Adopt the `agent-office` template wholesale — 10 specialist agents in
`.claude/agents/`, `spec_template.md` as the canonical spec structure, the `phase-gate`
skill for gate validation, and the gate rules in `CLAUDE.md`.
**Alternatives considered:** Starting agents from scratch per project (rejected: no
reason to re-derive a working pipeline).
**Consequences:** Agent definitions are shared across projects — improvements should be
mirrored back to https://github.com/SosoBidzinashvili/agent-office rather than diverging
locally. Run `./update.sh` from that repo to pull newer agent definitions in.
