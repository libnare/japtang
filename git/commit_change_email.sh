#!/bin/bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

git branch change-email

git checkout change-email

git filter-branch --commit-filter '
OLD_EMAIL="<old>"
NEW_EMAIL="<new>"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]; then
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]; then
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
    git commit-tree "$@" -S
else
    git commit-tree "$@"
fi' HEAD

#git push --force origin change-email

git checkout "$current_branch"
