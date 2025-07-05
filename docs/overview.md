# Project Overview

This project is a template for creating and maintaining a "living" documentation system that is primarily managed by AI agents.

## **[KEY-CONCEPT]** Core Architecture

The system is built on a few key principles:

1.  **Single Source of Truth for Instructions:** A central `docs/AGENT_INSTRUCTIONS.md` file provides consistent prompts for different AI agents (Gemini, Copilot, Cursor).
2.  **Self-Governing Documentation:** The `docs/README.md` file contains a set of rules that instruct AI agents on how to manage the documentation itself. This includes creating, updating, and refactoring documentation files.
3.  **Agent-Driven Workflow:** The primary workflow involves a human developer guiding an AI agent to read the `docs/` directory for context, perform coding tasks, and then update the `docs/` directory with the new knowledge.
4.  **Optional Automation:** A GitHub Actions workflow (`.github/workflows/docs_updater.yml`) provides a skeleton for users who wish to fully automate the documentation updates after each commit.

## **[CRITICAL]** Project Goal

The main goal of this template is to solve the problem of "context drift" in long-running software projects developed with AI agents. By giving the agent a persistent, self-managed knowledge base (`docs/`), it can maintain high-quality context over time, leading to more accurate and efficient development.

This template does not contain any production code itself; it is a meta-project designed to be a starting point for other projects.
