//
//  main.cpp
//  二叉树非递归遍历
//
//  Created by chenlina on 2025/2/4.
//

#include <iostream>
#include <stack>

using namespace::std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(NULL), right(NULL) {}
};

//void preorderTer(TreeNode *root) {
//    if (root == nullptr) {
//        return;
//    }
//    stack<TreeNode *> stack;
//    stack.push(root);
//    while (!stack.empty()) {
//        TreeNode *node = stack.top();
//        stack.pop();
//        std::cout << node->val;
//        if (node->right) {
//            stack.push(node->right);
//        }
//        if (node->left) {
//            stack.push(node->left);
//        }
//        
//    }
//}

void tree(TreeNode *root) {
    if (root == nullptr){
        return;
    }
    stack<TreeNode*> stack;
    while (stack.empty()) {
        TreeNode *temp = stack.top();
        stack.pop();
        if (temp->right) {
            stack.push(temp->right);
        }
        if (temp->left) {
            stack.push(temp->left);
        }
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
