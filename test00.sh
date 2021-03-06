#!/bin/dash

# ==============================================================================
# test00.sh
# Test tigger-commit for mutlple commits.
# 
# Written by: Paul Hayes
# Structure copied from Comp2041 week 5 Tutorial - written by: Dylan Brotherston
# Date: 2022-07-04
# For COMP2041/9044 Assignment 1
# ==============================================================================

# Create a temporary directory for the test.

test_dir="$(mktemp -d)"
cp -r * $test_dir 
cd "$test_dir" || exit 1 

# Create some files to hold output.

expected_output="$(mktemp)"
recived_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm * -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Create tigger repository

cat > "$expected_output" <<EOF
Initialized empty tigger repository in .tigger
EOF

tigger-init > "$recived_output" 2>&1

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

# Create a simple file.

echo "First" > a

# add a file to the repository staging area

tigger-add a

# commit the file 
tigger-commit -m "added a" > "$recived_output"

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

# Create a second file.

echo "Second" > b

# add a file to the repository staging area

tigger-add b

# commit the file 
tigger-commit -m "added b" > "$recived_output"

cat > "$expected_output" <<EOF
Committed as commit 1
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

# commit b again

tigger-commit -m "added b" > "$recived_output"

cat > "$expected_output" <<EOF
nothing to commit
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

# again with -a flag
tigger-commit -a -m "added b" > "$recived_output"

cat > "$expected_output" <<EOF
nothing to commit
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
GREEN="\033[32m"
printf "test00 = "${GREEN}"PASSED\n"