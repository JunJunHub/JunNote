# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Type

This is an **Obsidian vault** - a personal knowledge management system using Markdown files. It is NOT a traditional software development project with build scripts, tests, or deployment processes.

## Repository Structure

The vault is organized with numbered prefixes for categorization:

- `00-PersonalInfo/` - Personal information, resumes, capability matrices
- `01-Work/` - Work-related notes
- `05-PDFBook/` - PDF book notes
- `06-Classification/` - Classified reference materials
- `07-AICode/` - AI coding environment configuration and prompt templates
- `DiaryBook/` - Daily journal entries (YYYY-MM-DD.md format)
- `Excalidraw/` - Excalidraw diagram files
- `Notebook/` - General notebook entries

## Key Configuration

### `.gitignore`

The following directories are explicitly excluded from version control:
- `.obsidian/` - Obsidian plugin and app configuration
- `00-PersonalInfo/` - Sensitive personal information
- `01-work/` - Work-related materials
- `02-CodeComponents/` - Code component library
- `03-Tools/` - Tool configurations

## AI Coding Configuration (07-AICode/)

This directory contains environment setup notes for AI-assisted coding:

### Development Environment Setup

The vault documents include guides for setting up:

1. **PowerShell** - Profile configuration for execution policy (`Set-ExecutionPolicy RemoteSigned`)
2. **Node.js** - Via nvm-windows for version management
3. **Python** - Via pyenv-win for version management
4. **Scoop** - Unified SDK version management

### Common Commands

**Node.js (via nvm):**
```shell
nvm list available           # View available versions
nvm install 20.11.0          # Install specific version
nvm use 20.11.0              # Switch version
nvm alias default 20.11.0    # Set default
```

**Python (via pyenv):**
```shell
pyenv install --list         # View available versions
pyenv install 3.12.1         # Install specific version
pyenv global 3.12.1          # Set global version
pyenv local 3.11.7           # Set directory-specific version
```

### Git Operations

To update `.gitignore` for already tracked files:
```shell
git rm -r --cached .
git add .
git commit -m "update .gitignore"
```

## Content Guidelines

When working with this vault:
- Files are primarily Markdown (.md)
- Use Chinese language for notes as appropriate
- Respect the existing prefix-based directory structure
- Add `.md` extension for new note files
- Consider the categorization when placing new content in directories
