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

### 🔴 Live mode — Claude drives the office in real time

The office can mirror **real** work as it happens. Claude appends events to
`live/status.json`; the office polls it (every 0.9s) and animates the agents through the
real pipeline — the chat input is disabled and the header shows `🔴 LIVE`.

```bash
# 1. serve the folder (fetch() needs http, not file://)
python3 -m http.server 8777 --directory .
# 2. open the office in live mode
open "http://127.0.0.1:8777/?live=1"
# 3. drive it as the work happens (Claude does this per pipeline stage):
python3 live/emit.py reset
python3 live/emit.py user  "add a filter to the market page"
python3 live/emit.py orc   "direction: 🆕 Feature — assigning the team"
python3 live/emit.py start nino  "📝 spec"   "user stories + API + ACs"
python3 live/emit.py gate  "SPEC APPROVED ✅"
python3 live/emit.py start vakho "⚙️ Backend" "route + model + tests"
python3 live/emit.py gate  "code-review PASS ✅"      # add "fail" as 3rd arg for a red gate
python3 live/emit.py done  "🎉 SHIPPED — commit a1b2c3d"
```

Event types: `reset · user · orc · start <agent> <label> <text> · gate <text> [fail] · done <text>`.
Agent ids: `nino giorgi tamar lela vakho zaza dato mariam beka irakli maestro`.

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
init.sh                       # bootstrap a new project (or --update an existing one)
template/
├── CLAUDE.md                 # orchestration rules + gate discipline (project fills the TODOs)
└── .claude/
    ├── agents/               # 10 specialist subagent definitions
    ├── skills/phase-gate/    # /phase-gate N — chains QA + review + audit into one report
    ├── spec_template.md      # canonical spec structure every phase must fill
    ├── phases.md             # phase roadmap + human-gate log
    └── decisions.md          # ADR log — read before any tech choice
docs/agent_workflow.md        # the roster + full pipeline & gate diagram (Mermaid)
```

The agents are **stack-agnostic**. Instead of hardcoding a framework, each one reads
`CLAUDE.md` for the tech stack, run/test commands, visual language, and project rules —
so the same roster drives a Python API, a Next.js app, or anything else. Model tiers use
aliases (`sonnet`, `haiku`) rather than pinned IDs, so the roster doesn't rot when a new
model ships.

Each agent has a fixed role, a model tier (haiku for tests/docs/DevOps, sonnet for
spec/design/impl/review/audit), and a place in the pipeline. Gates are mandatory:

```
BA spec → 🚦 user approves spec → spike → 🚦 user confirms → [architect/design]
→ dev agents → code-reviewer (PASS to commit) → dep scan → QA (+regression)
→ phase-verifier → 🚦 tech-auditor (GO/NO-GO) → 🚦 HUMAN GATE
```

See **[`docs/agent_workflow.md`](docs/agent_workflow.md)** for the full roster table and
Mermaid diagrams.

### Starting a new project

```bash
git clone https://github.com/SosoBidzinashvili/agent-office.git
cd agent-office
./init.sh ~/code/my-new-project "My New Project"
```

Then open the project and fill in the TODOs:

```bash
cd ~/code/my-new-project
claude
# 1. CLAUDE.md — concept, tech stack, run/test commands, visual language
# 2. .claude/phases.md — the phase roadmap
# 3. "Use the ba-agent to write the spec for Phase 1"
```

### Improving the scheme, and propagating the improvement

`init.sh` splits the files into two classes:

| Class | Files | Owner |
|---|---|---|
| **Shared** | `.claude/agents/`, `.claude/skills/`, `.claude/spec_template.md` | this repo |
| **Project** | `CLAUDE.md`, `.claude/phases.md`, `.claude/decisions.md` | the project |

So when you improve an agent while working on a real project, commit it back here, then
pull it into every other project:

```bash
./init.sh --update ~/code/some-other-project
```

`--update` overwrites the shared files and never touches the project-owned ones. Re-running
plain `init.sh` on an existing project refuses rather than clobbering it.

Keep the gate discipline in every project: spec approval before dev, code-review before
commit, tech-audit before every human gate. And when you add, remove, retool, or re-tier an
agent, update `docs/agent_workflow.md` in the same change — the roster table and the Mermaid
diagrams are the canonical picture.

---

## Notes

- The office is a **visualization** of the workflow — a static HTML file. It runs in real
  time when you launch a task, but it does not (yet) observe live subagent execution. A
  small local server could bridge real agent progress into the office — a future add-on.
- Pure HTML/CSS/Canvas. No frameworks, no build step, works offline.

🤖 Built with [Claude Code](https://claude.com/claude-code).
