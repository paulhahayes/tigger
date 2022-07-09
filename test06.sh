#!/bin/dash

# ==============================================================================
# test06.sh
# Test tigger-branch errors
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
echo hello > A
$path/tigger-add A
$path/tigger-branch NEW > "$recived_output"
# check index show is working
cat > "$expected_output" <<EOF
tigger-branch: error: this command can not be run until after the first commit
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

$path/tigger-commit -m "Valid commit" >/dev/null
$path/tigger-branch .NEW > "$recived_output"
cat > "$expected_output" <<EOF
tigger-branch: error: invalid filename '.NEW'
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

$path/tigger-branch master > "$recived_output"
cat > "$expected_output" <<EOF
tigger-branch: error: branch 'master' already exists
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

$path/tigger-branch -d new > "$recived_output"
cat > "$expected_output" <<EOF
tigger-branch: error: branch 'new' doesn't exist
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi