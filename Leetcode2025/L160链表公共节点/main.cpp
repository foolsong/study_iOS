//
//  main.cpp
//  L160链表公共节点
//
//  Created by yjsong on 2024/11/16.
//

#include <iostream>

struct ListNode {
     int val;
     ListNode *next;
     ListNode(int x) : val(x), next(NULL) {}
};

int listLength(ListNode * node) {
    int length = 0;
    ListNode *nodetemp = node;
    while (nodetemp->next) {
        nodetemp = nodetemp->next;
        length++;
    }
    return length;
}

ListNode *removeHeaderToIndex(ListNode * node, int count) {
    for (int i = 0; i < count; i++) {
        node = node->next;
    }
    return node;
}

ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
    int aL = listLength(headA);
    int bL = listLength(headB);
    if (aL > bL) {
        headA = removeHeaderToIndex(headA, aL - bL);
    } else {
        headB = removeHeaderToIndex(headB, bL - aL);
    }
    while (headA && headB) {
        if (headA == headB) {
            return headA;
        }
        headA = headA->next;
        headB = headB->next;
    }
    return nullptr;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}



/**
 
 ListNode* getIntersectionNode(ListNode* headA, ListNode* headB) {
         ListNode* a = headA;
         ListNode* b = headB;
         while (a != b) {
             a = a ? a->next : headB;
             b = b ? b->next : headA;
         }
         return a;
     }
 
 
 */
