#!/bin/bash
# AI {{Member}} — SessionStart hook.
# Prints the member's memory for this project: date, company stage, overdue/upcoming obligations,
# last journal entries, pending learnings, inbox and latest digest.
# Silent when no ai-team/{{member}} workspace exists in the project folder or any parent folder.
set -u
# Find the nearest workspace: ai-team/{{member}} in the project folder or any parent folder
# (a company folder can hold ai-team/ next to projects/<product>/).
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
WS=""
while [ -n "$dir" ] && [ "$dir" != "/" ]; do
  if [ -d "$dir/ai-team/{{member}}" ]; then WS="$dir/ai-team"; break; fi
  dir=$(dirname "$dir")
done
[ -n "$WS" ] || exit 0
ME="$WS/{{member}}"
cd "$ME" || exit 0

version=$(grep -m1 '"version"' "${CLAUDE_PLUGIN_ROOT:-.}/.claude-plugin/plugin.json" 2>/dev/null | sed 's/.*"version": *"\([^"]*\)".*/\1/')
today=$(date +%F)
soon=$(date -v+30d +%F 2>/dev/null || date -d '+30 days' +%F)

echo "=== AI {{Member}} ${version:+v$version }— session context (${today}) ==="
echo "Rules: ${CLAUDE_PLUGIN_ROOT:-<plugin>}/RULES.md (agent {{repo}}:{{member}}). Read memory first. Log every job (log-job)."
echo "Workspace: $WS  (every ai-team/... path in the rules and skills means this folder)"

stage=$(grep -m1 '^- \*\*Stage:\*\*' "$WS/company/profile.md" 2>/dev/null | sed 's/^- \*\*Stage:\*\* *//')
juris=$(grep -m1 '^- \*\*Jurisdiction:\*\*' "$WS/team.md" 2>/dev/null | sed 's/^- \*\*Jurisdiction:\*\* *//')
echo "Company stage: ${stage:-unknown} · Jurisdiction: ${juris:-unknown}"
echo

echo "--- Obligations: overdue or due by ${soon} ---"
if [ -f history/obligations.md ]; then
  awk -F'|' -v today="$today" -v soon="$soon" '
    /^\| O-/ {
      id=$2; due=$3; type=$4; what=$5; status=$7
      gsub(/^ +| +$/, "", id); gsub(/^ +| +$/, "", due); gsub(/^ +| +$/, "", type)
      gsub(/^ +| +$/, "", what); gsub(/^ +| +$/, "", status)
      if (status == "open" && due ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/ && due <= soon) {
        flag = (due < today) ? "OVERDUE " : ""
        printf "%s%s  %s  [%s] %s\n", flag, id, due, type, what; n++
      }
      if (status == "open" && due == "—") u++
    }
    END { if (n == 0) print "(none)"; if (u > 0) printf "(+ %d open items without a date)\n", u }' history/obligations.md
else
  echo "(no history/obligations.md — run {{repo}}:setup to repair)"
fi
echo

echo "--- Last journal entries ---"
j=$(grep '^## J-' history/journal.md 2>/dev/null | tail -n 6)
echo "${j:-(none)}"
echo

# ROLE: add member-specific checks here (e.g. stale cards, open incidents, unreviewed ADRs).

pending=$(grep -c '^| L-[0-9]* .*| general .*| pending' learnings.md 2>/dev/null || true)
inbox=$(find inbox -type f ! -name 'README.md' ! -name '.*' 2>/dev/null | wc -l | tr -d ' ')
latest=$(ls -1 digests/20*.md 2>/dev/null | tail -n 1)
echo "Inbox: ${inbox:-0} file(s) · Pending general learnings: ${pending:-0}$( [ "${pending:-0}" -ge 3 ] && echo ' → suggest {{repo}}:improve') · Latest digest: ${latest:-none yet}"
exit 0
