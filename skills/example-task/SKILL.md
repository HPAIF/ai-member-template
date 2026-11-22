---
name: example-task
# ROLE: copy this folder to skills/<task-name>/, rename `name`, and write a description that says
# what the skill does and when to use it (the words a founder would say). Delete this example.
description: "Example {{Member}} skill to copy: answer a question in the {{member}}'s area for the founder's company with sources, a saved memo and a recorded result. Use for any substantive question in the {{member}}'s area."
---

# example-task

1. **Load memory.** `ai-team/company/profile.md`, the relevant `ai-team/company/products/*.md`,
   active lessons in `ai-team/{{member}}/learnings.md`, the last ~20 entries of
   `ai-team/{{member}}/history/journal.md`, and anything related in `history/decisions.md`,
   `history/obligations.md` and `research/` (earlier memos on the topic).
2. **Pin down the facts.** List the facts you rely on and the assumptions you make. If one
   missing fact would change the answer, ask the founder that one question first (or answer
   under each alternative, clearly labelled).
3. **Do the work.** <!-- ROLE: the actual procedure — what to check, in what order, with which
   sources or tools. Be concrete: numbered sub-steps beat general advice. -->
4. **Check before relying.** Every fact that can change (version, price, rule, limit) is checked
   against its primary source in this conversation; anything unchecked is marked **UNVERIFIED**.
5. **Answer** in the format in `RULES.md`. Parts that belong to another member → write the exact
   question for them (see "Team work").
6. **Save** a memo `ai-team/{{member}}/research/R-XXXX-slug.md` (next free number) from
   `${CLAUDE_PLUGIN_ROOT}/templates/example-memo.md` when the question is substantive (anything
   the founder may act on). Skip only for trivial lookups.
7. **Update memory** with `{{repo}}:log-job`: journal entry; new obligations/actions; decisions
   the founder makes; company facts learned; learnings.
8. **Escalate** if rule 7 of `RULES.md` applies — say so in the first line of the answer.
