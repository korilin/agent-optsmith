# Contributing

## Development Principles

- Keep `AGENTS.md` short, measurable, and action-oriented.
- Prefer deterministic scripts for repeated workflows.
- Keep skill core workflows in `SKILL.md`; move heavy details to `references/`.
- Every policy change should reference at least one concrete incident or metric change.

## Local Validation

```bash
cd agent-auto-self-optimizing-closed-loop

./scripts/create_skill.sh sample-skill
./scripts/weekly_review.sh
./scripts/metrics_report.sh --all
```

## Pull Request Checklist

- Explain problem and expected impact.
- Include before/after evidence for token or efficiency impact when applicable.
- Update relevant templates/docs if process changed.
- Keep changes minimal and composable.
