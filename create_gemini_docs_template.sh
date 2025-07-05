#!/bin/bash
set -e

# --- 1. Setup Project Directory and Git ---
echo " Starting setup for gemini-docs-template..."
mkdir gemini-docs-template
cd gemini-docs-template
git init

# --- 2. Create Directory Structure ---
mkdir -p .github/workflows
mkdir -p .github/scripts
mkdir -p docs

echo "✅ Directory structure created."

# --- 3. Create .gitignore ---
cat <<'EOF' > .gitignore
# Node
node_modules/
npm-debug.log
yarn-error.log
dist/

# Python
__pycache__/
*.pyc
.env
.venv
venv/
env/
EOF

# --- 4. Create README.md ---
cat <<'EOF' > README.md
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
EOF

echo "✅ README.md created."

# --- 5. Create the GitHub Action Workflow ---
cat <<'EOF' > .github/workflows/docs_updater.yml
name:  Gemini AI Docs Updater

on:
  push:
    branches:
      - main
    paths-ignore:
      - 'docs/**'
      - 'README.md'

permissions:
  contents: write
  id-token: write

jobs:
  update_documentation:
    runs-on: ubuntu-latest
    if: "!contains(github.event.head_commit.message, 'docs:')"

    steps:
      - name: 1. Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: 2. Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          # ⚠️ Replace these with your actual Google Cloud configuration values
          workload_identity_provider: 'projects/YOUR_PROJECT_ID/locations/global/workloadIdentityPools/YOUR_POOL_ID/providers/YOUR_PROVIDER_ID'
          service_account: 'your-service-account@your-project-id.iam.gserviceaccount.com'

      - name: 3. Install Gemini CLI
        uses: google-gemini/setup-gemini@v0.3.0

      - name: 4. Get Changed Files
        id: changed_files
        run: |
          echo "files=$(git diff --name-only HEAD~1 HEAD | grep -vE '^(docs/|README.md|\.github/)' | xargs)" >> $GITHUB_OUTPUT

      - name: 5. Run Gemini Docs Generator
        if: steps.changed_files.outputs.files != ''
        id: gemini_run
        run: |
          bash .github/scripts/generate_docs.sh "${{ steps.changed_files.outputs.files }}" > temp_docs.md

      - name: 6. Commit and Push Documentation
        if: steps.gemini_run.outcome == 'success'
        run: |
          mv temp_docs.md docs/overview.md
          
          git config --global user.name 'Gemini Doc Bot'
          git config --global user.email 'gemini-bot@users.noreply.github.com'
          git add docs/overview.md
          
          if ! git diff --staged --quiet; then
            git commit -m "docs: ✨ automatic update by Gemini"
            git push
          else
            echo "No documentation changes were generated."
          fi
EOF

echo "✅ GitHub Action workflow created."

# --- 6. Create the Core Script ---
cat <<'EOF' > .github/scripts/generate_docs.sh
#!/bin/bash
set -e

# --- Inputs ---
CHANGED_FILES_STRING=$1
DOCS_FILE="docs/overview.md"

# --- Build context from changed files ---
CODE_CHANGES=""
for file in $CHANGED_FILES_STRING; do
  if [ -f "$file" ]; then
    CODE_CHANGES+="--- File: $file ---\n"
    CODE_CHANGES+=$(cat "$file")
    CODE_CHANGES+="\n\n"
  else
    CODE_CHANGES+="--- File: $file (deleted) ---\n\n"
  fi
done

# --- Read existing documentation for context ---
if [ -f "$DOCS_FILE" ]; then
  EXISTING_DOCS=$(cat "$DOCS_FILE")
else
  EXISTING_DOCS="This is a new project. Please create a technical overview based on the code provided."
fi

# --- Call the Gemini API with a structured prompt ---
gemini --prompt-file - <<PROMPT
You are an expert technical writer for an open-source project.
Your sole task is to maintain a technical overview document in Markdown format.
Be precise, concise, and strictly factual based on the provided code.
Do NOT add any conversational fluff, introductions, or conclusions.
Your entire output must be ONLY the raw, updated Markdown content for the documentation file.

--- EXISTING DOCUMENTATION ---
$EXISTING_DOCS

--- RECENT CODE CHANGES ---
The following files were just changed. Update the existing documentation to reflect the new state of the project. Ensure the final text is a complete, coherent, and up-to-date version of the entire document.
$CODE_CHANGES
PROMPT
EOF

# Make the script executable
chmod +x .github/scripts/generate_docs.sh

echo "✅ Core generation script created."

# --- 7. Create Placeholder Docs ---
cat <<'EOF' > docs/overview.md
# Project Documentation

This documentation is maintained automatically by the Gemini AI.
It will be populated with a technical overview on the first code commit.
EOF

# --- 8. Create Git Commits ---
git add .
git commit -m "feat: initial project structure and config"

git add README.md
git commit -m "docs: add comprehensive README for template"

git add .github/workflows/docs_updater.yml .github/scripts/generate_docs.sh
git commit -m "ci: add GitHub Action for automated documentation"

git add docs/overview.md
git commit -m "docs: add initial placeholder for documentation"

echo "✅ Git history created with conventional commits."
echo ""
echo " Success! The 'gemini-docs-template' repository is ready."
echo "Next steps:"
echo "1. Run 'cd gemini-docs-template'"
echo "2. Create a new repository on GitHub."
echo "3. Run 'git remote add origin <your-github-repo-url>'"
echo "4. Run 'git push -u origin main'"
echo "5. Configure the Workload Identity Federation in Google Cloud and update the .yml file."
