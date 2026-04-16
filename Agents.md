# Standard Agents Reference

This document provides a complete reference for all available agents in Skilladiko. Agents are specialized Claude assistants that run in the background, handling focused research and analysis tasks.

## Quick Reference

| Agent | Purpose | Tools | Use When |
|-------|---------|-------|----------|
| [`codebase-locator`](#codebase-locator) | Fast file and directory location finder | Grep, Glob, LS | You need to find where code lives |
| [`codebase-analyzer`](#codebase-analyzer) | Deep implementation analysis | Read, Grep, Glob, LS | You need to understand HOW code works |
| [`codebase-pattern-finder`](#codebase-pattern-finder) | Find similar implementations and patterns | Grep, Glob, Read, LS | You need concrete examples to model after |
| [`thoughts-locator`](#thoughts-locator) | Search metadata and decision docs | Grep, Glob, LS | You need context from past decisions |
| [`thoughts-analyzer`](#thoughts-analyzer) | Extract insights from research docs | Read, Grep, Glob, LS | You need deep analysis of findings |
| [`web-search-researcher`](#web-search-researcher) | Web research and current information | WebSearch, WebFetch, Read, Grep, Glob, LS | You need info beyond your knowledge cutoff |

---

## Detailed Agent Descriptions

### codebase-locator

**Location**: [agents/codebase-locator.md](agents/codebase-locator.md)

**Purpose**: Fast file and directory locator. Creates a "map" of where code lives without analyzing its contents.

**Tools Available**: Grep, Glob, LS

**Model**: Sonnet

**When to Use**:
- Finding files related to a feature
- Locating test files, config, or type definitions
- Understanding code organization
- First step in codebase exploration

**Example Usage**:
```bash
# In Claude Code, delegate to the agent
Agent({
  description: "Locate authentication files",
  subagent_type: "codebase-locator",
  prompt: "Find all authentication-related files. I'm looking for login, session, token, and auth handler implementations."
})
```

**What It Does**:
- Searches for relevant keywords and patterns
- Groups findings by purpose (implementation, tests, config, docs)
- Returns file paths organized by category
- Documents code organization patterns

**What It Won't Do**:
- Analyze file contents
- Suggest improvements
- Critique the codebase
- Read files to understand implementation

---

### codebase-analyzer

**Location**: [agents/codebase-analyzer.md`](agents/codebase-analyzer.md)

**Purpose**: Deep-dive into specific code implementations. Analyzes HOW code works and finds integration points.

**Tools Available**: Read, Grep, Glob, LS

**Model**: Sonnet

**When to Use**:
- Understanding existing feature implementations
- Finding where to integrate new code
- Analyzing dependencies and relationships
- Learning architectural patterns

**Example Usage**:
```bash
Agent({
  description: "Analyze payment processing",
  subagent_type: "codebase-analyzer",
  prompt: "Analyze the payment processing implementation. Show me: 1) Core payment logic, 2) Error handling, 3) Integration points with other services"
})
```

**What It Does**:
- Reads actual code to understand implementation
- Traces dependencies and relationships
- Identifies entry points and integration patterns
- Extracts architectural insights
- Provides specific file:line references

**What It Won't Do**:
- Suggest refactoring or improvements (unless asked)
- Judge code quality or design decisions
- Analyze problems (unless explicitly requested)
- Design new architectures

---

### codebase-pattern-finder

**Location**: [agents/codebase-pattern-finder.md`](.claude/agents/codebase-pattern-finder.md)

**Purpose**: Find similar implementations and usage examples. Perfect for discovering patterns to model after.

**Tools Available**: Grep, Glob, Read, LS

**Model**: Sonnet

**When to Use**:
- Finding examples of a pattern before implementing
- Understanding how similar features are built
- Discovering naming conventions and best practices
- Researching architectural patterns used in the codebase

**Example Usage**:
```bash
Agent({
  description: "Find middleware patterns",
  subagent_type: "codebase-pattern-finder",
  prompt: "Find 3-5 examples of middleware implementations in this codebase. Show me the pattern and how they're used."
})
```

**What It Does**:
- Searches for similar implementations
- Shows concrete code examples
- Identifies common patterns and conventions
- Provides before/after usage examples
- Returns specific, copyable patterns

**What It Won't Do**:
- Create new patterns
- Critique existing patterns
- Suggest architectural changes
- Analyze code quality

---

### thoughts-locator

**Location**: [agents/thoughts-locator.md`](.claude/agents/thoughts-locator.md)

**Purpose**: Discovers relevant documents in the `thoughts/` directory. Finds metadata, decisions, and context.

**Tools Available**: Grep, Glob, LS

**Model**: Sonnet

**When to Use**:
- Finding past decisions about a feature
- Locating meeting notes or research documents
- Understanding constraints and requirements
- Finding context for architectural choices

**Example Usage**:
```bash
Agent({
  description: "Find auth migration decisions",
  subagent_type: "thoughts-locator",
  prompt: "Find any thoughts/documents about authentication migration. I'm looking for decision records, meeting notes, or implementation plans."
})
```

**What It Does**:
- Searches the `thoughts/` directory structure
- Locates decision records and plans
- Identifies relevant context documents
- Returns file locations and brief descriptions
- Helps reconstruct historical context

**What It Won't Do**:
- Read or analyze document contents (that's `thoughts-analyzer`)
- Create new decision records
- Suggest new approaches

---

### thoughts-analyzer

**Location**: [agents/thoughts-analyzer.md`](.claude/agents/thoughts-analyzer.md)

**Purpose**: Deep analysis of research documents. Extracts key insights and findings from `thoughts/` metadata.

**Tools Available**: Read, Grep, Glob, LS

**Model**: Sonnet

**When to Use**:
- Extracting key decisions from past planning
- Understanding detailed research findings
- Analyzing meeting notes or requirement documents
- Finding constraints and dependencies documented elsewhere

**Example Usage**:
```bash
Agent({
  description: "Analyze payment gateway requirements",
  subagent_type: "thoughts-analyzer",
  prompt: "Analyze all thoughts about payment gateway selection. Extract: 1) Requirements, 2) Constraints, 3) Why current choice was made"
})
```

**What It Does**:
- Reads and analyzes research documents
- Extracts key insights and decisions
- Summarizes findings
- Identifies constraints and dependencies
- Provides interpretive analysis

**What It Won't Do**:
- Critique past decisions
- Suggest reversing decisions
- Analyze problems (unless in the source documents)

---

### web-search-researcher

**Location**: [agents/web-search-researcher.md`](.claude/agents/web-search-researcher.md)

**Purpose**: Research topics on the web when you need current information beyond the knowledge cutoff.

**Tools Available**: WebSearch, WebFetch, Read, Grep, Glob, LS

**Model**: Sonnet

**When to Use**:
- Finding current best practices
- Researching new frameworks or libraries
- Understanding recent changes in technology
- Finding external documentation or examples
- Discovering third-party tools or services

**Example Usage**:
```bash
Agent({
  description: "Research React 19 migration",
  subagent_type: "web-search-researcher",
  prompt: "Research React 19 migration from React 18. Find: 1) What changed, 2) Migration guide, 3) Common pitfalls"
})
```

**What It Does**:
- Searches the web for relevant information
- Fetches and analyzes web content
- Synthesizes findings from multiple sources
- Provides current, up-to-date information
- Returns specific, cited references

**What It Won't Do**:
- Access authenticated services (Google Docs, Confluence, etc.)
- Modify external content
- Replace local codebase knowledge (use `codebase-analyzer` for that)

---

## Agent Characteristics

### Execution
- Agents run **in parallel** when called together (faster than sequential)
- Each agent has a focused purpose (doesn't try to do everything)
- Results are returned as tool results, not visible in the conversation by default
- You relay findings to the user in your own words

### Tools
- All agents use read-only tools (safe to run)
- No modifications to the codebase
- Respects file permissions
- No external API keys required (except web-search-researcher for WebSearch)

### Output Quality
- Agents provide specific file paths and line numbers
- Results are organized by category or theme
- Findings include context and explanations
- No duplicate or repetitive information

---

## Choosing the Right Agent

### Finding Code
1. **"Where is X?"** → Use `codebase-locator`
2. **"How does X work?"** → Use `codebase-analyzer`
3. **"Show me an example of X pattern"** → Use `codebase-pattern-finder`

### Finding Context
1. **"Was there a decision about X?"** → Use `thoughts-locator`
2. **"What was decided about X?"** → Use `thoughts-analyzer`

### Finding External Info
1. **"What's current practice for X?"** → Use `web-search-researcher`
2. **"How do I do X in library Y?"** → Use `web-search-researcher`

---

## Common Agent Workflows

### Understanding a Feature
```
1. codebase-locator  → Find implementation files
2. codebase-analyzer → Understand how they work
3. thoughts-analyzer → Find decisions/constraints
```

### Building a Similar Feature
```
1. codebase-pattern-finder  → Find similar implementations
2. codebase-analyzer        → Analyze the pattern
3. web-search-researcher    → Find external best practices
```

### Researching New Technology
```
1. web-search-researcher → Find current info
2. thoughts-locator      → Check if already researched
3. codebase-pattern-finder → Find similar approaches in codebase
```

---

## Agent Conventions

### Prompts
- Be specific about what you're looking for
- Mention file types or languages when relevant
- Ask for output in a specific format if needed
- Provide context about why you need the information

### Interpreting Results
- File paths are relative to repository root
- Line numbers correspond to the version at analysis time
- Results may include similar files (good for understanding patterns)
- Ask for follow-up research if initial results aren't sufficient

---

## Integration with Commands

These agents are used internally by Skilladiko commands:

- **`/create_plan`** uses `codebase-locator` and `codebase-analyzer` to research your codebase
- **`/implement_plan`** uses agents to verify implementation progress
- **`/research_codebase`** runs multiple agents in parallel

You can also use agents directly by calling them from your own agent requests.

---

## Tips for Effective Agent Use

1. **Be Parallel**: Call multiple agents in one request when they're independent
2. **Be Specific**: The more context you give, the better results you get
3. **Be Iterative**: Agent results often lead to follow-up questions
4. **Mix and Match**: Combine agents (locator → analyzer → web-research) for comprehensive understanding
5. **Trust the Focus**: Each agent has a specific job; don't ask it to do everything

---

## For More Information

- Read agent definitions: [agents/](agents/)
- See agent implementation: [agents/](agents/)
- Full project documentation: [README.md](README.md)
