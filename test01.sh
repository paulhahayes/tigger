#!/bin/dash

# ==============================================================================
# test01.sh
# Test tigger-add and tigger-commit with bad file names and flags.
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


"$path"/tigger-init > "$recived_output" 2>&1


# test bad first character
echo "." > .DOTFILE
"$path"/tigger-add .DOTFILE > "$recived_output"
cat > "$expected_output" <<EOF
tigger-add: error: invalid filename '.DOTFILE'
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
# test invalid filename regex
echo '$1000' > '$$$$'
"$path"/tigger-add '$$$$' > "$recived_output"
cat > "$expected_output" <<EOF
tigger-add: error: invalid filename '\$\$\$\$'
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi


# test a bad commit name
touch valid.txt
"$path"/tigger-add valid.txt
"$path"/tigger-commit -m "-badmessage" > "$recived_output"

cat > "$expected_output" <<EOF
usage: girt-commit [-a] -m commit-message
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi


GREEN="\033[32m"
printf "test01 = ${GREEN}PASSED\n"