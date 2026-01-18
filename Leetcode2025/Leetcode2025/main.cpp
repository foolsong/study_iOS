//
//  main.cpp
//  Leetcode2025
//
//  Created by yjsong on 2024/11/16.
//

#include <iostream>

struct ListNode {
     int val;
     ListNode *next;
     ListNode(int x) : val(x), next(NULL) {}
};

ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
    ListNode *a = headA;
    ListNode *b = headB;
    while (a != b) {
        a = a->next ? a->next : headB;
        b= b->next ? b->next : headA;
    }
    return a;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
