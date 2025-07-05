# Gemini Docs Template

[![built-by](https://img.shields.io/badge/built_by-AI-green.svg)](https://gemini.google.com)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This repository is a GitHub Template for setting up a fully automated, AI-powered documentation system for your own projects. It uses the [Gemini CLI](https://github.com/google-gemini/gemini-cli) within a GitHub Action to automatically update your documentation based on your code commits.

## How It Works

1.  You push a code change to your `main` branch.
2.  A GitHub Action triggers automatically.
3.  The Action identifies the files you've changed.
4.  It sends the code changes to the Gemini API, along with your existing documentation, using a carefully engineered prompt.
5.  Gemini returns an updated, complete version of your documentation.
6.  The Action commits the new documentation back to your repository under the "Gemini Doc Bot" user.

## How to Use This Template

1.  Click the **"Use this template"** button at the top of this repository's page and select "Create a new repository".
2.  Follow the setup instructions below.

##  Setup: Secure Authentication (Required)

This template uses the recommended **Workload Identity Federation** to securely authenticate with Google Cloud from GitHub Actions, eliminating the need for long-lived API keys.

You must perform this one-time setup in your Google Cloud project:

1.  **Enable the required API**: Make sure the "Vertex AI API" is enabled in your Google Cloud project.
2.  **Follow the official guide**: Go to the [Google GitHub Actions Auth Setup Guide](https://github.com/google-github-actions/auth#setting-up-workload-identity-federation) and complete the steps to create:
    * A Workload Identity Pool.
    * A Pool Provider connected to your GitHub repository.
    * A Service Account (e.g., `gemini-docs-sa`).
    * Grant the Service Account the `Vertex AI User` role (`roles/aiplatform.user`).
    * Allow the Service Account to be impersonated by your GitHub repository.
3.  **Update the Workflow File**: In the `.github/workflows/docs_updater.yml` file, replace the placeholder values for `YOUR_PROJECT_ID`, `YOUR_POOL_ID`, `YOUR_PROVIDER_ID`, and your service account email with the values from your setup.

That's it! Your repository is now configured to automatically generate and update its own documentation.
