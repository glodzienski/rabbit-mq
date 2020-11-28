#!/usr/bin/env bash

# shellcheck disable=SC1090
. "${PWD}/.scripts/utils.sh"

# Based on code from http://tech.zumba.com/2014/04/14/control-code-quality/

PROJECT=$PWD
STAGED_FILES_CMD=$(git diff --name-only --diff-filter=ACMR HEAD | grep \\.php)

# Determine if a file list is passed
if [ "$#" -eq 1 ]; then
    oIFS=$IFS
    IFS='
    '
    FILES="$1"
    IFS=$oIFS
fi
FILES=${FILES:-$STAGED_FILES_CMD}

log "Checking PHP errors..."
for FILE in $FILES; do
    log "Checking PHP errors for $PROJECT/$FILE"
    php -l -d display_errors=0 "$PROJECT"/"$FILE"
    # shellcheck disable=SC2181
    if [ $? != 0 ]; then
        log "Fix the error before commit."
        exit 1
    fi
    FILES_TO_LINT="$FILES_TO_LINT $PROJECT/$FILE"
done

if [ "$FILES" != "" ]; then
    log "Running Code Sniffer for ${FILES_TO_LINT}"
    # shellcheck disable=SC2086
    ./vendor/bin/phpcbf --standard=PSR12 --encoding=utf-8 -p --colors --report=code ${FILES_TO_LINT}
fi

exit $?
