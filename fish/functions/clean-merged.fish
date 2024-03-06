#!/usr/bin/env fish
git branch --merged | string match -v -r '^\*|master|main' | xargs -I {} git branch -d {}
