//
//  main.cpp
//  查找公共父节点
//
//  Created by chenlina on 2025/1/31.
//

#include <iostream>

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(NULL), right(NULL) {}
};

TreeNode* findLCA(TreeNode* root, TreeNode* p, TreeNode* q) {
    // 如果根为空或找到了p或q，返回根
    if (root == NULL || root == p || root == q) {
        return root;
    }

    // 查找左子树和右子树
    TreeNode* left = findLCA(root->left, p, q);
    TreeNode* right = findLCA(root->right, p, q);

    // 如果在左子树和右子树中分别找到了p和q，则root是LCA
    if (left != NULL && right != NULL) {
        return root;
    }

    // 否则，返回不为空的那一边（左子树或右子树）
    return left != NULL ? left : right;
}

TreeNode* findLCA2(TreeNode* root, TreeNode* p, TreeNode* q) {
    if (root == nullptr || root == p || root == q) {
        return root;
    }
    TreeNode* left = findLCA2(root->left, p, q);
    TreeNode *right = findLCA2(root->right, p, q);
    if (left != nullptr && right != nullptr) {
        return root;
    }
    return left != nullptr ? left : right;
}

int main() {
    // 创建二叉树
    TreeNode* root = new TreeNode(3);
    root->left = new TreeNode(5);
    root->right = new TreeNode(1);
    root->left->left = new TreeNode(6);
    root->left->right = new TreeNode(2);
    root->right->left = new TreeNode(0);
    root->right->right = new TreeNode(8);
    root->left->right->left = new TreeNode(7);
    root->left->right->right = new TreeNode(4);

    TreeNode* p = root->left;  // 节点 5
    TreeNode* q = root->left->right->right;  // 节点 4

    TreeNode* lca = findLCA(root, p, q);
    if (lca != NULL) {
        std::cout << "Lowest Common Ancestor: " << lca->val << std::endl;
    } else {
        std::cout << "No common ancestor found." << std::endl;
    }

    return 0;
}

