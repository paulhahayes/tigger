#!/bin/dash
restart() {
rm -r -f .tigger
./tigger-init
./tigger-add temp.txt
}
