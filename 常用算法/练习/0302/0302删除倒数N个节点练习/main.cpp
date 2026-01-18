//
//  main.cpp
//  0302删除倒数N个节点练习
//
//  Created by chenlina on 2025/3/2.
//

#include <iostream>

struct ListNode {
    int val;
    ListNode *next;
    ListNode():val(0),next(nullptr){};
};

void delEndNthNode (ListNode *head, int n) {
    ListNode *dummy  = new ListNode();
    dummy->next = head;
    ListNode *left = dummy;
    ListNode *right = head;
    int i = 1;
    while (right->next) {
        right = right->next;
        i++;
        if (i > n) {
            left = left->next;
        }
    }
    left->next = left->next->next;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
