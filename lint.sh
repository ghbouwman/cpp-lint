#!/usr/bin/env bash

set -euo pipefail
status=0

bear -- make -B -j 8
jq -r '.[].file' compile_commands.json > file-list.txt

while IFS= read -r file; do
        clang-format --style=file "$file" | diff -u --color=always "$file" - || status=1
        clang-tidy --quiet -p=. "$file" || status=1
done < file-list.txt

exit "$status"

