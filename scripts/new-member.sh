#!/bin/bash
# Generate a new AI Team member plugin from this template.
#
#   scripts/new-member.sh <member> "<Member Title>" "<description>" [target-dir]
#
#   <member>         lowercase agent and folder name, e.g. cto  (repo becomes ai-<member>)
#   <Member Title>   display title, e.g. CTO
#   <description>    one or two sentences; becomes the plugin description
#   [target-dir]     default: ai-<member> next to this template folder.
#                    Pass the template folder itself (e.g. ".") to convert a repository created
#                    with GitHub "Use this template" in place.
#
# Works with macOS (BSD) and GNU sed. Placeholders replaced: {{member}} {{Member}} {{repo}}
# {{description}} {{date}}.
set -euo pipefail

die() { echo "new-member: $*" >&2; exit 1; }

usage() {
  sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-1}"
}

# Escape a value for the replacement side of a sed s|||g command.
sed_escape() { printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'; }

# Absolute physical path of a folder that may not exist yet (nearest existing ancestor resolved).
abspath() {
  local p=$1 rest=""
  while [ ! -d "$p" ]; do
    rest="/$(basename "$p")$rest"
    p=$(dirname "$p")
  done
  printf '%s%s' "$(cd "$p" && pwd -P)" "$rest"
}

check_text() { # name value
  local name=$1 value=$2
  [ -n "$value" ] || die "$name must not be empty"
  case "$value" in
    *'"'* | *'\'* | *'{{'* | *'}}'*) die "$name must not contain double quotes, backslashes, {{ or }}" ;;
  esac
  [ "$(printf '%s' "$value" | wc -l | tr -d ' ')" = "0" ] || die "$name must be a single line"
}

main() {
  case "${1:-}" in -h | --help) usage 0 ;; esac
  [ $# -ge 3 ] && [ $# -le 4 ] || usage 1

  local member=$1 title=$2 desc=$3
  [[ $member =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]] ||
    die "<member> must be lowercase kebab-case (e.g. cto, devops), got '$member'"
  check_text "<Member Title>" "$title"
  check_text "<description>" "$desc"

  local repo="ai-$member" today ROOT target T inplace=0
  today=$(date +%F)
  ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
  [ -f "$ROOT/scripts/member-plugin.json" ] || die "run this from an unmodified template ($ROOT)"
  target=${4:-"$ROOT/../$repo"}

  T=$(abspath "$target")
  case "$T/" in "$ROOT"/?*) die "target must not be inside the template folder: $T" ;; esac
  if [ -e "$T" ]; then
    [ -d "$T" ] || die "target exists and is not a folder: $T"
    if [ "$T" = "$ROOT" ]; then
      inplace=1
    elif [ -n "$(ls -A "$T")" ]; then
      die "target folder is not empty: $T"
    fi
  else
    mkdir -p "$T"
  fi

  # 1. Copy the skeleton (or convert in place).
  local manifest
  manifest=$(cat "$ROOT/scripts/member-plugin.json")
  if [ $inplace -eq 1 ]; then
    echo "Converting the template in place: $T"
    rm -rf "$T/scripts" "$T/TEMPLATE.md"
  else
    echo "Creating $repo in $T"
    (cd "$ROOT" && tar -cf - --exclude './.git' --exclude './scripts' --exclude './TEMPLATE.md' \
      --exclude '.DS_Store' .) | (cd "$T" && tar -xf -)
  fi
  find "$T" -name '.DS_Store' -not -path '*/.git/*' -delete
  printf '%s\n' "$manifest" >"$T/.claude-plugin/plugin.json"

  # sed in-place flag: GNU vs BSD.
  local -a SED_I
  if sed --version >/dev/null 2>&1; then SED_I=(-i); else SED_I=(-i ''); fi

  # 2. Drop the template section of the README.
  LC_ALL=C sed "${SED_I[@]}" -e '/<!-- TEMPLATE:START -->/,/<!-- TEMPLATE:END -->/d' "$T/README.md"

  # 3. Replace placeholders in every file.
  local e_member e_title e_repo e_desc e_date
  e_member=$(sed_escape "$member")
  e_title=$(sed_escape "$title")
  e_repo=$(sed_escape "$repo")
  e_desc=$(sed_escape "$desc")
  e_date=$(sed_escape "$today")
  find "$T" -type f -not -path '*/.git/*' -print0 |
    LC_ALL=C xargs -0 sed "${SED_I[@]}" \
      -e "s|{{member}}|$e_member|g" \
      -e "s|{{Member}}|$e_title|g" \
      -e "s|{{repo}}|$e_repo|g" \
      -e "s|{{description}}|$e_desc|g" \
      -e "s|{{date}}|$e_date|g"

  # 4. Rename {{member}} paths (deepest first).
  local p dir base
  while IFS= read -r -d '' p; do
    dir=$(dirname "$p")
    base=$(basename "$p")
    mv "$p" "$dir/${base//\{\{member\}\}/$member}"
  done < <(find "$T" -depth -name '*{{member}}*' -not -path '*/.git/*' -print0)

  # 5. A member does not hand off to itself: drop its own row from the hand-off table.
  LC_ALL=C sed "${SED_I[@]}" -e "/^| \`$member\` |/d" "$T/RULES.md"

  # 6. Hook executable, git repository.
  chmod +x "$T/hooks/session-context.sh"
  if [ -d "$T/.git" ]; then
    echo "Git repository already exists — left as is."
  else
    git -C "$T" init -q -b main
    echo "Initialised git repository (branch main)."
  fi

  # 7. Sanity check: nothing left to replace.
  local left
  left=$(grep -rn --exclude-dir=.git -e '{{' -e '}}' "$T" || true)
  [ -z "$left" ] || die "placeholders left over:
$left"
  left=$(find "$T" -name '*{{*' -not -path '*/.git/*')
  [ -z "$left" ] || die "paths with placeholders left over:
$left"

  cat <<EOF

Done: $T  (plugin $repo, agent $repo:$member)

Next steps:
  1. Fill the ROLE spots:       grep -rn 'ROLE:' "$T"
     (role description, sources, role-specific hard rules and escalation triggers, hand-offs,
     answer format, skills table, workspace map, setup questions, hook checks)
  2. Write the role skills: copy skills/example-task/ for each, add a row to the RULES.md
     skills table and the README table, then delete skills/example-task/ and adapt
     templates/example-memo.md.
  3. Validate:                  claude plugin validate "$T"
  4. Grep for company data before the first push (names, amounts, IDs, local paths).
  5. Commit, then create the repository HPAIF/$repo (topic ai-team) and push:
       git -C "$T" add -A && git -C "$T" commit -m "$repo 0.1.0"
       gh repo create HPAIF/$repo --public --source "$T" --push
  6. Add $repo to the ai-team catalog: .claude-plugin/marketplace.json and the members table in
     its README; put the repository in the "AI Team" star list.
EOF
}

main "$@"
