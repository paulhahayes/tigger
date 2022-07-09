
2041 tigger-init
echo "hello" >a
echo "hello:" >b
2041 tigger-add a b
2041 tigger-commit -m a0
2041 tigger-branch a
2041 tigger-checkout a
echo "!" >>a
echo "!" >>b
2041 tigger-add a b
2041 tigger-commit -m a1
echo "hey" >>a
echo "hi" >>b
# 2041 tigger-add b
# rm b
2041 tigger-checkout master

#"girt-checkout: error: Your changes to the following files would be overwritten by checkout:
