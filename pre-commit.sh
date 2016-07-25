#!/bin/bash

# pre-commit.sh
git stash -q --keep-index

commit () {
  git stash pop -q
  exit 0
}

abort () {
  echo "ABORTING:  Make sure you have linted and beautified the code." >&2
  git checkout .
  git stash pop -q
  exit 1
}

# Test prospective commit
cd app
npm run-script lint || abort
BEFORE=$(git status)
npm run-script beautify || abort
AFTER=$(git status)
[ "$BEFORE" == "$AFTER" ] || abort
cd -

commit
