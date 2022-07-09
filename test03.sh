#!/bin/dash

# ==============================================================================
# test03.sh
# Test tigger-add test error checking occurs before any action
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


$path/tigger-init >/dev/null
touch > A B C D E
# add an extra file F 
$path/tigger-add A B C D E F > "$recived_output"

cat > "$expected_output" <<EOF
tigger-add: error: can not open 'F'
EOF
if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
# check the folder has not added any of the files
$path/tigger-status > "$recived_output"
cat > "$expected_output" <<EOF
A - untracked
B - untracked
C - untracked
D - untracked
E - untracked
EOF
if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
GREEN="\033[32m"
printf "test03 = ${GREEN}PASSED\n"