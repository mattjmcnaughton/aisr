# Parallel Task Execution

Execute multiple independent tasks in parallel using git worktrees.

## Arguments
- `$ARGUMENTS`: Space-separated quoted tasks, OR `--from-file <path>`

## Usage Examples

```bash
# Multiple inline tasks
/parallel "/prd MVP review cards" "/scaffold all" "Set up pre-commit hooks"

# With ticket numbers
/parallel "#42 /prd MVP review" "#43 /scaffold all"

# From a file
/parallel --from-file backlog.md
```

## Process

1. **Parse tasks** from arguments or file
2. **Delegate to task-orchestrator agent** for analysis:
   - Map tasks to commands/agents
   - Generate worktree and branch names
   - Check for dependencies
3. **Create worktrees** in `.worktrees/`:
   ```bash
   git worktree add .worktrees/<name> -b mattjmcnaughton/<name>
   ```
4. **Write quickstart.md** into each worktree with:
   - Task description
   - Command to run
   - Expected output files
   - Commit and merge instructions
5. **Output summary** with terminal commands

## Output

After running `/parallel`, you'll see:

```
## Parallel Execution Plan

| # | Task | Worktree | Branch | Command |
|---|------|----------|--------|---------|
| 1 | PRD: MVP Review | .worktrees/prd-mvp | mattjmcnaughton/prd-mvp | /prd "..." |
| 2 | Scaffold all | .worktrees/scaffold | mattjmcnaughton/scaffold | /scaffold all |
| 3 | Pre-commit hooks | .worktrees/pre-commit | mattjmcnaughton/pre-commit | (manual) |

✓ Created 3 worktrees with quickstart.md files

## Next Steps
Open terminals and run:

  Terminal 1: cd .worktrees/prd-mvp && claude
  Terminal 2: cd .worktrees/scaffold && claude
  Terminal 3: cd .worktrees/pre-commit && claude

Each worktree has a quickstart.md with instructions.
```

## Quickstart.md Contents

Each worktree gets a `quickstart.md` like:

```markdown
# Task: PRD - MVP Review Cards

## Command
Run this in Claude:
/prd "MVP: Review N cards across M decks with spaced repetition"

## Expected Output
- docs/prds/mvp-review-cards.md

## Agent
This task uses the `prd-author` agent.

## When Done
git add -A && git commit -m "docs: add MVP review cards PRD"

Then return to main repo:
cd .. && git checkout main && git merge mattjmcnaughton/prd-mvp
```

## File Format (--from-file)

If using `--from-file`, provide a markdown file with tasks:

```markdown
# Backlog

## Tasks
- /prd "MVP: Review N cards across M decks"
- /scaffold all
- #99 Set up pre-commit hooks
```

## Cleanup

After merging all branches, clean up worktrees:

```bash
git worktree remove .worktrees/prd-mvp
git worktree remove .worktrees/scaffold
git worktree remove .worktrees/pre-commit
```

Or remove all at once:
```bash
rm -rf .worktrees/* && git worktree prune
```
