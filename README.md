# Skilladiko

A collection of Claude Code skills, commands, and agents designed to supercharge your software engineering workflow. These tools help you plan, implement, research, and commit code changes more effectively within Claude Code.

## What's Included

### 🎯 Commands (Skills)

**Commands** are user-invoked skills that run specialized workflows. Invoke them with `/command-name` in Claude Code.

| Command | Purpose |
|---------|---------|
| **`create_plan`** | Create detailed implementation plans with thorough research and iteration. Perfect for breaking down complex features into actionable phases. |
| **`implement_plan`** | Execute pre-created implementation plans with verification steps and progress tracking. |
| **`research_codebase`** | Comprehensively research your codebase using parallel sub-agents to find patterns, understand architecture, and analyze implementation details. |
| **`commit`** | Create git commits with clear, atomic messages and full user control (no Claude attribution). |
| **`ci_commit`** | Create commits optimized for CI/CD workflows with automatic attribution. |

### 🤖 Agents

**Agents** are specialized Claude Code agents that handle specific research and analysis tasks. They run in parallel for efficiency.

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
./scripts/link-commands.sh
./scripts/link-agents.sh
```

This creates symlinks in your local Claude Code directory (`~/.claude/commands` and `~/.claude/agents`), linking from the `.agents/skills/` and `.agents/agents/` directories in this repo.

### Manual Installation

If you prefer to install manually:

#### Option 1: Copy Files (Recommended for isolated setups)

```bash
# Copy commands
cp .agents/skills/*.md ~/.claude/commands/

# Copy agents
cp .agents/agents/*.md ~/.claude/agents/
```

#### Option 2: Create Symlinks (Recommended for development)

```bash
# Commands
mkdir -p ~/.claude/commands
ln -s /path/to/skilladiko/.agents/skills/* ~/.claude/commands/

# Agents
mkdir -p ~/.claude/agents
ln -s /path/to/skilladiko/.agents/agents/* ~/.claude/agents/
```

### Verify Installation

After installation, verify your setup:

```bash
ls ~/.claude/commands/      # Should show: commit.md, create_plan.md, etc.
ls ~/.claude/agents/        # Should show: codebase-analyzer.md, etc.
ls .agents/skills/ .agents/agents/    # Should show source files
```

Then reload Claude Code or restart it for the new skills to become available.

## Usage Guide

### Creating an Implementation Plan

The typical workflow starts with planning:

```bash
/create_plan
```

This interactive command will:
1. Gather context about what you want to build
2. Research your codebase for relevant patterns
3. Help you design the implementation approach
4. Generate a detailed, phase-based plan

**Example**: Planning a new authentication feature
```
User: /create_plan
Assistant: I'll help you create a detailed implementation plan...
User: We need to add OAuth2 support. See ticket ENG-123.
Assistant: [Reads ticket, researches codebase, asks clarifying questions...]
```

### Executing a Plan

Once you have a plan:

```bash
/implement_plan thoughts/shared/plans/2026-04-16-oauth2-support.md
```

This will:
1. Load and review your plan
2. Guide you through each implementation phase
3. Verify success criteria after each phase
4. Track progress

### Researching Your Codebase

To understand how something works:

```bash
/research_codebase
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
/commit
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
/create_plan

# 2. Follow the planning dialog
# (research, ask questions, refine approach)

# 3. Get approval and review the plan file
# 4. Start implementation
/implement_plan thoughts/shared/plans/YYYY-MM-DD-feature.md

# 5. Follow each phase with verification
# 6. Commit your work
/commit
```

### Example 2: Understanding Existing Code

```bash
# 1. Research the codebase
/research_codebase

# 2. Agents will find and analyze related code
# (runs in parallel for speed)

# 3. Review findings to understand the architecture
# 4. Use insights to inform your changes
```

### Example 3: Refactoring with Confidence

```bash
# 1. Create a plan for the refactoring
/create_plan

# 2. Specify scope carefully
# (what you're NOT changing)

# 3. Get detailed phase-by-phase guidance
/implement_plan [your-plan-file]

# 4. Verify each phase works
# 5. Commit with clear messages
/commit
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
   ls ~/.claude/commands/
   ```

2. Reload Claude Code or restart the application

3. Check that files are readable:
   ```bash
   file ~/.claude/commands/commit.md
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

- Start with `/create_plan` for interactive guidance
- Let agents research in parallel (they run concurrently)
- Review findings before planning
- Break into smaller phases for clarity

### For Better Commits

- Use `/commit` for thoughtful, atomic commits
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
/create_plan     # Interactive guidance
/implement_plan  # Phase-by-phase walkthrough
/research_codebase  # Automatic parallel research
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
