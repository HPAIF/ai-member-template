# Contributing

Improvements are welcome — new skills, better procedures, fixes to sources and templates.
Many will arrive as pull requests from the agent's own `improve` skill.

## The one rule: no company data
This repository is public. Never commit anything from an `ai-team/` workspace: names, amounts,
IDs, contracts, addresses, hostnames, keys, dates of private events, quotes from private
documents. Use neutral examples ("a SaaS supplier", "a monthly subscription").

## What goes where
| Change | File |
|---|---|
| A rule every company should follow | `RULES.md` (rules may be added or clarified, never weakened) |
| A procedure | `skills/<skill>/SKILL.md` (new skill → new folder + row in RULES.md skills table) |
| A document format | `templates/` |
| Workspace files | `skills/setup/workspace/` + a **Migration** note in `CHANGELOG.md` |

Shared workspace files (`skills/setup/workspace/README.md`, `team.md`, `company/`) are identical
in every AI Team member. Change them in all members together, never in one alone.

Hard rules that may never be weakened: read memory first · log every job · append-only history ·
never invent · confidentiality · never act externally without explicit approval · escalation.
<!-- ROLE: add the role-specific hard rules from RULES.md here. -->

## Release
1. Bump `version` in `.claude-plugin/plugin.json` (patch / minor / major — see CHANGELOG).
2. Add a `CHANGELOG.md` entry (with a Migration step if the workspace changes).
3. `claude plugin validate .` must pass.
4. Merge to `main`. Users get it with `/plugin update {{repo}}@ai-team`.
