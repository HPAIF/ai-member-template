---
name: setup
description: "Set up (or repair/upgrade) the AI {{Member}} in the current project — creates the private ai-team/ workspace (shared company files + ai-team/{{member}}/), registers the {{member}} in team.md, and offers privacy, permissions and scheduled runs. Use on first use in a project, when the workspace is missing, or after a plugin update that changes the workspace."
---

# setup

Template files are in `${CLAUDE_PLUGIN_ROOT}/skills/setup/workspace/`. Never overwrite an
existing file in `ai-team/` — the workspace may already hold real history.

1. **Explain** in two lines what will be created (`ai-team/` private workspace) and that nothing
   leaves the machine.
   **Location:** if an `ai-team/` already exists in this folder or a parent folder, join it —
   never create a second one. Otherwise ask where to create it: in this folder (default), or in a
   parent company folder when this project is one of several products (layout
   `<company>/ai-team/` next to `<company>/projects/<product>/`).
2. **Ask** (one question at a time, skip what is already in `ai-team/team.md`):
   - jurisdiction (country of the company) — record it in `team.md`; `TBD` is fine;
   - answer language (default English).
   <!-- ROLE: add role-specific questions here (e.g. tech stack, hosting, markets). Keep them
   few; everything else can be asked later and recorded as obligations. -->
3. **Create shared files if missing** (another member may have created them already):
   `ai-team/README.md`, `ai-team/team.md`, `ai-team/company/profile.md`,
   `ai-team/company/documents.md`, `ai-team/company/products/_template.md`. Fill `team.md`
   (jurisdiction, date, `workspace_contract: 1`) and the profile's stage date and jurisdiction.
4. **Create the member folder** `ai-team/{{member}}/` from the template's `{{member}}/` folder:
   `learnings.md`, `history/{journal,decisions,obligations}.md`, `research/README.md`,
   `digests/README.md`, `inbox/README.md`.
   <!-- ROLE: list the member's own extra folders/files here too. -->
5. **Register** a row in `team.md`: `{{member}} | {{repo}} | {{repo}}:{{member}} |
   ai-team/{{member}}/ | <plugin version> | <today> | {{description}}`.
   <!-- ROLE: replace the last column with a short list of the areas this member covers. -->
6. **First journal entry** `J-0001 · <today> · setup` and obligation
   `O-0001` "Fill in company/profile.md and a product file in company/products/" (due in 14 days)
   unless another member already created that obligation (check their obligations files).
   If products are described in the project (README, docs), offer to draft the product file
   from them — the founder confirms before you write.
7. **Offer, don't force** (ask each; do only what is approved):
   - **Privacy:** if the project is a git repo, add `ai-team/` to `.gitignore`; suggest
     `git init` inside `ai-team/` for private history.
   - **Permissions:** add the allow-list this member needs to the project's
     `.claude/settings.json` (show the exact entries first).
   - **Scheduled runs:** create them if a scheduling tool is available in this session;
     otherwise explain how to schedule them in the Claude app.
   <!-- ROLE: name the permissions (e.g. WebFetch domains) and scheduled runs (skill + cadence)
   for this member, or delete the bullets that don't apply. -->
8. **Upgrade mode** (workspace exists): compare with the template, create only missing files or
   folders, apply migrations listed in `CHANGELOG.md` for versions newer than the one in
   `team.md`, update the version in `team.md`, and log what changed.
9. Finish with a short summary: what exists now, the three most useful first questions to ask
   the {{member}}, and `log-job`.
