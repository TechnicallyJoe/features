#!/bin/bash
set -e

source dev-container-features-test-lib

check "motf is installed" bash -c "motf --version | head -1"

reportResults
