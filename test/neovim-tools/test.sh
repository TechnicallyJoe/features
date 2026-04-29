#!/bin/bash
set -e

source dev-container-features-test-lib

check "neovim is installed" bash -c "nvim --version | head -1"
check "ripgrep is installed" bash -c "rg --version | head -1"
check "fzf is installed" bash -c "fzf --version"

reportResults
