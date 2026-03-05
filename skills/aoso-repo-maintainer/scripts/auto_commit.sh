#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
commit_message="chore(repo): automated workflow commit $(date +%Y-%m-%d)"

usage() {
  cat <<'EOF'
Usage:
  skills/aoso-repo-maintainer/scripts/auto_commit.sh [--message "<commit-message>"]

Description:
  Stage all repository changes and create one commit non-interactively.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --message)
      commit_message="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "${commit_message}" ]]; then
  echo "error: commit message must not be empty"
  exit 1
fi

cd "${repo_root}"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "error: not inside a git repository: ${repo_root}"
  exit 1
}

git add -A

if git diff --cached --quiet; then
  echo "no changes to commit"
  exit 0
fi

echo "staged files:"
git diff --cached --name-only | sed 's/^/  - /'

git commit -m "${commit_message}"
echo "created commit: $(git rev-parse --short HEAD)"
