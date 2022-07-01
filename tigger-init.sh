#!/bin/dash

if [ -d .tigger ]; then
    echo "tigger-init: error: .tigger already exists"
    exit 1
else
    mkdir -p .tigger/index
    echo "Initialized empty tigger repository in .tigger"
fi
