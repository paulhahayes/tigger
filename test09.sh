#!/bin/dash

# ==============================================================================
# test09.sh
# test merge error messages
# 
# Written by: Paul Hayes
# Structure copied from Comp2041 week 5 Tutorial - written by: Dylan Brotherston
# Date: 2022-07-04
# For COMP2041/9044 Assignment 1
# ==============================================================================

# Create a temporary directory for the test.
path=$PWD
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1 

# Create some files to hold output.

expected_output="$(mktemp)"
recived_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm * -rf "$test_dir"' INT HUP QUIT TERM EXIT

"$path"/tigger-init >/dev/null
echo "hello" > a
"$path"/tigger-add a 
"$path"/tigger-commit -m "MESSAGE" >/dev/null
"$path"/tigger-branch new >/dev/null
"$path"/tigger-checkout new >/dev/null

# no message
"$path"/tigger-merge 0 -m  > "$recived_output"
cat > "$expected_output" <<EOF
usage: tigger-merge <branch|commit> -m message
EOF
if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
# bad commit
"$path"/tigger-merge 1 -m "valid message" > "$recived_output"
cat > "$expected_output" <<EOF
tigger-merge: error: unknown commit '1'
EOF
if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi


# bad commit
"$path"/tigger-merge 'hello' -m "valid message" > "$recived_output"
cat > "$expected_output" <<EOF
tigger-merge: error: unknown branch 'hello'
EOF
if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
