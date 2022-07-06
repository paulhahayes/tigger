#!/bin/dash

if [ $# -lt 1 ]; then
    >&2 echo "usage: tigger-add <filenames>"
fi

if  [ ! -d .tigger ];then
    >&2 echo "tigger-add: error: tigger repository directory .tigger not found" # stder
    exit 1
fi


for file in "$@"
do
# check file name
if ! echo "$file" | grep -Ei '^[a-z0-9._-]*$' > /dev/null; then 
    >&2 echo tigger-add: error: invalid filename "$file"
    exit 1
fi

#check file exists
if [ ! -f "$file" ]; then
    >&2 echo tigger-add: error: can not open "'$file'"
    exit
fi

# Verbose but safe way of getting the branch name of the current head 
# could this be store as a env variable
BRANCH="$(find .tigger/branches/head/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
COMMIT="$(find ./.tigger/branches/head/"$BRANCH"/ -type f  -printf "%f\n" | sort -r | head -1)"
INDEXNAME=."$BRANCH"."$COMMIT"

# check if the index exists
if [ ! -d .tigger/index/"$INDEXNAME" ]; then
    mkdir -p .tigger/index/"$INDEXNAME"
fi
cp "$file" .tigger/index/"$INDEXNAME"

done

