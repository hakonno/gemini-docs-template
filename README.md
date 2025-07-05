# AI-Powered Documentation Template

[![built-by](https://img.shields.io/badge/built_by-AI_Agents-green.svg)](https://gemini.google.com)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This repository is a GitHub Template for creating a project with a "living" documentation system, maintained primarily by AI agents.

The core idea is to maintain a `docs/` directory that AI agents can read to gain full context of a project, and update to reflect new changes. This solves the problem of "context drift" where AI agents lose track of the project's state over time.

## How It Works

This template provides a framework for AI agents to manage documentation. It is designed to be used with modern AI coding assistants like **GitHub Copilot**, **Gemini**, and **Cursor**.

1.  **Standardized Instructions:** The template includes instruction files (`GEMINI.md`, `.github/copilot/instructions.md`, `.cursorrules`) that point the AI agent to a central set of rules located in `docs/AGENT_INSTRUCTIONS.md`.
2.  **Core Directives:** The `docs/README.md` file contains a set of rules and heuristics that tell the agent *how* to manage the documentation—when to create new files, when to update existing ones, and how to refactor them for clarity.
3.  **Agent-Driven Workflow:**
    *   **On session start,** you instruct your AI agent to read the `docs/` directory to get up to speed.
    *   **After implementing changes,** you instruct your agent to update the `docs/` directory with everything it has learned.
4.  **Automation (Optional):** A skeleton GitHub Action workflow is included in `.github/workflows/docs_updater.yml`. You can adapt this to automatically run an AI agent to update the docs after every commit, creating a fully autonomous documentation system.

## Getting Started

### Step 1: Use This Template

Click the **"Use this template"** button at the top of this page and select "Create a new repository".

### Step 2: Choose Your AI Agent

This template is pre-configured for:
*   **Gemini:** Use the Gemini CLI. Instructions are in `GEMINI.md`.
*   **GitHub Copilot:** Works with Copilot Chat in your IDE. Instructions are in `.github/copilot/instructions.md`.
*   **Cursor:** A powerful AI-first code editor. Instructions are in `.cursorrules`.

### Step 3: Follow the Agent Workflow

1.  **Start your coding session** by feeding your chosen agent the "Onboarding" prompt from `docs/AGENT_INSTRUCTIONS.md`. This loads the project context into the AI.
2.  **Write your code** with the help of your now context-aware AI assistant.
3.  **End your session** by feeding the agent the "Task Completion" prompt from `docs/AGENT_INSTRUCTIONS.md`. This saves the new knowledge back into the documentation.

This loop ensures the `docs/` directory is always a fresh, accurate "brain" for the project.

## The "Living Docs" Philosophy

The goal is not to create static, hand-written documentation. The goal is to create a dynamic, self-organizing knowledge base that allows AI agents to perform complex tasks over long periods without losing context.

The documentation is for the agents, by the agents. Human developers benefit by having more capable AI assistants.

---

This template provides the *framework*. The *intelligence* comes from how you and your AI agent interact with it. Experiment, adapt the rules in `docs/README.md`, and find the workflow that works best for you.
