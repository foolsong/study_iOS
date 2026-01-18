//
//  main.cpp
//  L114二叉树展开为链表
//
//  Created by chenlina on 2025/2/4.
//

#include <iostream>
#include <vector>

using namespace::std;

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
};

void getTreeNode(TreeNode *root, vector<TreeNode *> &l) {
    if (root != nullptr) {
        l.push_back(root);
        getTreeNode(root->right, l);
        getTreeNode(root->left, l);
    }
}

void flatten(TreeNode* root) {
    vector<TreeNode *> list;
    getTreeNode(root, list);
    long size = list.size();
    for (int i = 1; i < size; i++) {
        TreeNode *pre = list.at(i - 1), *curr = list.at(i);
        pre->left = nullptr;
        pre->right = curr;
    }
}



int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
