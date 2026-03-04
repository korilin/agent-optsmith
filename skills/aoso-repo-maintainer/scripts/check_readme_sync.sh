#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
readme_en="${repo_root}/README.md"
readme_cn="${repo_root}/README_CN.md"

extract_sync_version() {
  local file="$1"
  local line
  line="$(grep -Eo 'README_SYNC_VERSION: [0-9]{4}-[0-9]{2}-[0-9]{2}' "$file" | head -n 1 || true)"
  echo "${line##*: }"
}

assert_contains() {
  local file="$1"
  local pattern="$2"
  local message="$3"
  if ! grep -Eq -- "$pattern" "$file"; then
    echo "error: ${message}"
    echo "  file: ${file}"
    exit 1
  fi
}

if [[ ! -f "${readme_en}" || ! -f "${readme_cn}" ]]; then
  echo "error: README.md or README_CN.md not found"
  exit 1
fi

version_en="$(extract_sync_version "${readme_en}")"
version_cn="$(extract_sync_version "${readme_cn}")"

if [[ -z "${version_en}" || -z "${version_cn}" ]]; then
  echo "error: missing README sync version marker"
  echo "required format: <!-- README_SYNC_VERSION: YYYY-MM-DD -->"
  exit 1
fi

if [[ "${version_en}" != "${version_cn}" ]]; then
  echo "error: README sync version mismatch"
  echo "  README.md:    ${version_en}"
  echo "  README_CN.md: ${version_cn}"
  exit 1
fi

for i in 1 2 3 4 5 6; do
  assert_contains "${readme_en}" "^## ${i}\\." "README.md missing section heading: ## ${i}."
  assert_contains "${readme_cn}" "^## ${i}\\." "README_CN.md missing section heading: ## ${i}."
done

assert_contains "${readme_en}" "--path skills/agent-self-optimizing-loop" "README.md missing install command for agent-self-optimizing-loop"
assert_contains "${readme_cn}" "--path skills/agent-self-optimizing-loop" "README_CN.md missing install command for agent-self-optimizing-loop"
assert_contains "${readme_en}" "--path skills/aoso-repo-maintainer" "README.md missing install command for aoso-repo-maintainer"
assert_contains "${readme_cn}" "--path skills/aoso-repo-maintainer" "README_CN.md missing install command for aoso-repo-maintainer"

echo "README sync check passed (version: ${version_en})"
