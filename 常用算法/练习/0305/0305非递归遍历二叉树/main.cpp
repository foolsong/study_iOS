//
//  main.cpp
//  0305非递归遍历二叉树
//
//  Created by chenlina on 2025/3/5.
//

#include <iostream>
#include <stack>


using namespace::std;

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode():val(0),left(nullptr),right(nullptr){};
};

void tree(TreeNode *node) {
    stack<TreeNode *> st;
    st.push(node);
    while (!st.empty()) {
        TreeNode *tree = st.top();
        st.pop();
        if (tree->left) {
            st.push(tree->left);
        }
        if (tree->right) {
            st.push(tree->right);
        }
    }
}

int lengthOfSubString(string s) {
    unordered_map<char, int> map;
    long lenght = s.length();
    int maxLenght = 0;
    int tempLenght = 0;
    int startIndex = 0;
    for (int i = 0; i < lenght; i++) {
        char c = s[i];
        if (map.contains(c)) {
            int index = map[c];
            maxLenght = maxLenght > tempLenght ? maxLenght : tempLenght;
            tempLenght = i - index;
            startIndex =  i + 1;
            for (int j = startIndex; j <= index; j++) {
                map.erase(s[j]);
            }
        } else {
            tempLenght++;
        }
        map[c] = i;
    }
    
    return maxLenght > tempLenght ? maxLenght : tempLenght;
}



int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
