# Skilladiko

A collection of AI agent skills and commands following the [agentskills.io](https://agentskills.io) open standard. Works with Claude Code, GitHub Copilot, Cursor, Windsurf, and other agent-based development tools.

Supercharge your software engineering workflow with skills to plan, implement, research, and commit code changes more effectively.

## What's Included

### 🎯 Skills

**Skills** are user-invoked workflows that handle common development tasks. Invoke them with `/skill-name` in your agent interface (e.g., `/create-plan` in Claude Code).

| Skill | Purpose |
|-------|---------|
| **`create-plan`** | Create detailed implementation plans with thorough research and iteration. Perfect for breaking down complex features into actionable phases. |
| **`implement-plan`** | Execute pre-created implementation plans with verification steps and progress tracking. |
| **`research-codebase`** | Comprehensively research your codebase using parallel sub-agents to find patterns, understand architecture, and analyze implementation details. |
| **`commit`** | Create git commits with clear, atomic messages and full user control (no Claude attribution). |
| **`ci-commit`** | Create commits optimized for CI/CD workflows with automatic attribution. |

### 🤖 Research Agents

**Agents** are specialized assistants that handle specific research and analysis tasks. They run in parallel for efficiency and are used internally by skills to understand your codebase.

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

# For Claude Code (default)
./scripts/link-skills.sh

# OR for other tools using .agents/ standard
./scripts/link-skills.sh agents
```

This creates symlinks in your local agent directory linking from the `.agents/skills/` directory in this repo. All skills and agents use the [agentskills.io](https://agentskills.io) standard format, making them compatible with any agent system that supports the standard.

### Manual Installation

If you prefer to install manually:

#### Option 1: Copy Files (Recommended for isolated setups)

```bash
# Copy all skills and agents
cp -r .agents/skills/* ~/.claude/skills/
```

#### Option 2: Create Symlinks (Recommended for development)

```bash
# For Claude Code
mkdir -p ~/.claude/skills
for dir in /path/to/skilladiko/.agents/skills/*/; do
  ln -s "$dir" ~/.claude/skills/$(basename "$dir")
done

# OR for .agents/ standard
mkdir -p ~/.agents/skills
for dir in /path/to/skilladiko/.agents/skills/*/; do
  ln -s "$dir" ~/.agents/skills/$(basename "$dir")
done
```

### Verify Installation

After installation, verify your setup:

```bash
# Check if skills are linked correctly
ls ~/.claude/skills/      # For Claude Code installation
# or
ls ~/.agents/skills/      # For .agents/ standard installation

# Should show 11 directories (commit, create_plan, etc.) with SKILL.md files inside each
ls ~/.claude/skills/commit (or /ci-commit for CI workflows)/  # Should contain SKILL.md
```

Then reload your agent tool (Claude Code, Copilot, Cursor, etc.) for the new skills to become available.

## Usage Guide

All skills work the same way across agent systems. Use the skill name with a leading `/` in your agent chat:

### Creating an Implementation Plan

The typical workflow starts with planning:

```
/create-plan
```

This interactive skill will:
1. Gather context about what you want to build
2. Research your codebase for relevant patterns
3. Help you design the implementation approach
4. Generate a detailed, phase-based plan

**Example**: Planning a new authentication feature
```
User: /create-plan
Assistant: I'll help you create a detailed implementation plan...
User: We need to add OAuth2 support. See ticket ENG-123.
Assistant: [Reads ticket, researches codebase, asks clarifying questions...]
```

### Executing a Plan

Once you have a plan:

```bash
/implement-plan thoughts/shared/plans/2026-04-16-oauth2-support.md
```

This will:
1. Load and review your plan
2. Guide you through each implementation phase
3. Verify success criteria after each phase
4. Track progress

### Researching Your Codebase

To understand how something works:

```bash
/research-codebase
```

This spawns multiple agents in parallel to:
- Find relevant files and components
- Analyze implementation patterns
- Identify architecture and conventions
- Return specific file:line references

### Creating Commits

After making changes, create a clean commit:

**For regular commits** (user-attributed):
```bash
/commit (or /ci-commit for CI workflows)
```

**For CI/CD commits** (Claude-attributed):
```bash
/ci_commit
```

Both commands will:
1. Review your changes
2. Suggest logical groupings
3. Create atomic, well-described commits
4. Follow repository conventions

## Workflow Examples

### Example 1: Adding a New Feature

```bash
# 1. Create a plan
/create-plan

# 2. Follow the planning dialog
# (research, ask questions, refine approach)

# 3. Get approval and review the plan file
# 4. Start implementation
/implement-plan thoughts/shared/plans/YYYY-MM-DD-feature.md

# 5. Follow each phase with verification
# 6. Commit your work
/commit (or /ci-commit for CI workflows)
```

### Example 2: Understanding Existing Code

```bash
# 1. Research the codebase
/research-codebase

# 2. Agents will find and analyze related code
# (runs in parallel for speed)

# 3. Review findings to understand the architecture
# 4. Use insights to inform your changes
```

### Example 3: Refactoring with Confidence

```bash
# 1. Create a plan for the refactoring
/create-plan

# 2. Specify scope carefully
# (what you're NOT changing)

# 3. Get detailed phase-by-phase guidance
/implement-plan [your-plan-file]

# 4. Verify each phase works
# 5. Commit with clear messages
/commit (or /ci-commit for CI workflows)
```

## Key Features

### 🎯 Interactive Planning
- Gathers context automatically
- Researches your codebase in parallel
- Asks clarifying questions
- Proposes design options
- Iterates until you're confident

### 🔍 Intelligent Research
- Runs multiple agents simultaneously
- Finds relevant files quickly
- Identifies patterns and conventions
- Extracts key architectural insights
- Returns specific code references

### ✅ Verification Built-in
- Success criteria at each phase
- Separated into automated and manual checks
- Guides you through verification
- Tracks progress

### 📝 Clean Commits
- Logical, atomic commits
- Descriptive messages
- Follows your repository style
- No unwanted attribution
- Full user control

## Configuration

The skills work with Claude Code's built-in features. No additional configuration needed for basic usage.

### Optional: Custom Settings

You can customize behavior through Claude Code settings:

```bash
# Open settings
/update-config
```

Common customizations:
- Model selection for planning agents (Opus for complex planning)
- Permission levels for file operations
- Custom commit message templates

## Troubleshooting

### Commands not showing up

1. Verify installation:
   ```bash
   ls ~/.claude/skills/
   ```

2. Reload Claude Code or restart the application

3. Check that files are readable:
   ```bash
   file ~/.claude/skills/commit (or /ci-commit for CI workflows).md
   ```

### Agents not running

1. Ensure symlinks are correct:
   ```bash
   ls -l ~/.claude/agents/
   ```

2. Check Claude Code has agent support enabled

3. Verify agent files have correct format (YAML frontmatter + markdown)

### Permission errors

Some operations require user approval. When prompted:
- Review the requested operation
- Approve once to proceed
- Deny to skip (and adjust your approach)

## Performance Tips

### For Large Codebases

- Use `codebase-locator` first to narrow scope
- Specify file patterns in agent prompts
- Break research into focused questions
- Use `codebase-pattern-finder` to find examples quickly

### For Complex Plans

- Start with `/create-plan` for interactive guidance
- Let agents research in parallel (they run concurrently)
- Review findings before planning
- Break into smaller phases for clarity

### For Better Commits

- Use `/commit (or /ci-commit for CI workflows)` for thoughtful, atomic commits
- Group related changes together
- Write messages that explain *why*, not just *what*
- Review the diff before confirming

## Requirements

- **Claude Code** CLI or IDE extension
- **Git** (for commit commands)
- **~/.claude/** directory (created automatically)

No other dependencies required!

## Getting Help

### Within Claude Code

All commands include built-in help:

```bash
/create-plan     # Interactive guidance
/implement-plan  # Phase-by-phase walkthrough
/research-codebase  # Automatic parallel research
```

### External Resources

- Claude Code docs: https://claude.com/claude-code
- Git docs: https://git-scm.com/doc

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

Inspired by and adapted from [humanlayer/humanlayer](https://github.com/humanlayer/humanlayer).

---

**Happy coding!** Use these skills to build better, faster, and with more confidence. 🚀
