#!/bin/dash

if [ -e .tigger ]; then
    for file in $@
    do
    # check file name
    if echo $file | grep -Ei '^[a-z0-9._-]*$' > /dev/null; then 
        echo hello
    else 
        continue
    fi

    if [ ! -f "$file" ]; then
        echo doesnt exist
    fi
    #check file exists
    done
    #metadata
else 
    exit 1

fi