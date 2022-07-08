#!/bin/dash

# check if a Repo already exists
if [ -d .tigger ]; then
    echo "tigger-init: error: .tigger already exists"
    exit 1
fi

# raise error if the .git folder exists
if [ -d .git ]; then
    >&2 echo tigger-init: error: can not run tigger because .git present in current directory
    exit 1
fi

# create a .tigger directory
mkdir .tigger

# create a index directory for hosting changes
mkdir .tigger/index

# create a branches directory and by default make master
mkdir -p .tigger/branches/master

# create a 'head' branch which is the active branch and add a version number
mkdir -p .tigger/branches/.head/master && touch .tigger/branches/.head/master/0

# create a directory for commits
mkdir .tigger/commits

# create a log to document changes
touch .tigger/.log

echo "Initialized empty tigger repository in .tigger"

