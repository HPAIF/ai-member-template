# AI Team member template

Start a new AI Team member (a Claude Code plugin such as `ai-cto`, `ai-devops`, `ai-security`) in
minutes. This repository is the skeleton of a member, built from the reference member
[`ai-lawyer`](https://github.com/HPAIF/ai-lawyer), with placeholders instead of the role.

This file, `scripts/` and the template section at the top of `README.md` are **not** copied into
generated members.

## Placeholders

| Placeholder | Meaning | Example |
|---|---|---|
| `{{member}}` | lowercase agent and folder name (`agents/{{member}}.md`, `ai-team/{{member}}/`) | `cto` |
| `{{Member}}` | display title | `CTO` |
| `{{repo}}` | plugin and repository name, always `ai-{{member}}` | `ai-cto` |
| `{{description}}` | one or two sentences; the plugin description and the start of the agent description | `In-house technical lead: architecture, technology choices and code quality.` |
| `{{date}}` | today, filled in by the script (CHANGELOG) | `2027-01-15` |

Role-specific spots that need writing by hand are marked `<!-- ROLE: … -->` (`# ROLE:` in YAML
and shell). Find them with `grep -rn 'ROLE:' .`.

## Option A — GitHub "Use this template"

1. On GitHub, **Use this template → Create a new repository** under `HPAIF`, named `ai-<member>`
   (public, add the `ai-team` topic).
2. Clone it into the local catalog folder (see the AI Team docs, *Adding a member*):
   `git clone git@github.com:HPAIF/ai-<member>.git && cd ai-<member>`
3. Convert it in place — the script sees that the target is the template folder itself, removes
   `scripts/`, `TEMPLATE.md` and the README template section, and keeps the existing `.git`:

   ```bash
   scripts/new-member.sh cto "CTO" "In-house technical lead: architecture, technology choices and code quality." .
   ```

## Option B — clone and run the script

```bash
git clone git@github.com:HPAIF/ai-member-template.git   # once, next to the other members
ai-member-template/scripts/new-member.sh cto "CTO" "In-house technical lead: architecture, technology choices and code quality."
# → ../ai-cto (next to the template), fresh `git init -b main`
```

A fourth argument sets another target folder (it must be empty or not exist yet).

### What the script does
1. Copies the skeleton (everything except `.git`, `scripts/`, `TEMPLATE.md`) to the target.
2. Writes `.claude-plugin/plugin.json` from `scripts/member-plugin.json` (the template's own
   manifest describes the template, so the template repository itself validates).
3. Removes the template section of `README.md` (between the `TEMPLATE:START/END` markers).
4. Replaces every placeholder in every file and renames `{{member}}` paths.
5. Drops the member's own row from the hand-off table in `RULES.md`.
6. Makes `hooks/session-context.sh` executable and runs `git init -b main` (unless `.git` exists).
7. Fails if any `{{`/`}}` is left, then prints the next steps.

Inputs: `<member>` must be lowercase kebab-case; the title and description must be one line
without double quotes or backslashes (they go into JSON and YAML).

## Member checklist

Mirrors *Adding a member* in the AI Team docs.

1. **Workspace contract** — own folder `ai-team/<member>/`, shared `company/`, append-only history,
   `learnings.md`, obligations table exactly
   `| ID | Due | Type | What | Source / why | Status |` (the session hook reads it). Already in
   the skeleton; keep it.
2. **Shared templates verbatim** — `skills/setup/workspace/README.md`, `team.md` and `company/`
   are byte-identical copies from `ai-lawyer`. Never edit them in one member; if they change,
   change every member (and this template) together.
3. **Hand-offs** — `RULES.md` "Team work" lists every member; add concrete lines for this role's
   common overlaps ("questions about X belong to member Y").
4. **Fill the ROLE spots** — role description, role sources, role-specific hard rules and
   escalation triggers, answer format, scheduled runs, setup questions, hook checks.
5. **Role skills** — copy `skills/example-task/` per task; add each to the RULES.md skills table
   and the README table; delete `example-task` and adapt or replace `templates/example-memo.md`.
   Extra workspace folders go into `skills/setup/workspace/<member>/` with a README, into the
   setup skill and the RULES.md workspace map.
6. **Validate** — `claude plugin validate .` passes.
7. **No company data** — grep the repository for company names, people, amounts, IDs and local
   paths before the first push.
8. **Publish** — create `HPAIF/ai-<member>` (topic `ai-team`), push, add it to the catalog's
   `.claude-plugin/marketplace.json` and the members table in the `ai-team` README, and put it in
   the "AI Team" star list.

## Keeping the template current

When `ai-lawyer` (the reference member) changes something universal — rules, the hook, the
setup/log-job/improve skills, the shared workspace files — port the change here, bump the
template version in `.claude-plugin/plugin.json` and note it below. Check that the template
itself still validates (`claude plugin validate .`) and that a generated member does too.

## Template changelog

- **0.1.0** — first version, based on `ai-lawyer` 0.2.0 (workspace found in parent folders,
  setup with Location step and upgrade mode).
