//
//  main.cpp
//  0321练习
//
//  Created by chenlina on 2025/3/21.
//



#include <iostream>
#include <queue>
#include <vector>
#include <stack>
using namespace::std;

struct TreeNode {
    TreeNode *left;
    TreeNode *right;
    TreeNode(): left(nullptr), right(nullptr){};
};

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val): val(val), next(nullptr){};
};

struct Compare {
    bool operator()(ListNode *a, ListNode *b) {
        return a->val > b->val;
    }
};


// 合并 K 个升序序列
void mergerKLists(vector<ListNode *> list) {
    priority_queue<ListNode*, vector<ListNode *>, Compare> queue;
    for (ListNode *node : list) {
        queue.push(node);
    }
    
    ListNode *dummy = new ListNode(0);
    ListNode *current = dummy;
    while (!queue.empty()) {
        ListNode *temp = queue.top();
        queue.pop();
        
        current->next = temp;
        current = current->next;
        
        if (temp->next) {
            queue.push(temp->next);
        }
    }
}

// 二叉树 公共父节点
TreeNode * treeFatherNode(TreeNode *head, TreeNode *a, TreeNode *b) {
    if (head == nullptr || head == a || head == b) {
        return head;
    }
    
    TreeNode *left = treeFatherNode(head->left, a, b);
    TreeNode *right = treeFatherNode(head->right, a, b);
    if (left != nullptr && right != nullptr) {
        return head;
    }
    
    return left == nullptr ? right : left;
}

// 两个链表xiangjiao
ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
    if (headA == nullptr || headB == nullptr) {
        return nullptr;
    }
    stack<ListNode *> sA;
    stack<ListNode *> sB;
    ListNode *res = nullptr;
    while (headA) {
        sA.push(headA);
        headA = headA->next;
    }
    
    while (headB) {
        sB.push(headB);
        headB = headB->next;
    }
    
    ListNode *topA = nullptr;
    ListNode *topB = nullptr;
    while (topA == topB && !sA.empty() && !sB.empty() ) {
        topA = sA.top();
        sA.pop();
        
        topB = sB.top();
        sB.pop();
        
        if (topA == topB) {
            res = topA;
        }
    }
    return res;
}

int main(int argc, const char * argv[]) {
    ListNode *l11 = new ListNode(1);
    ListNode *l12 = new ListNode(2);
    ListNode *l13 = new ListNode(3);
    l11->next = l12;
    l12->next = l13;
    
    
    ListNode *l21 = new ListNode(4);
    
    
    ListNode *l31 = new ListNode(5);
    ListNode *l32 = new ListNode(6);
    
    l21->next = l31;
    
    l13->next = l31;
    l31->next = l32;
    
    
    ListNode *res = getIntersectionNode(l11, l21);
    
    
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
