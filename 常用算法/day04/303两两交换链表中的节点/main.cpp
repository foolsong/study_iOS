//
//  main.cpp
//  两两交换链表中的节点
//
//  Created by yjsong on 2024/11/26.
//

#include <iostream>

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val):val(val){}
};

//ListNode* swapPairs(ListNode* head) {
//    if (!head || !head->next) {
//        return head;
//    }
//    ListNode *left = head;;
//    ListNode *right = head->next;
//    ListNode *res = right;
//
//    ListNode *curr = nullptr;
//
//    while (left && right) {
//        left->next = right->next;
//        right->next = left;
//        if (curr) {
//            curr->next = right;
//        }
//        curr = left;
//        left = left->next;
//        if (right->next && right->next->next && right->next->next->next) {
//            right = right->next->next->next;
//        } else {
//            right = nullptr;
//        }
//        
//    }
//    return res;
//}


ListNode* swapPairs(ListNode* head) {
    if (!head || !head->next) {
        return head;
    }
    ListNode *left = head;
    ListNode *right = head->next;
    ListNode *res = left;
    
    ListNode *curr = nullptr;
    
    while (left && right) {
        left->next = right->next;
        right->next = left;
        if (curr) {
            curr->next = right;
        }
        curr = left;
        left = left->next;
        if (right && right->next && right->next->next) {
            right = right->next->next->next;
        } else {
            right = nullptr;
        }
    }
    
    
    return res;
    
}


int main(int argc, const char * argv[]) {
    ListNode b = ListNode(2);
    ListNode c = ListNode(3);
    ListNode d = ListNode(4);
    ListNode e = ListNode(5);

    ListNode *h = new ListNode(1);
    h->next = &b;
    b.next = &c;
    c.next = &d;
    d.next = nullptr;
    
//    ListNode *t = swapPairs(h);
    
    
    
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
