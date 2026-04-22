# Debug Ruby Test

**Purpose**: Debug a failing Ruby test by setting a breakpoint and inspecting state.  
**Transport**: bash + tmux (no gem dependencies, works immediately).  

## Tools

- Bash (for `rdbg`, `tmux`, file operations)
- Read (to read test files, fixtures)

## Instructions

When given a Ruby test file and a failure description:

1. **Read the test file** to understand what it's testing.

2. **Pick a breakpoint line**: Look for the line where the failure likely happens (after the setup that works, before the error occurs). If unsure, start at the test's first assertion.

3. **Launch rdbg in tmux**:
   ```bash
   TEST_FILE="path/to/test.rb"
   SESSION_ID="dbg_$$"
   
   tmux new-session -d -s "$SESSION_ID" \
     "rdbg --open --sock-path=/tmp/rdbg-$SESSION_ID.sock \
     -e 'b $TEST_FILE:LINE_NUMBER' \
     $TEST_FILE"
   ```
   Wait 1 second for the socket to appear.

4. **Attach the debugger UI in a second window**:
   ```bash
   tmux new-window -t "$SESSION_ID" \
     "rdbg -A /tmp/rdbg-$SESSION_ID.sock"
   sleep 1
   ```

5. **Inspect the paused state** by sending commands and reading output:
   ```bash
   tmux send-keys -t "$SESSION_ID:1" "info" Enter
   sleep 0.5
   tmux capture-pane -t "$SESSION_ID:1" -p
   ```
   
   Useful commands:
   - `info` — show local and instance variables
   - `p EXPRESSION` — evaluate and print an expression
   - `bt` — backtrace
   - `n` — step to next line
   - `c` — continue

## Debugging Commands by Feature

**List all variables**:
```bash
tmux send-keys -t "$SESSION:1" "info" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

**Inspect a specific variable**:
```bash
tmux send-keys -t "$SESSION:1" "p user" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

**Inspect nested attributes**:
```bash
tmux send-keys -t "$SESSION:1" "p user.email" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

**List the callstack**:
```bash
tmux send-keys -t "$SESSION:1" "bt" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

**Step to next line**:
```bash
tmux send-keys -t "$SESSION:1" "n" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

**Check instance variables**:
```bash
tmux send-keys -t "$SESSION:1" "p @instance_var" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

**Evaluate expressions**:
```bash
tmux send-keys -t "$SESSION:1" "p User.all.count" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

**Continue execution**:
```bash
tmux send-keys -t "$SESSION:1" "c" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p
```

6. **Repeat** as needed: send another command, capture output.

7. **Clean up**:
   ```bash
   tmux kill-session -t "$SESSION_ID"
   rm -f /tmp/rdbg-$SESSION_ID.sock
   ```

8. **Form a hypothesis** about why the test fails based on what you observed (variable values, stack trace, execution flow).

## Limitations

- **Timing is fragile**: `sleep 0.5` is a guess. Long-running commands may need longer waits; quick commands may not.
- **Output parsing**: ANSI color codes and terminal formatting are messy. Strip them if needed: `sed 's/\x1b\[[0-9;]*m//g'`.
- **Prompt detection**: The `(rdbg)` prompt confirms the debugger is ready. Use it as a signal for "output is complete."
- **One-shot per pause**: If you accidentally send `continue` (or disconnect), rdbg resumes and you lose the pause point. Re-run the test or set another breakpoint.

## Example: Debug a Failing Test

```bash
# Given: test/test_user.rb fails with "undefined method `email' for nil:NilClass"

# 1. Read test
cat test/test_user.rb | grep -A 10 "def test"

# 2. The test creates a user, then calls user.email
# Breakpoint should be at the line that calls .email

# 3. Launch
TEST="test/test_user.rb"
SESSION="debug_$RANDOM"
tmux new-session -d -s "$SESSION" \
  "rdbg --open --sock-path=/tmp/rdbg-$SESSION.sock \
  -e 'b $TEST:15' \
  $TEST"
sleep 1

# 4. Attach
tmux new-window -t "$SESSION" \
  "rdbg -A /tmp/rdbg-$SESSION.sock"
sleep 1

# 5. Inspect
tmux send-keys -t "$SESSION:1" "p user" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p | head -20

# Output shows: user is nil. Now inspect earlier...
# Send another command:
tmux send-keys -t "$SESSION:1" "p User.first" Enter
sleep 0.5
tmux capture-pane -t "$SESSION:1" -p | head -20

# Output shows: User.first is nil too. Database not seeded?

# 6. Clean up
tmux kill-session -t "$SESSION"
```

## Known Issues

- **rdbg with many breakpoints**: Each `-e 'b FILE:LINE'` adds overhead. Keep it to 1-2.
- **Long output**: `capture-pane` shows only the visible pane. Use `capture-pane -S -50` to scroll back 50 lines.
- **Color codes**: Strip with `sed 's/\x1b\[[0-9;]*m//g'` if you need to parse output.
- **Tmux not installed**: Ask user to install tmux

