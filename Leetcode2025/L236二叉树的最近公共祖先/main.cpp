//
//  main.cpp
//  L236二叉树的最近公共祖先
//
//  Created by yjsong on 2024/11/18.
//

/**
 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。
 */

#include <iostream>
#include <vector>
#include <stack>

using namespace std;

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x),left(NULL),right(NULL){}
};

void treeList(TreeNode *node) {
    if (node == NULL) {
        return;
    }
    std::cout << " " << node->val ;
    treeList(node->left);
    treeList(node->right);
}

void dfs_s(TreeNode *root, TreeNode *searchNode, vector<TreeNode *> &stack,vector<TreeNode *> &path ) {
    if (root == NULL) {
        return;
    }
    stack.push_back(root);
    if (root == searchNode) {
        path = stack;
        return;
    }
    dfs_s(root->left, searchNode, stack, path);
    dfs_s(root->right, searchNode, stack, path);
    stack.pop_back();
}

TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
    vector<TreeNode *> stack;
    vector<TreeNode *> pPath;
    vector<TreeNode *> qPath;
    dfs_s(root, p, stack, pPath);
    stack.clear();
    dfs_s(root, q, stack, qPath);
    
    int i = 0;
    struct TreeNode *common = nullptr;
    while (i < pPath.size() && i < qPath.size()) {
        if (pPath[i] == qPath[i]) {
            common = pPath[i];
        }
        i++;
    }
    
    return common;
}


int main(int argc, const char * argv[]) {
    
    TreeNode a(3),b(5),c(1),d(6),e(2),f(0),g(8),h(7),i(4);
    a.left= &b;
    a.right= &c;
    b.left = &d;
    b.right= &e;
    c.left = &f;
    c.right= &g;
    e.left = &h;
    e.right= &i;
    
    treeList(&a);

    lowestCommonAncestor(&a, &d, &h);
    
    // insert code here...
    return 0;
}
