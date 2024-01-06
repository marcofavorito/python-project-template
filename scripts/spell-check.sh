#!/bin/bash
# This script requires `mdspell`:
#
#    https://www.npmjs.com/package/markdown-spellcheck
#
# Run this script from the root directory.
# Usage:
#   ./scripts/spell-check.sh
#

MDSPELL_PATH="$(which mdspell)"
if [ -z "${MDSPELL_PATH}" ]; then
  echo "Cannot find executable 'mdspell'. Please install it to run this script: npm i markdown-spellcheck -g"
  exit 127
fi

echo "Found 'mdspell' executable at ${MDSPELL_PATH}"

only_check_option="$1"

if [ "$only_check_option" == "" ]; then
  mdspell -n -a --en-gb '**/*.md' '!docs/api/**/*.md'
elif [ "$only_check_option" == "--only-check" ]; then
  mdspell -n -a --en-gb '**/*.md' '!docs/api/**/*.md' --report
else
  echo "Usage: ./spell-check.sh [--only-check]"
fi
