#!/bin/dash


if [ ! -d .tigger ];then 
    >&2 echo tigger-commit: error: tigger repository directory .tigger not found
fi

if  [ ! $# -eq 2 ] && [ ! $# -eq 3 ]; then
    >&2 echo usage: tigger-commit [-a] -m commit-message
    exit 1
fi

COMMITINDEX=$(wc -l < .tigger/.log )
CURRENTCOMMIT=$((COMMITINDEX-1))
BRANCH="$(find .tigger/branches/.head/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
BRANCHINDEX="$(find ./.tigger/branches/.head/"$BRANCH"/ -type f  -printf "%f\n" | sort -r | head -1)"
HEAD=."$BRANCH"."$BRANCHINDEX"


#checks if there have been any adds
if [ ! -d .tigger/index/"$HEAD" ]; then 
    echo nothing to commit
    exit 1
fi 


if [ "$1" = "-m" ] && [ $# -eq 2 ]; then

    # check if a previous commit exists and if its the same
    if [ -d .tigger/commits/"$CURRENTCOMMIT" ]; then
           
        if  diff .tigger/commits/"$CURRENTCOMMIT" .tigger/index/"$HEAD" >/dev/null; then
            >&2 echo nothing to commit
            exit 1
        fi
    fi
    MESSAGE="$2"

    if echo "$MESSAGE" | grep -E '^-' >/dev/null; then
        1>&2 echo "usage: girt-commit [-a] -m commit-message"
        exit 1
    fi


    echo "$COMMITINDEX" "$MESSAGE" >> .tigger/.log
    echo "$COMMITINDEX" "$HEAD" "$MESSAGE" >> .tigger/.logDetail

    # adds changes

    mkdir .tigger/commits/$COMMITINDEX/

    if find .tigger/index/"$HEAD"  -maxdepth 0  -empty | ifne false; then
        for file in .tigger/index/"$HEAD"/*; do
            cp -r "$file" .tigger/commits/$COMMITINDEX >/dev/null
        done
    fi


    # set up for the next index
    NEWINDEX=$((BRANCHINDEX+1)) 
    touch .tigger/branches/.head/"$BRANCH"/$NEWINDEX

    #make a new index and copy the COMMITINDEX files in
    mkdir -p .tigger/index/."$BRANCH".$NEWINDEX
    if find .tigger/index/"$HEAD"  -maxdepth 0  -empty | ifne false; then
        cp -r .tigger/index/"$HEAD"/* .tigger/index/."$BRANCH".$NEWINDEX >/dev/null
    
    fi

    echo Committed as commit "$COMMITINDEX"
    # update the current branch
    cp -r .tigger/commits/$CURRENTCOMMIT/* .tigger/branches/"$BRANCH" 2>/dev/null
    echo "$CURRENTCOMMIT" > .tigger/branches/"$BRANCH"/.commitindex
    echo "$BRANCHINDEX" > .tigger/branches/"$BRANCH"/.branchindex

# commit all
elif [ "$1" = "-a" ] && [ "$2" = "-m" ] && [ ! -z "$3" ]; then
    MESSAGE="$3"
    
    # update files if they are in the index
    for file in .tigger/index/"$HEAD"/*; do
        fileCurrDir="$(basename "$file")"
        if [ -f "$fileCurrDir" ]; then
            tigger-add "$fileCurrDir"
        fi
    done
    # recall the script but without the -a
    tigger-commit -m "$MESSAGE" 


else 
    >&2 echo usage: tigger-commit [-a] -m commit-message
    exit 1
fi



