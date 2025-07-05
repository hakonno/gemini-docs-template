# Gemini AI Docs Template

[![built-by](https://img.shields.io/badge/built_by-AI-green.svg)](https://gemini.google.com)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This repository is a GitHub Template for a fully automated, AI-powered documentation system. It uses the [Gemini CLI](https://github.com/google-gemini/gemini-cli) within a GitHub Action to automatically generate and update a technical overview document based on your code.

## How It Works

1.  **Push Code:** You push a code change to your `main` branch.
2.  **Action Triggers:** A GitHub Action runs automatically. It identifies the files that have changed.
3.  **AI Generation:** The changed code is sent to the Gemini API, along with the existing documentation, using a carefully engineered prompt.
4.  **Bot Commits:** Gemini returns a complete, updated version of the documentation, which is then committed back to your repository by the "Gemini Doc Bot".

This template also supports **manual runs**, allowing you to regenerate the entire documentation from scratch by clicking a button in the GitHub Actions tab.

---

## Setup in 3 Steps

### Step 1: Use This Template

Click the **"Use this template"** button at the top of this page and select "Create a new repository".

### Step 2: Configure Secure Authentication (Required)

This template uses the recommended **Workload Identity Federation** to securely authenticate with Google Cloud, eliminating the need for long-lived API keys.

You must perform this one-time setup in your Google Cloud project:

1.  **Enable APIs:** Ensure the **Vertex AI API** is enabled in your Google Cloud project.
2.  **Follow the Official Guide:** Go to the [Google GitHub Actions Auth Setup Guide](https://github.com/google-github-actions/auth#setting-up-workload-identity-federation) and complete the steps to create:
    *   A Workload Identity Pool.
    *   A Pool Provider connected to your GitHub repository.
    *   A Service Account (e.g., `gemini-docs-sa`).
    *   Grant the Service Account the `Vertex AI User` role (`roles/aiplatform.user`).
    *   Allow the Service Account to be impersonated by your GitHub repository.
3.  **Add Secrets to GitHub:** In your new repository, go to `Settings > Secrets and variables > Actions` and create three new repository secrets with the values you obtained from the setup above:
    *   `GCP_PROJECT_ID`: Your Google Cloud Project ID.
    *   `GCP_SERVICE_ACCOUNT`: The email of the Service Account you created.
    *   `GCP_WORKLOAD_IDENTITY_PROVIDER`: The full path of the Workload Identity Provider.

> **Note on Costs:** The cost is tied to your Gemini API usage in Google Cloud. The API has a generous free tier, which is often sufficient for many open-source projects. Please consult the official Google Cloud AI pricing page for details.

### Step 3: Run the Action Manually

Go to the "Actions" tab in your repository, select "Gemini AI Docs Updater" from the sidebar, and click the **"Run workflow"** button. This will generate your first `docs/overview.md` file based on all the code in your project.

---

## Customizing the AI

The "brain" of the operation is the prompt located in `.github/scripts/generate_docs.sh`. You can edit this file to change the AI's tone, style, and the structure of the output.

**Default Prompt (Excerpt):**
```bash
# --- Call the Gemini API with a structured prompt ---
gemini --prompt-file - <<PROMPT
You are an expert technical writer for an open-source project.
Your sole task is to maintain a technical overview document in Markdown format.
Be precise, concise, and strictly factual based on the provided code.
...
PROMPT
```

**Example Customization (More Casual Tone):**
```bash
# --- Call the Gemini API with a structured prompt ---
gemini --prompt-file - <<PROMPT
You are a friendly developer evangelist writing a blog post about a project.
Explain the recent code changes in a casual, easy-to-understand way.
Always include code snippets to illustrate new features.
...
PROMPT
```

---

## The Local Workflow: `git pull` is Your Friend

This project uses a "bot-in-the-middle" workflow. It's simple, but requires one important habit:

1.  You `git push` your code changes.
2.  The GitHub Action runs and the `Gemini Doc Bot` pushes a new commit with documentation updates.
3.  **Before you push again, you must run `git pull`** to get the bot's changes. This prevents Git conflicts.

```
Code -> git push -> [Action Runs] -> Bot pushes docs -> git pull -> Code again
```