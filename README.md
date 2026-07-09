# Skilladiko

A collection of AI agent skills and agents following the [agentskills.io](https://agentskills.io) open standard. Works with Claude Code, GitHub Copilot, Cursor, Windsurf, and other agent-based development tools.

Supercharge your software engineering workflow with skills to plan, implement, research, and commit code changes more effectively.

## Repository Layout

```text
skilladiko/
├── skills/        # User-invoked workflows (each has a SKILL.md)
├── agents/        # Specialized research/analysis subagents (each has an AGENT.md)
└── scripts/       # Installation and maintenance scripts
```

## What's Included

### 🎯 Skills

**Skills** are user-invoked workflows that handle common development tasks. Invoke them with `/skill-name` in your agent interface (e.g., `/commit` in Claude Code).

| Skill | Purpose |
|-------|---------|
| **`commit`** | Create git commits with clear, atomic messages and full user control (no Claude attribution). |
| **`handoff`** | Write or update a handoff document so the next agent with fresh context can continue the work. |
| **`spec-grooming`** | Explore a ticket's problem space using Socratic probing. Uncover undocumented decisions, expose systemic gaps, and ensure complete understanding before dev starts. |
| **`grill-me`** | Interview you relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. |
| **`to-issues`** | Break a plan, spec, or PRD into independently-grabbable GitHub issues using tracer-bullet vertical slices. |
| **`zoom-out`** | Step back and give broader context or a higher-level perspective on a section of code. |
| **`caveman`** | Ultra-compressed communication mode that cuts token usage ~75% while keeping full technical accuracy. |
| **`rails-code-review`** | Review Ruby code for clean-code principles and improve readability and maintainability. |
| **`ruby-debug`** | Debug a failing Ruby test by setting a breakpoint and inspecting state (bash + tmux, no gem dependencies). |

#### QRSPI Workflow

QRSPI is a phased workflow for breaking down complex coding tasks systematically:

| Skill | Purpose |
|-------|---------|
| **`qrspi-question`** | Decompose a task into neutral research questions. |
| **`qrspi-research`** | Objective codebase research driven by questions — facts only, no opinions. |
| **`qrspi-design`** | Design discussion — align on where we are going before planning how. |
| **`qrspi-structure`** | Structure outline — vertical slices with test checkpoints. |
| **`qrspi-plan`** | Tactical implementation plan — the agent's working document. |
| **`qrspi-worktree`** | Create an isolated git worktree for implementation. |
| **`qrspi-implement`** | Execute the plan phase by phase with verification checkpoints. |
| **`qrspi-pr`** | Create a pull request with context from the design discussion. |

### 🤖 Research Agents

**Agents** are specialized assistants that handle specific research and analysis tasks. They run in parallel for efficiency and are used internally by skills to understand your codebase. See [Agents.md](Agents.md) for full details.

| Agent | Purpose |
|-------|---------|
| **`codebase-locator`** | Fast agent for finding files, directories, and components relevant to a feature. Use when you need to locate code quickly. |
| **`codebase-analyzer`** | Analyzes codebase implementation details. Great for understanding how existing features work and finding integration points. |
| **`codebase-pattern-finder`** | Finds similar implementations and usage examples. Perfect for discovering patterns to model after. |
| **`thoughts-locator`** | Discovers relevant documents in your `thoughts/` directory for finding metadata, decisions, and context. |
| **`thoughts-analyzer`** | Deep-dives into research documents to extract key insights and findings. |
| **`web-search-researcher`** | Researches topics on the web when you need current information beyond your knowledge cutoff. |

## Installation

### Quick Start

Clone the repository and run the installation script:

```bash
git clone https://github.com/ervis/skilladiko.git
cd skilladiko

# For Claude Code (default) — links to ~/.claude/skills and ~/.claude/agents
./scripts/link-skills.sh

# OR for other tools using the .agents/ standard — links to ~/.agents/skills and ~/.agents/agents
./scripts/link-skills.sh agents
```

This creates symlinks in your local agent directory pointing at the `skills/` and `agents/` directories in this repo. All skills and agents use the [agentskills.io](https://agentskills.io) standard format, making them compatible with any agent system that supports the standard.

### Manual Installation

If you prefer to install manually:

#### Option 1: Copy Files (Recommended for isolated setups)

```bash
# Copy all skills and agents
cp -r skills/*  ~/.claude/skills/
cp -r agents/*  ~/.claude/agents/
```

#### Option 2: Create Symlinks (Recommended for development)

```bash
# For Claude Code
mkdir -p ~/.claude/skills ~/.claude/agents
for dir in /path/to/skilladiko/skills/*/; do
  ln -s "$dir" ~/.claude/skills/$(basename "$dir")
done
for dir in /path/to/skilladiko/agents/*/; do
  ln -s "$dir" ~/.claude/agents/$(basename "$dir")
done
```

### Verify Installation

After installation, verify your setup:

```bash
# Check that skills and agents are linked correctly
ls ~/.claude/skills/      # Should list the skill directories, each with a SKILL.md
ls ~/.claude/agents/      # Should list the agent directories, each with an AGENT.md
```

Then reload your agent tool (Claude Code, Copilot, Cursor, etc.) for the new skills to become available.

## Usage Guide

All skills work the same way across agent systems. Use the skill name with a leading `/` in your agent chat.

### QRSPI Workflow

QRSPI breaks complex coding tasks into ordered phases:

```text
Question → Research → Design → Structure → Plan → Worktree → Implement → PR
```

**Quick Start:**
```bash
/qrspi-question "Your task here"     # Decompose into research questions
/qrspi-research <artifact_path>/     # Research the codebase (facts only)
/qrspi-design <artifact_path>/       # Align on the approach
/qrspi-structure <artifact_path>/    # Break into vertical slices
/qrspi-plan <artifact_path>/         # Create the tactical plan
/qrspi-worktree <artifact_path>/     # Set up an isolated worktree
/qrspi-implement <artifact_path>/    # Implement phase by phase
/qrspi-pr <artifact_path>/           # Open the pull request
```

Configure with `.qrspi` in your project root:
```sh
issues_dir=/path/to/vault/issues
shared_dir=/path/to/vault/shared
```

[Learn more about QRSPI](https://github.com/matanshavit/qrspi)

### Ticket Specification Review

Before a ticket goes to development, use spec-grooming to explore its problem space:

```bash
/spec-grooming
```

Paste or reference your ticket. The skill will:
1. Ask probing questions across 7 exploration themes
2. Surface undocumented decisions and assumptions
3. Expose gaps in problem understanding
4. Identify systemic inconsistencies with existing patterns
5. Ensure dev has complete context to start work

Helps catch PO blindspots early: scope creep, missing business rules, cascading effects, lifecycle gaps.

### Creating Commits

After making changes, create a clean commit:

```bash
/commit
```

This will:
1. Review your changes
2. Suggest logical groupings
3. Create atomic, well-described commits (no Claude attribution)
4. Follow repository conventions

### Researching Your Codebase

The QRSPI research skills and the research agents spawn focused subagents in parallel to:

- Find relevant files and components (`codebase-locator`)
- Analyze implementation patterns (`codebase-analyzer`)
- Discover examples to model after (`codebase-pattern-finder`)
- Return specific `file:line` references

### Reviewing and Debugging Ruby

```bash
/rails-code-review    # Clean-code review of Ruby changes
/ruby-debug           # Set a breakpoint and inspect a failing test
```

## Key Features

### 🔍 Intelligent Research
- Runs multiple agents simultaneously
- Finds relevant files quickly
- Identifies patterns and conventions
- Extracts key architectural insights
- Returns specific code references

### ✅ Verification Built-in
- Success criteria at each QRSPI phase
- Separated into automated and manual checks
- Guides you through verification
- Tracks progress

### 📝 Clean Commits
- Logical, atomic commits
- Descriptive messages
- Follows your repository style
- No unwanted attribution
- Full user control

## Maintenance

### Bump Version

Version tags are managed with `scripts/bump-version` (semantic versioning via git tags):

```bash
./scripts/bump-version              # Bump patch
./scripts/bump-version minor        # Bump minor
./scripts/bump-version major --push # Bump major and push the tag
./scripts/bump-version --show       # Show current version
```

## Troubleshooting

### Commands not showing up

1. Verify installation:
   ```bash
   ls ~/.claude/skills/
   ```
2. Reload Claude Code or restart the application.
3. Check that each skill directory contains a `SKILL.md`.

### Agents not running

1. Ensure symlinks are correct:
   ```bash
   ls -l ~/.claude/agents/
   ```
2. Check that your agent tool has agent/subagent support enabled.
3. Verify agent files have the correct format (YAML frontmatter + markdown).

### Permission errors

Some operations require user approval. When prompted:
- Review the requested operation
- Approve once to proceed
- Deny to skip (and adjust your approach)

## Requirements

- **Claude Code** CLI or IDE extension (or another agentskills.io-compatible tool)
- **Git** (for commit and worktree skills)
- **~/.claude/** directory (created automatically)

No other dependencies required!

## Contributing

Found a bug? Have a suggestion? Contributions welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT

## Credits

Inspired by and adapted from

- [humanlayer/humanlayer](https://github.com/humanlayer/humanlayer)
- [mattpocock/skills](https://github.com/mattpocock/skills)

---

**Happy coding!** Use these skills to build better, faster, and with more confidence. 🚀
