#!/bin/dash

# ==============================================================================
# test08.sh
# Test tigger-checkout basics
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
echo "world" >> a
"$path"/tigger-add a
"$path"/tigger-commit -m "MESSAGE" >/dev/null
echo "!" >> a

"$path"/tigger-checkout master > "$recived_output"
cat > "$expected_output" <<EOF
tigger-checkout: error: Your changes to the following files would be overwritten by checkout:
a
EOF
if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
GREEN="\033[32m"
printf "test08 = "${GREEN}"PASSED\n"

