# Changelog

All notable changes to the AI {{Member}}. Versions follow semver: patch = fixes and wording,
minor = new skill / workspace files, major = breaking workspace change.
Entries that need a workspace change list a **Migration** step; `setup` (upgrade mode) applies it.

## 0.1.4 — 2026-11-23
- Talk to colleagues only where the founder sees it: no hidden Agent-tool calls; @mention in group
  chats (one answer, no discussion without the founder); "For @member:" elsewhere.

## 0.1.3 — 2026-11-23
- Missed questions: an unanswered question that still matters is repeated briefly under
  "Still open:" at the end of the next answer.

## 0.1.2 — 2026-11-23
- Ask colleagues directly, never through the founder: @mention in group chats, the Agent tool
  as main agent, "Question for @member" when called by the lead.

## 0.1.1 — 2026-11-23
- Rule "Be concise": shortest answer that keeps all important information (warnings, numbers,
  dates, sources, decisions); long only when the content needs it.

## 0.1.0 — {{date}}
- First release, generated from the AI Team member template.
- Agent `{{member}}`, rules (`RULES.md`), skills: setup, log-job, improve.
- Shared AI Team workspace (`ai-team/`, contract v1); the workspace is found in the project
  folder or any parent folder.
- Self-improvement: `learnings.md` + `improve` (anonymised, founder-approved pull requests).
