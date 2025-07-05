# Documentation Overview & AI Directives

This file is the entry point for the project's documentation. It contains a dynamically updated index and the core rules for the AI agent responsible for maintaining it.

## 1. Core Purpose

The `docs/` directory is the "living brain" of this project. It is maintained primarily by AI agents to provide context for future development and to serve as a reference for human developers.

## 2. AI Agent Rules of Engagement

As an AI agent, you must adhere to the following rules when managing this documentation.

### Rule 1: Start Here, Always
Always read this file (`docs/README.md`) first to understand your directives before reading or modifying any other file.

### Rule 2: Update Before Creating
When documenting new features, learnings, or code changes, first search the existing files (listed in the index below) for a suitable place to add the information. The goal is to keep information consolidated and contextual.

### Rule 3: Create New Files When Necessary
Create a new, descriptively-named `.md` file only if the information represents a new, distinct concept (e.g., `authentication_flow.md`, `database_schema.md`) that does not fit naturally into any existing document.

After creating a new file, you **must** immediately update the index in this `README.md` with a link to the new file and a one-sentence description.

### Rule 4: Refactor Documentation Aggressively
- **Split:** If a file grows too long (e.g., over 500 lines) and covers multiple distinct sub-topics, split it into more focused files.
- **Merge:** If multiple small files cover very similar topics, merge them into a single, more comprehensive file.
- **Organize:** Consider creating sub-folders (e.g., `docs/api/`, `docs/ui/`) to group related files if a topic becomes complex with many documents.
- **Update Index:** Always update the index below after any refactoring.

### Rule 5: Prioritize and Be Concise
- **Mark Importance:** Use `**[CRITICAL]**` to flag information essential for the project's function (e.g., security vulnerabilities, core architectural constraints). Use `**[KEY-CONCEPT]**` for important patterns or decisions.
- **Remove Redundancy:** Eliminate superfluous information and summarize where possible, but never at the expense of critical details.

---

## 3. Documentation Index

*This index is managed by the AI agent and should always be up-to-date.*

- [**Agent Instructions**](./AGENT_INSTRUCTIONS.md): Central instructions for AI agents working in this repo.
- [**Project Overview**](./overview.md): A high-level summary of the project's purpose and goals.
