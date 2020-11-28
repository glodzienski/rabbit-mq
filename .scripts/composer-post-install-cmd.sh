#!/usr/bin/env bash

DIR="$PWD/.git/hooks/"
if [ -d "$DIR" ]; then
    cp .scripts/pre-commit.sh .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
fi
