#!/bin/bash
set -e

source dev-container-features-test-lib

check "motf version" bash -c "motf --version | grep -q '0.8.1'"

reportResults
