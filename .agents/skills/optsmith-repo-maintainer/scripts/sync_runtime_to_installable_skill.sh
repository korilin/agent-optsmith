#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(git -C "${script_dir}" rev-parse --show-toplevel 2>/dev/null || (cd "${script_dir}/../../../.." && pwd))"

src_dir="${repo_root}/scripts"
dst_dir="${repo_root}/skills/agent-optsmith/scripts"
bundle_skill_dir="${repo_root}/optsmith_cli/resources/skills/agent-optsmith"

runtime_scripts=(
  "log_task_run.sh"
  "metrics_report.sh"
  "weekly_review.sh"
  "auto_run_loop.sh"
  "optimize_skill.sh"
  "dashboard_server.sh"
  "dashboard_server.py"
)

for f in "${runtime_scripts[@]}"; do
  if [[ ! -f "${src_dir}/${f}" ]]; then
    echo "error: missing source script: ${src_dir}/${f}"
    exit 1
  fi
done

mkdir -p "${dst_dir}"

for f in "${runtime_scripts[@]}"; do
  cp "${src_dir}/${f}" "${dst_dir}/${f}"
  chmod +x "${dst_dir}/${f}"
  echo "synced: ${f}"
done

echo "runtime scripts synced to installable skill:"
echo "  ${dst_dir}"

if [[ ! -d "${repo_root}/skills/agent-optsmith" ]]; then
  echo "error: missing installable skill directory: ${repo_root}/skills/agent-optsmith"
  exit 1
fi

rm -rf "${bundle_skill_dir}"
mkdir -p "$(dirname "${bundle_skill_dir}")"
cp -R "${repo_root}/skills/agent-optsmith" "${bundle_skill_dir}"

echo "installable skill synced to CLI bundled assets:"
echo "  ${bundle_skill_dir}"
