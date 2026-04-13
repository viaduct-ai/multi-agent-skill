# multi-agent Claude skill

A Claude Code skill that enables multi-agent orchestration via tmux. Spawn parallel worker Claude sessions alongside your main session and coordinate work across them.

## What it does

- **Supervisor mode (Simon):** Claude becomes an orchestrator that spawns and coordinates worker agents in split tmux panes.
- **Worker mode:** Each worker pane runs its own Claude session, receives task instructions from Simon, and reports back.
### Key capabilities

- Spawn N worker panes with `/multi-agent workers=N`
- Workers automatically load their context via `/multi-agent role=worker ...`
- Helper scripts: spawn, close, list, and message workers by name
- Worker identity is tracked via tmux pane user options (survives title overrides)

## Prerequisites

- **tmux** — must be running inside a tmux session
- **claude CLI** — Claude Code must be installed and on your PATH

## Installation

Run `install.sh` to install the skill and scripts into your `~/.claude/` directory:

```bash
./install.sh
```

This will:
1. Copy `SKILL.md` to `~/.claude/skills/multi-agent/SKILL.md`
2. Copy the helper scripts to `~/.claude/scripts/multi-agent/`

## Usage

Inside a tmux session, open Claude Code and run:

```
/multi-agent
```

To spawn workers immediately on load:

```
/multi-agent workers=2
```

### Simon commands (inside a supervisor session)

```bash
# Spawn an additional worker
~/.claude/scripts/multi-agent/spawn-workers 1

# List active workers
~/.claude/scripts/multi-agent/list-workers

# Send a message to a worker
~/.claude/scripts/multi-agent/send-message Wade "your task here"

# Close a specific worker
~/.claude/scripts/multi-agent/close-worker Wade

# Close all workers
~/.claude/scripts/multi-agent/close-workers
```

## Repository structure

```
SKILL.md       # Claude Code skill definition
README.md      # This file
install.sh     # Installation script
scripts/       # Helper bash scripts
  _lib.sh        # Shared helpers (sourced by other scripts)
  spawn-workers  # Spawn N worker panes
  close-worker   # Kill a named worker pane
  close-workers  # Kill all worker panes
  list-workers   # List active workers
  send-message   # Send a message to a named worker (waits for idle prompt)
```

## Roadmap

- [x] more visible contest name bold + task
- [ ] prevent messages getting garbled together
- [ ] have at most two worker windows but more workers
- [ ] add a pool of tasks 
- [ ] focus moves worker view to the top, once it continues cycle to the next worker who asked for the user
- [ ] optional sound when a worker needs help
- [ ] set permissions to run scripts on install or when loading the skill ?
  - [ ] allow all workers to edit files in the working directory
  - [ ] allow all workest to use the scripts in the skill
- [ ] add instructions for workers to make independent checkouts/worktrees to work on