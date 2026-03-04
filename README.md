# Agent Auto Self-Optimizing Closed Loop (Author Manual)

<!-- README_SYNC_VERSION: 2026-03-04 -->

This repository is a self-optimization infrastructure for AI coding agents.  
Think of it as two layers:

1. `Toolkit` layer: executable scripts, templates, and metrics logic.
2. `Skill` layer: reusable workflows that Codex can trigger.

If you are the author/maintainer, the core goals are:

1. Keep the optimization loop running continuously (log, review, iterate).
2. Keep outcomes measurable (token, duration, success rate, rework).
3. Keep capabilities distributable (installable skills for other projects).

Companion docs:

- [中文说明](README_CN.md)
- [Project Integration Guide (CN)](docs/project-integration-guide-cn.md)
- [Measurement Framework](docs/measurement-framework.md)
- [Project-Local Maintainer Skill](skills/aoso-repo-maintainer/SKILL.md)

## 1. What Each Component Does, How to Use It, and What You Get

### Core governance and documentation

| Path | Purpose | When to use | How to use | Output/result |
|---|---|---|---|---|
| `AGENTS.md` | Runtime governance and quality gates | Changing policies and postmortem-driven rules | Edit policy text | Stable and enforceable operating rules |
| `README.md` / `README_CN.md` | Entry docs for users and maintainers | Publishing, onboarding, handover | Edit docs | Clear positioning and usage path |
| `docs/closed-loop-playbook.md` | Daily/weekly operating playbook | Running routine operations | Follow checklist | Consistent operational cadence |
| `docs/measurement-framework.md` | Metric definitions and formulas | Explaining optimization impact | Run metrics by defined method | Comparable, defensible metrics |

### Runtime scripts (directly in this repository)

| Path | Purpose | Command | Typical output | What you get |
|---|---|---|---|---|
| `scripts/log_task_run.sh` | Append one task run record | `./scripts/log_task_run.sh ...` | `logged: task_id=...` | One new row in `metrics/task-runs.csv` |
| `scripts/metrics_report.sh` | Compute overall/per-skill/pre-post metrics | `./scripts/metrics_report.sh --all` | `Overall Metrics ...` | Efficiency and quality metrics |
| `scripts/weekly_review.sh` | Generate weekly review from error KB | `./scripts/weekly_review.sh` | `generated report: ...` | Weekly report markdown in `reports/` |
| `scripts/create_skill.sh` | Create skill scaffold quickly | `./scripts/create_skill.sh xxx skills` | `created skill: ...` | New skill directory skeleton |

### Templates and data directories

| Path | Purpose | When to use | Output/result |
|---|---|---|---|
| `templates/knowledge-base/error-entry.md` | Error entry template | Logging incidents | Standardized KB entries |
| `templates/reports/weekly-self-optimization-report.md` | Weekly report template | Adjusting report structure | Stable report format |
| `templates/skill/SKILL.md.template` | Skill template | Creating new skills | Consistent minimal skill layout |
| `metrics/task-runs.csv` | Task execution dataset | After each completed task | Computable metrics source |
| `knowledge-base/errors/` | Error knowledge base | After each failure | Inputs for review and prevention |
| `reports/` | Weekly report output | Weekly | Review artifacts |

### Skill layer

| Path | Purpose | Scope | Result |
|---|---|---|---|
| `skills/agent-self-optimizing-loop/` | Installable self-optimization skill | Cross-project | Fast adoption in any repo |
| `skills/aoso-repo-maintainer/` | Project-local maintainer skill | This repo only | Keeps repo workflow consistent and validated |

## 2. Daily Author Workflow

### Path A: Log runs and inspect impact

1. Log a task run:

```bash
./scripts/log_task_run.sh \
  --task-id TASK-1001 \
  --task-type debug \
  --project core-service \
  --model gpt-5 \
  --used-skill true \
  --skill-name log-analysis-helper \
  --total-tokens 1820 \
  --duration-sec 420 \
  --success true
```

2. Inspect overall metrics:

```bash
./scripts/metrics_report.sh --all
```

3. Inspect one skill:

```bash
./scripts/metrics_report.sh --skill log-analysis-helper
```

Key fields:

- `token_reduction_pct`
- `duration_reduction_pct`
- `success_rate_delta_pp`
- `rework_rate_delta`

### Path B: Weekly review and rule promotion

1. Generate report:

```bash
./scripts/weekly_review.sh
```

2. Review latest report in `reports/` and decide:
- recurring root causes
- skills to create/refactor
- rules to promote into `AGENTS.md`

### Path C: Maintain this repository itself

When changing `scripts/`, `skills/`, CI, or workflow docs:

1. Sync runtime scripts to installable skill:

```bash
skills/aoso-repo-maintainer/scripts/sync_runtime_to_installable_skill.sh
```

2. Run repository validation (syntax + parity + README sync + smoke tests):

```bash
skills/aoso-repo-maintainer/scripts/validate_repo_workflow.sh
```

Typical success output:

```text
[1/6] shell syntax checks
[2/6] runtime/script parity checks
[3/6] README sync checks
[4/6] root toolkit smoke test
[5/6] installable skill smoke test
[6/6] done
repository workflow validation passed
```

Commit only after this passes.

## 3. What Results You Should Expect

### Single-skill impact (micro level)

Command:

```bash
./scripts/metrics_report.sh --skill <skill-name>
```

Expected behavior:

- With same-task-type baseline: you get direct comparison metrics.
- Without baseline: you get `insufficient baseline`.

Questions this answers:
- Did this skill really reduce tokens?
- Did it reduce cycle time?
- Did it improve success and reduce rework?

### Engineering impact (macro level)

Command:

```bash
./scripts/metrics_report.sh --all --cutover YYYY-MM-DD
```

Expected behavior:

- With pre/post samples: `delta_*` metrics are shown.
- Missing either side: related metrics show `n/a`.

Questions this answers:
- Did overall efficiency improve?
- Are gains sustained beyond one-off variance?

### Weekly governance output

Command:

```bash
./scripts/weekly_review.sh
```

Expected behavior:

- emits report path
- report includes top causes, costly task types, and action placeholders

## 4. Installation and Distribution

### Install the reusable cross-project skill

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo korilin/agent-auto-self-optimizing-closed-loop \
  --path skills/agent-self-optimizing-loop
```

### Install the project-local maintainer skill

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo korilin/agent-auto-self-optimizing-closed-loop \
  --path skills/aoso-repo-maintainer
```

Restart Codex after installation.

## 5. Minimal Maintainer Checklist

1. Make code/script changes.
2. Run `sync_runtime_to_installable_skill.sh` if runtime scripts changed.
3. Update both `README.md` and `README_CN.md`, and keep `README_SYNC_VERSION` aligned.
4. Run `check_readme_sync.sh`.
5. Run `validate_repo_workflow.sh`.
6. Update other docs as needed.
7. Commit and push.
8. Continue logging runs and monitor metric trends.

## 6. Current Repository Status

- Installable external skill is present: `skills/agent-self-optimizing-loop`.
- Project-local maintainer skill is present: `skills/aoso-repo-maintainer`.
- CI includes skill-workflow validation.
- Token and efficiency metrics are measurable.

This repository is now not just a template, but a self-maintaining, self-validating, and self-measuring optimization system.
