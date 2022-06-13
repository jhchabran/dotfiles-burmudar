#!/bin/bash

ghpr() {
    gh pr -R sourcegraph/sourcegraph "$@" -A "@me"
}

ghpv() {
    gh pr -R sourcegraph/sourcegraph "$@"
}

iss() {
    gh issue -R sourcegraph/sourcegraph view $(gh issue -R sourcegraph/sourcegraph list -a "@me" | fzf | awk '{ print $1; }') "$@"
}
