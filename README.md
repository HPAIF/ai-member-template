<!-- TEMPLATE:START -->
> **This is the AI Team member template** (`ai-member-template`), not a member. It holds the
> skeleton of a new AI Team member plugin with the placeholders `{{member}}`, `{{Member}}`,
> `{{repo}}` and `{{description}}`. Generate a member with
> `scripts/new-member.sh <member> "<Member Title>" "<description>" [target-dir]` — see
> [TEMPLATE.md](TEMPLATE.md) for the full guide and the member checklist. Everything between the
> template markers in this README is removed from generated members.
<!-- TEMPLATE:END -->
# AI {{Member}}

{{description}}

An in-house {{Member}} for founders, running in Claude Code. Part of the
**[AI Team](https://github.com/HPAIF/ai-team)** — agents that work together for your company in
one private `ai-team/` workspace.

<!-- ROLE: 2–4 lines on what this member does for the founder and what it is not. -->

## Install

In Claude Code:

```
/plugin marketplace add HPAIF/ai-team
/plugin install {{repo}}@ai-team
```

Then, in your project, say **"set up the AI {{member}}"**. The `setup` skill creates (or joins) a
private `ai-team/` workspace and offers `.gitignore`, permissions and scheduled runs. Nothing
leaves your machine.

To share the setup with your team, commit this to the project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "ai-team": { "source": { "source": "github", "repo": "HPAIF/ai-team" } }
  },
  "enabledPlugins": { "{{repo}}@ai-team": true }
}
```

## Use it

Talk normally — Claude hands {{Member}} work to the `{{repo}}:{{member}}` agent — or start a
session as the {{member}}: `claude --agent {{repo}}:{{member}}`.

| You say | What happens (skill) |
|---|---|
| "Set up the AI {{member}}" | workspace created or upgraded (`setup`) |
| "We decided …" / "this changed …" | history and company facts updated (`log-job`) |
| "Improve yourself" | anonymised upgrade proposal for this plugin (`improve`) |

<!-- ROLE: add one row per role skill. -->

Each session in a project with a workspace starts with overdue and upcoming obligations, recent
jobs and pending learnings (session hook).

## How it is built

```
RULES.md                 hard rules: read memory first, log every job, never invent, confidentiality…
agents/{{member}}.md     the agent (reads RULES.md and the workspace)
skills/                  setup · log-job · improve · role skills
templates/               document formats
hooks/                   session-start context
```

Your data lives in **your project**, never in the plugin:

```
ai-team/
├── team.md                  installed members, jurisdiction
├── company/                 shared with other members: profile, documents, products/<product>.md
└── {{member}}/              learnings, history (journal, decisions, obligations), research,
                             digests, inbox
```

See the [workspace contract](https://github.com/HPAIF/ai-team/blob/main/docs/workspace.md).

## Privacy
- The plugin is public; your workspace is private. Keep `ai-team/` out of public repositories
  (`setup` offers to add it to `.gitignore`) — `git init` inside it for a private history.
- The {{member}} searches the web for the *general question*, never your company's facts.
- Files the agent reads are processed by the model you use in Claude Code.

## Self-improvement
1. After corrections, mistakes, broken sources or missing steps, the {{member}} writes a lesson to
   `ai-team/{{member}}/learnings.md` and applies it from then on.
2. Lessons useful to everyone are marked `general`. The `improve` skill turns them into an
   anonymised pull request to this repository — only after you approve the exact text, and never
   one that weakens the hard rules.
3. Merged improvements reach every user with the next plugin update.

## Upgrading
`/plugin marketplace update ai-team`, then `/plugin update {{repo}}@ai-team` (restart Claude
Code). Run "set up the AI {{member}}" again to apply workspace migrations; it never overwrites
your history.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md). License: [MIT](LICENSE).
