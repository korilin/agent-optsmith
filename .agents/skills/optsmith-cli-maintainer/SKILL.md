---
name: optsmith-cli-maintainer
description: Maintain the optsmith CLI contract, implementation quality, and release versioning policy. Use when changing CLI commands, argparse wiring, install/update/uninstall behavior, packaging metadata, or bundled CLI assets.
---

# Optsmith CLI Maintainer

This skill is project-local and focused on CLI maintenance for `agent-optsmith`.

## Scope

- CLI behavior and command contract under `optsmith_cli/`.
- Packaging metadata and publish version files:
  - `pyproject.toml`
  - `optsmith_cli/__init__.py`
  - `Formula/optsmith.rb`
- Bundled CLI resources under `optsmith_cli/resources/skills/agent-optsmith/`.

## Required Workflow

1. Implement CLI change with backward-compatible command behavior where possible.
2. If CLI changed, bump version consistently in all three version files:
   - `pyproject.toml`
   - `optsmith_cli/__init__.py`
   - `Formula/optsmith.rb`
3. Run:
```bash
.agents/skills/optsmith-cli-maintainer/scripts/check_cli_version_bump.sh
```
4. Run repo-level validation:
```bash
.agents/skills/optsmith-repo-maintainer/scripts/validate_repo_workflow.sh
```
5. Commit and push only after checks pass:
```bash
.agents/skills/optsmith-repo-maintainer/scripts/auto_commit.sh --message "<commit-message>"
```

## References

- `references/cli-maintenance-checklist.md`

## Scripts

- `scripts/check_cli_version_bump.sh`: enforce CLI-change => version-bump policy and cross-file version consistency.
