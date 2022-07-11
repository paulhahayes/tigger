#!/bin/dash

# ==============================================================================
# test07.sh
# test status and checkout
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
echo hello > A
"$path"/tigger-add A
"$path"/tigger-commit -m "Valid commit" >/dev/null
"$path"/tigger-branch new
echo 123 >> A
"$path"/tigger-checkout new >/dev/null
rm A
"$path"/tigger-checkout master >/dev/null
"$path"/tigger-status > "$recived_output"
cat > "$expected_output" <<EOF
A - file deleted
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

GREEN="\033[32m"
printf "test07 = ${GREEN}PASSED\n"