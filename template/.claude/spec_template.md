# BA Spec Template — Chveni Sopeli

Copy this file to `specs/phaseN_spec.md` and fill every section before implementation begins.
The orchestrator must present the completed spec to the user and record approval before any dev agent is invoked.

---

# Phase N — [Title]

**Author:** BA Agent
**Status:** Draft → Awaiting user approval → Approved
**Prerequisites:** Phase N-1 human gate passed (recorded in `.claude/phases.md`)

---

## 1. Goal

One paragraph. What problem does this phase solve? What is the observable outcome?

---

## 2. Risk & Spike

**Riskiest assumption:** _State the single assumption that, if wrong, would invalidate the whole phase._

**Spike required?** Yes / No

If yes: describe the thin vertical slice to validate before full build (target: < 2 hours, < $0.10 LLM cost). User must confirm spike output is acceptable before full phase build begins.

---

## 3. Phase N-1 Dependency Check

List what this phase depends on from the previous phase and confirm it is working:

| Dependency | Where it lives | Verified? |
|---|---|---|
| e.g. `POST /api/chat/{id}` returns 200 | Phase 4 | ✓ |

If any dependency is not working, this phase is blocked until it is resolved.

---

## 4. User Stories

_Format: As a [role], I can [action], so that [value]._

### [Feature area]
- As a …
- As a …

---

## 5. Data Model

Describe new or changed tables, columns, and indexes. If no schema changes: state "No schema changes."

For each new table:
```
table_name (
  id          uuid primary key default gen_random_uuid(),
  ...
  created_at  timestamptz default now()
)
indexes: ix_table_column
```

---

## 6. API Contract

For each new or changed endpoint:

```
METHOD /api/path/{param}

Request headers:
  X-Session-Token: <32-char hex>   (if auth required)

Request body (JSON):
  { "field": "type" }

Response 200:
  { "field": "type" }

Response errors:
  400 — validation failure: { "detail": "..." }
  401 — unauthenticated
  404 — resource not found
  429 — rate limited: { "detail": "...", Retry-After header }
  503 — LLM/service unavailable
```

If no new routes: state "No new routes."

---

## 7. Security

**This section is mandatory. Do not skip.**

### 7.1 Inputs & Validation

| Input | Source | Validation required |
|---|---|---|
| e.g. `message` body field | user | max 500 chars, strip whitespace, no HTML |
| e.g. `villager_id` path param | URL | UUID format, exists in DB |

### 7.2 Threat Model

List the top 3 threats relevant to this phase's new surface area:

1. **[Threat]** — Mitigation: …
2. **[Threat]** — Mitigation: …
3. **[Threat]** — Mitigation: …

If this phase introduces new routes: security-agent runs a dedicated pass before code-reviewer.
If this phase introduces auth changes: security-agent pass is mandatory.

### 7.3 Rate Limiting

Does any new endpoint need rate limiting? If yes, specify: window, max requests, key (IP / session token).
If no: state "No new rate-limited endpoints."

### 7.4 Secrets & Config

List every new secret or env var introduced. Confirm each is:
- Stored in `.env` only (never committed)
- Documented in `.env.example` with a placeholder value and inline comment
- Not logged at any level

### 7.5 Dependency Scan

`pip audit` and `npm audit` must be run before the QA gate. Zero new HIGH or CRITICAL findings before the phase gate passes. Document findings and mitigations here.

---

## 8. Acceptance Criteria

Each criterion is independently testable by the QA agent. Number them AC-1, AC-2, …

**AC-1 (…):** …
**AC-2 (…):** …

**Regression ACs (Phase N-1):** QA must re-run the prior phase's critical ACs and confirm they still pass.

---

## 9. Out of Scope

Explicitly list what is NOT being built in this phase, to prevent scope creep.

---

## Spec Approval Record

**Reviewed by user:** [ ] Yes
**Date:**
**Notes:**
