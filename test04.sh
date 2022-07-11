#!/bin/dash

# ==============================================================================
# test04.sh
# Test tigger-rm bad flags
# 
# Written by: Paul Hayes
# Structure copied from Comp2041 week 5 Tutorial - written by: Dylan Brotherston
# Date: 2022-07-04
# For COMP2041/9044 Assignment 1
# ==============================================================================

# Create a temporary directory for the test.

test_dir="$(mktemp -d)"
path=$PWD
cd "$test_dir" || exit 1 

# Create some files to hold output.

expected_output="$(mktemp)"
recived_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm * -rf "$test_dir"' INT HUP QUIT TERM EXIT

"
$path"/tigger-init > "$recived_output" >/dev/null
echo hello > A"
$path"/tigger-add A"
$path"/tigger-commit -m "FIRST" >/dev/null
"
$path"/tigger-rm --cached --force name --cached > "$recived_output"
cat > "$expected_output" <<EOF
usage: tigger-rm [--force] [--cached] <filenames>
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
"
$path"/tigger-rm --cached --force name -invalidname > "$recived_output"
cat > "$expected_output" <<EOF
usage: tigger-rm [--force] [--cached] <filenames>
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

GREEN="\033[32m"
printf "test04 = ${GREEN}PASSED\n"