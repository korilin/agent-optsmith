# CLI Maintenance Checklist

## When to trigger this skill

- Modify `optsmith_cli/cli.py` or other files under `optsmith_cli/`.
- Modify bundled CLI resources under `optsmith_cli/resources/skills/agent-optsmith/`.
- Modify CLI packaging metadata:
  - `pyproject.toml`
  - `Formula/optsmith.rb`
  - `optsmith_cli/__init__.py`
- Add/remove/rename CLI commands or command arguments.

## Functional Contract Rules

1. Keep command surface explicit and stable:
   - `install`, `update`, `uninstall`, `dashboard`, `run`, `metrics`, `optimize`, `version`, `help`
2. Keep command wiring one-to-one:
   - `_cmd_<name>` handler + `_build_parser` registration + help text.
3. Keep runtime behavior deterministic:
   - use `CliError` for expected user-facing failures.
   - avoid hidden side effects during argument parsing.

## Code Convention Rules

1. Keep path safety checks centralized:
   - workspace-bound path resolution must stay in `_resolve_decl_path`.
2. Keep shell execution centralized:
   - use `_run` / `_run_shell_script` for subprocess calls.
3. Keep command forwarding limited:
   - only `run`, `metrics`, `optimize` may forward unknown args.

## Version Management Rules

When CLI scope changes, version bump is mandatory and must be synchronized:

- `pyproject.toml`
- `optsmith_cli/__init__.py`
- `Formula/optsmith.rb`

Use semantic versioning:

- patch (`x.y.z+1`): backward-compatible fixes
- minor (`x.y+1.0`): backward-compatible feature additions
- major (`x+1.0.0`): breaking changes

Validate with:

```bash
.agents/skills/optsmith-cli-maintainer/scripts/check_cli_version_bump.sh
```

## Required Validation

```bash
PYTHONPATH="$(pwd)" python3 -m optsmith_cli.cli help
PYTHONPATH="$(pwd)" python3 -m optsmith_cli.cli version
.agents/skills/optsmith-cli-maintainer/scripts/check_cli_version_bump.sh
.agents/skills/optsmith-repo-maintainer/scripts/validate_repo_workflow.sh
```
