#!/bin/dash


if [ ! -d .tigger ];then 
    >&2 echo tigger-commit: error: tigger repository directory .tigger not found
fi

if  [ ! $# -eq 2 ] && [ ! $# -eq 3 ]; then
    >&2 echo usage: tigger-commit [-a] -m commit-message
    exit 1
fi

INDEX=$(wc -l < .tigger/.log )
BRANCH="$(find .tigger/branches/head/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
COMMIT="$(find ./.tigger/branches/head/"$BRANCH"/ -type f  -printf "%f\n" | sort -r | head -1)"
HEAD=."$BRANCH"."$COMMIT"
OLD=."$BRANCH".$((COMMIT-1))

#checks if there have been any adds
if [ ! -d .tigger/index/"$HEAD" ]; then 
    echo nothing to commit
    exit 1
fi 


if [ "$1" = "-m" ] && [ $# -eq 2 ]; then

    # check if a previous commit exists and if its the same
    if [ -d .tigger/commits/"$OLD" ]; then   
        if  diff .tigger/commits/"$OLD" .tigger/index/"$HEAD" >/dev/null; then
            echo nothing to commit
            exit 1
        fi
    fi
    MESSAGE="$2"
    echo "$COMMIT" "$MESSAGE" >> .tigger/.log
    echo "$INDEX" "$HEAD" "$MESSAGE" >> .tigger/.logDetail

    # adds changes
    mkdir .tigger/commits/."$BRANCH"."$COMMIT"
    for file in .tigger/index/"$HEAD"/*; do
        cp "$file" .tigger/commits/."$BRANCH"."$COMMIT"
    done



    # set up for the next index
    NEWINDEX=$((COMMIT+1)) 
    touch .tigger/branches/head/"$BRANCH"/$NEWINDEX

    #make a new index and copy the old files in
    mkdir -p .tigger/index/."$BRANCH".$NEWINDEX
    cp .tigger/index/"$HEAD"/* .tigger/index/."$BRANCH".$NEWINDEX

    echo Committed as commit "$COMMIT"
    

# commit all
elif [ "$1" = "-a" ] && [ "$2" = "-m" ] && [ ! -z "$3" ]; then
    MESSAGE="$3"

    # update files if they are in the index
    for file in .tigger/index/"$HEAD"/*; do
        fileCurrDir="$(basename "$file")"
        if [ -f "$fileCurrDir" ]; then
            ./tigger-add "$fileCurrDir" # on my local machine I need to write ./tigger-add
        fi
    done
    # recall the script but without the -a
    ./tigger-commit -m "$MESSAGE" # on my local machine I need to write ./tigger-commit


else 
    >&2 echo usage: tigger-commit [-a] -m commit-message
    exit 1
fi







# not used atm but checks if a dir is empty
    # find .tigger/index/$HEAD -empty -type d -exec command {} \;
