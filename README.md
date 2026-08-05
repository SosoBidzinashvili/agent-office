# 🏢 Agent Office

A reusable **multi-agent build system** — plus a cozy, pixel-art **live office** that
visualizes the agents actually working through the pipeline when you give them a task.

Give a task, and watch named agents walk room-to-room, pick up the work, sit at their
desks, run it through every quality gate, and hand off the finished result — while idle
agents grab coffee ☕, rest on the sofa 😴, dance 🕺, or slip into the WC 🚽.

> Born out of the **Chveni Sopeli** (ჩვენი სოფელი) project, generalized so the same
> agent system can drive *any* project.

---

## ✨ The live office (`index.html`)

Just open `index.html` in a browser — no build, no dependencies.

- **Give a task** from the input, or use the preset chips (🆕 Feature / 🔧 Backend / 🚀 Deploy).
- Agents walk in real time (grounded tile pathfinding through doorways — no floating).
- The task flows **room-to-room**: an agent walks to the room holding the task, carries it
  to their own desk, works, passes each **gate** (spec → review → dep-scan → QA → verify →
  tech-audit → human gate), then delivers the finished work to the next room.
- Reviewer/auditor sometimes **FAIL** a step → the work bounces back to the Dev room, gets
  fixed, and comes back for re-review.
- Idle life: coffee, sofa naps, dancing, the WC, water-cooler chat — each with a thought bubble.

### Real-time bridge (URL params)

Launch the office pre-loaded with a task so it runs immediately:

```
index.html?task=<your task>&route=feature|backend|deploy&run=1
```

or `index.html#demo` for a quick auto-run. This is how a task given in chat can open the
live office and have the agents start working right away.

### The rooms

`📋 Spec` · `🎨 Design` · `⚙️ Dev` · `☕ Break Room` · `🔍 Review` · `🧪 QA` · `🕵️ Audit` · `🚻 WC` · `🛎️ Reception`

### The cast

| Agent | Role | Model tier |
|---|---|---|
| ნინო (Nino) | BA · spec | sonnet |
| გიორგი (Giorgi) | Architect | sonnet |
| თამარ (Tamar) | Designer | sonnet |
| ლელა (Lela) | Frontend | sonnet |
| ვახო (Vakho) | Backend | sonnet |
| ზაზა (Zaza) | DevOps | haiku |
| დათო (Dato) | Code Review | sonnet |
| მარიამ (Mariam) | QA | haiku |
| ბექა (Beka) | Verifier | sonnet |
| ირაკლი (Irakli) | Tech Auditor 👑 | sonnet |
| მაესტრო (Maestro) | Orchestrator | — |

---

## 🧠 The system (`template/`)

The office visualizes a real, opinionated multi-agent workflow. The reusable pieces:

```
template/.claude/
├── agents/          # 11 specialist subagent definitions (BA, architect, dev, review, QA, audit…)
└── spec_template.md # canonical spec structure every phase must fill
docs/agent_workflow.md   # the roster + full pipeline & gate diagram (Mermaid)
```

Each agent has a fixed role, a model tier (haiku for tests/docs/DevOps, sonnet for
spec/design/impl/review/audit), and a place in the pipeline. Gates are mandatory:

```
BA spec → 🚦 user approves spec → spike → 🚦 user confirms → [architect/design]
→ dev agents → code-reviewer (PASS to commit) → dep scan → QA (+regression)
→ phase-verifier → 🚦 tech-auditor (GO/NO-GO) → 🚦 HUMAN GATE
```

See **[`docs/agent_workflow.md`](docs/agent_workflow.md)** for the full roster table and
Mermaid diagrams.

### Reusing it on a new project

1. Copy `template/.claude/` into your new project root.
2. Adapt the agent definitions (tech stack, conventions, project name) — they currently
   reference the Chveni Sopeli stack (FastAPI + Next.js) as a worked example.
3. Keep the gate discipline: spec approval before dev, code-review before commit,
   tech-audit before every human gate.
4. Open `index.html` to visualize your team at work.

---

## Notes

- The office is a **visualization** of the workflow — a static HTML file. It runs in real
  time when you launch a task, but it does not (yet) observe live subagent execution. A
  small local server could bridge real agent progress into the office — a future add-on.
- Pure HTML/CSS/Canvas. No frameworks, no build step, works offline.

🤖 Built with [Claude Code](https://claude.com/claude-code).
