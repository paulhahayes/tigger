#!/bin/dash
basic() {
rm -r -f .tigger
./tigger-init
./tigger-add temp.txt
}

#!/bin/dash
restart() {
rm -r -f .tigger
./tigger-init
echo 1 >a
echo 2 >b
echo 3 >c
./tigger-add a b c
./tigger-commit -m hello
./tigger-rm a b d
./tigger-commit -m hello1
}

#!/bin/dash
2restart() {
rm -r -f .tigger
./tigger-init
touch temp.txt
./tigger-add temp.txt
./tigger-commit -m first
echo chagnes >> temp.txt
./tigger-add temp.txt
./tigger-rm temp.txt
# 2041 tigger-add temp.txt
}

3restart() {
rm -r -f .tigger
2041 tigger-init
echo 1 >a
2041 tigger-add a
2041 tigger-commit -m hello
rm a
2041 tigger-add a
2041 tigger-status
}


4restart() {
rm -r -f .tigger
./tigger-init
touch a b c
./tigger-add a b c
./tigger-commit -m hello
touch d e f
./tigger-add d e f
./tigger-branch new
./tigger-checkout new
}

#!/bin/dash
re() {
rm -r -f .tigger
./tigger-init
touch temp.txt
./tigger-add temp.txt
./tigger-commit -m first
./tigger-branch new
./tigger-checkout new
touch third.txt
./tigger-add third.txt
./tigger-commit -m second
./tigger-checkout master
}


ch() {
    rm -r -f .tigger
./tigger-init
touch a
./tigger-add a
./tigger-commit -m commit-0
./tigger-branch b1
./tigger-checkout b1
touch b
./tigger-add b
./tigger-commit -m commit-1
./tigger-checkout master
./tigger-branch b2
./tigger-checkout b2

}

change () {
rm -r -f .tigger
./tigger-init
echo hello >a
./tigger-add a
./tigger-commit -m commit-A
./tigger-branch b1
echo world >>a
./tigger-checkout b1
./tigger-checkout master
./tigger-add a
./tigger-checkout b1
./tigger-checkout master
./tigger-commit -a -m commit-B
./tigger-checkout b1
./tigger-checkout master
}