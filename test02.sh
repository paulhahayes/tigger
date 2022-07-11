#!/bin/dash

# ==============================================================================
# test02.sh
# Test tigger-show changes.
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


"$path"/tigger-init > "$recived_output" >/dev/null
echo hello > A
"$path"/tigger-add A
"$path"/tigger-show :A > "$recived_output"
# check index show is working
cat > "$expected_output" <<EOF
hello
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi
"$path"/tigger-commit -m "commited" >/dev/null

# test file is still accessible
"$path"/tigger-show :A > "$recived_output"
cat > "$expected_output" <<EOF
hello
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

# test still working after a commit
"$path"/tigger-show 0:A > "$recived_output"
cat > "$expected_output" <<EOF
hello
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

# alter the file
echo world >> A
"$path"/tigger-add A
"$path"/tigger-show :A > "$recived_output"
cat > "$expected_output" <<EOF
hello
world
EOF

if ! diff "$expected_output" "$recived_output"; then
    echo "Failed test"
    exit 1
fi

GREEN="\033[32m"
printf "test02 = ${GREEN}PASSED\n"

