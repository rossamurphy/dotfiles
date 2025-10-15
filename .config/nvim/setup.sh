#!/usr/bin/env bash

# Neovim Configuration Setup Script
# Run this script on a new machine to install all dependencies for your nvim config

set -e  # Exit on error

echo "================================"
echo "Neovim Setup Script"
echo "================================"
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed."
    echo "Please install Homebrew first: https://brew.sh"
    exit 1
fi

echo "Installing Homebrew packages..."
echo "-------------------------------"

# Core utilities
brew install neovim
brew install trash
brew install lua
brew install luarocks
brew install ripgrep
brew install git
brew install tmux
brew install gh  # GitHub CLI (for octo.nvim)
brew install node
brew install yarn
brew install imagemagick  # For img-clip.nvim image conversion
brew install python3
brew install pipx  # For installing Python CLI tools globally

echo ""
echo "Installing language servers and formatters..."
echo "---------------------------------------------"

# Language servers and tools (commonly used with Mason)
brew install lua-language-server
brew install stylua  # Lua formatter

echo ""
echo "Installing Node.js packages..."
echo "------------------------------"

# Global npm packages that might be needed
npm install -g neovim
npm install -g typescript-language-server
npm install -g vscode-langservers-extracted  # HTML, CSS, JSON, ESLint servers

echo ""
echo "Setting up Python support..."
echo "----------------------------"

# Python provider for Neovim
python3 -m pip install --user --upgrade pynvim

echo ""
echo "Installing LaTeX rendering support..."
echo "-------------------------------------"

# Install pylatexenc for inline LaTeX rendering in markdown
pipx install pylatexenc
pipx ensurepath

echo ""
echo "Building Neovim plugin dependencies..."
echo "--------------------------------------"

# Build markdown-preview.nvim
MARKDOWN_PREVIEW_PATH="$HOME/.local/share/nvim/lazy/markdown-preview.nvim"
if [ -d "$MARKDOWN_PREVIEW_PATH" ]; then
    echo "Building markdown-preview.nvim..."
    cd "$MARKDOWN_PREVIEW_PATH/app" && yarn install
    echo "✓ markdown-preview.nvim built successfully"
else
    echo "⚠ markdown-preview.nvim not found - it will be installed when you first open Neovim"
fi

echo ""
echo "================================"
echo "Setup Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "1. Open Neovim: nvim"
echo "2. Lazy.nvim will automatically install all plugins"
echo "3. Wait for all plugins to install"
echo "4. Run :checkhealth to verify everything is working"
echo "5. Run :Mason to install additional LSP servers as needed"
echo ""
echo "If markdown-preview.nvim doesn't work after plugin installation:"
echo "  cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app && yarn install"
echo ""
