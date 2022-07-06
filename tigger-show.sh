#!/bin/dash

if  [ ! -d .tigger ];then
    >&2 echo "tigger-show: error: tigger repository directory .tigger not found" # stder
    exit 1
fi


if [ $# != 1 ];then
    >&2 echo "usage: tigger-show <commit>:<filename>"
    exit 1
fi

if ! echo "$1" | grep -Eq '^([^:]*:[^:]*)$';then 
    echo tigger-show: error: invalid object "$1"
    exit 1
fi


COMMIT="$(echo "$1" | cut -d ":" -f1)"
FILENAME="$(echo "$1" | cut -d ":" -f2)"

#use index
if [ -z "$COMMIT" ]; then
    BRANCH="$(find .tigger/branches/head/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
    COMMIT="$(find ./.tigger/branches/head/"$BRANCH"/ -type f  -printf "%f\n" | sort -r | head -1)"
    INDEXNAME=."$BRANCH"."$COMMIT"

    if [ ! -f .tigger/index/"$INDEXNAME"/"$FILENAME" ]; then
        >&2 echo tigger-show: error: "'$FILENAME'" not found in index
        exit 1

    else 
        cat .tigger/index/"$INDEXNAME"/"$FILENAME"
    fi

#use commit
else
    
    BRANCH="$(cut -d' ' -f1,2 .tigger/.logDetail | grep -E "^${COMMIT} " 2> /dev/null | cut -d' ' -f2 )"
    if [ -n "$BRANCH" ]; then 
        if [ ! -f .tigger/index/"$BRANCH"/"$FILENAME" ]; then
           >&2 echo tigger-show: error: "'$FILENAME'" not found in commit "$COMMIT"
            exit
        else
            cat .tigger/index/"$BRANCH"/"$FILENAME"
        fi
    else 
       >&2 echo tigger-show: error: unknown commit "'$COMMIT'"
    fi 
    exit
    
fi


# if ! INDEX="$(echo $1 | cut -d':' -f1 2> /dev/null)";then 
#     echo bad input
#     exit 1
# fi

