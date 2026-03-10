#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(git -C "${script_dir}" rev-parse --show-toplevel 2>/dev/null || (cd "${script_dir}/../../../.." && pwd))"
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

assert_contains "${readme_en}" "brew install aoso-skill" "README.md missing brew install command"
assert_contains "${readme_cn}" "brew install aoso-skill" "README_CN.md missing brew install command"
assert_contains "${readme_en}" "pipx install" "README.md missing pipx install command"
assert_contains "${readme_cn}" "pipx install" "README_CN.md missing pipx install command"
assert_contains "${readme_en}" "aoso-skill update" "README.md missing aoso-skill update command"
assert_contains "${readme_cn}" "aoso-skill update" "README_CN.md missing aoso-skill update command"
assert_contains "${readme_en}" "aoso-skill init" "README.md missing aoso-skill init command"
assert_contains "${readme_cn}" "aoso-skill init" "README_CN.md missing aoso-skill init command"
assert_contains "${readme_en}" "aoso-skill dashboard" "README.md missing aoso-skill dashboard command"
assert_contains "${readme_cn}" "aoso-skill dashboard" "README_CN.md missing aoso-skill dashboard command"

echo "README sync check passed (version: ${version_en})"
