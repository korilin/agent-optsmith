#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/create_skill.sh <skill-name> [skills-root]

Examples:
  ./scripts/create_skill.sh api-error-triage
  ./scripts/create_skill.sh "API Error Triage" skills
EOF
}

normalize_name() {
  local raw="$1"
  echo "$raw" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g'
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

raw_name="$1"
skills_root="${2:-skills}"
skill_name="$(normalize_name "$raw_name")"

if [[ -z "$skill_name" ]]; then
  echo "error: skill name is empty after normalization"
  exit 1
fi

skill_dir="${skills_root}/${skill_name}"

if [[ -e "$skill_dir" ]]; then
  echo "error: target already exists: ${skill_dir}"
  exit 1
fi

mkdir -p "${skill_dir}/agents" "${skill_dir}/scripts" "${skill_dir}/references" "${skill_dir}/assets"

cat > "${skill_dir}/SKILL.md" <<EOF
---
name: ${skill_name}
description: TODO: describe what this skill does and when to use it
---

# ${skill_name}

## Workflow

1. Read only context needed for the request.
2. Select relevant scripts and references.
3. Execute deterministic steps first.
4. Validate outputs before returning.

## References

- Add domain docs to \`references/\` as needed.

## Scripts

- Add reusable deterministic scripts to \`scripts/\`.
EOF

cat > "${skill_dir}/agents/openai.yaml" <<EOF
schema_version: "v1"
display_name: "${skill_name}"
short_description: "TODO: short one-line summary"
default_prompt: "Use this skill when tasks match its description and workflow."
EOF

touch "${skill_dir}/scripts/.gitkeep" "${skill_dir}/references/.gitkeep" "${skill_dir}/assets/.gitkeep"

echo "created skill: ${skill_dir}"
echo "next steps:"
echo "  1) edit ${skill_dir}/SKILL.md"
echo "  2) add scripts/references/assets if needed"
