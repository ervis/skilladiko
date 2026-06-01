---
description: Validate QRSPI configuration and resolve artifact directory
model: opus
argument-hint: "[optional: artifact-dir-override]"
---

# Validate — Check Configuration

Validates QRSPI setup and resolves artifact directories from configuration files.

## Input

None required. Reads `.qrspi` configuration.

## Process

1. **Check for configuration files** in this order:
   - `.qrspi` in the project root
   - `~/.qrspi` in the user's home directory

2. **Parse the config file**:
   - Format: dotenv-style
   - Required: `issues_dir=<path>` and `shared_dir=<path>`
   - Examples: `issues_dir=/path/to/issues` and `shared_dir=/path/to/shared`

3. **Resolve the artifact directories**:
   - If config found: use `issues_dir` and `shared_dir` from the file
   - If not found: error (configuration required)

4. **Validate the directories**:
   - Check that both paths are writable (create parent directories if needed with `mkdir -p`)
   - Report any permission errors

5. **Output the result** to the user:
   - Both artifact directory paths
   - Source (config file or error)
   - Ready for use by other QRSPI commands

## Output

Print to stdout:

```sh
issues_dir=<path>
shared_dir=<path>
```

Example:

```sh
issues_dir=/home/user/vault/issues
shared_dir=/home/user/vault/shared
```

## Configuration File Format

Create `.qrspi` at project root or `~/.qrspi` (dotenv-style):

```sh
issues_dir=/path/to/issues
shared_dir=/path/to/shared
```

Examples:

```sh
issues_dir=/home/user/vault/issues
shared_dir=/home/user/vault/shared
```

## Usage by Other Commands

Other QRSPI commands should call this validator first:

```bash
# In question.md, research.md, etc.:
source <(/qrspi-validate)
# Now $issues_dir and $shared_dir are available
```

Or invoke via the skill:
```
/qrspi-validate
```

## Rules

- Both `issues_dir` and `shared_dir` must be configured
- Create artifact directories automatically if they don't exist
- Configuration requires two lines (one for each directory)
