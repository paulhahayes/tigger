#!/bin/dash

if [ $# -lt 1 ]; then
    >&2 echo "usage: tigger-add <filenames>"
fi

if  [ ! -d .tigger ];then
    >&2 echo "tigger-add: error: tigger repository directory .tigger not found" # stder
    exit 1
fi


# Verbose but safe way of getting the branch name of the current head 
BRANCH="$(find .tigger/branches/.head/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
BRANCHINDEX="$(find ./.tigger/branches/.head/"$BRANCH"/ -type f  -printf "%f\n" | sort -r | head -1)"
HEAD=."$BRANCH"."$BRANCHINDEX"


# error checking loop first
for file in "$@"; do

    # check filename characters
    if ! echo "$file" | grep -Ei '^[a-z0-9_.-]*$' > /dev/null; then 
        >&2 echo "tigger-add: error: invalid filename '$file'"
        exit 1
    fi

    #check file exists
    if [ ! -f "$file" ] && [ ! -f .tigger/index/"$HEAD"/"$file" ]; then
        >&2 echo "tigger-add: error: can not open '$file'"
        exit
    fi
done

# implmentation loop
for file in "$@"; do

    # check if the index exists
    if [ ! -d .tigger/index/"$HEAD" ]; then
        mkdir -p .tigger/index/"$HEAD"
    fi

    # Either add or remove the file from the index
    if [ -f $file ]; then 
        cp "$file" .tigger/index/"$HEAD"
    else 
        rm -f .tigger/index/"$HEAD"/"$file"
    fi

done

