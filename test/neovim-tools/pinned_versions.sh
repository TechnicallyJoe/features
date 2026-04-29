#!/bin/bash
set -e

source dev-container-features-test-lib

check "neovim version" bash -c "nvim --version | grep -q 'v0.10.4'"
check "ripgrep version" bash -c "rg --version | grep -q '14.1.1'"
check "fzf version" bash -c "fzf --version | grep -q '0.62.0'"

reportResults
