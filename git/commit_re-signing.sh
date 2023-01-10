#!/bin/bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

git branch re-signing

git checkout re-signing

git filter-branch --commit-filter '
EMAIL="<email>"
if [ "$GIT_COMMITTER_EMAIL" = "$EMAIL" ]; then
    git commit-tree "$@" -S
else
    git commit-tree "$@"
fi' HEAD

#git push --force origin re-signing

git checkout "$current_branch"
