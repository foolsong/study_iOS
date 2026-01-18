//
//  main.cpp
//  L92反转链表
//
//  Created by chenlina on 2025/2/3.
//

#include <iostream>

struct ListNode {
    int val;
    ListNode *next;
    ListNode():val(0),next(nullptr){};
    ListNode(int val):val(val),next(nullptr){};
};

ListNode* reverseBetween(ListNode* head, int left, int right) {
    ListNode *dummyNode = new ListNode(-1);
    dummyNode->next = head;
    ListNode *pre = dummyNode;
    
    for (int i = 0 ; i < left - 1; i++) {
        pre = pre->next;
    }
    ListNode *curr = pre->next;
    ListNode *next;
    for (int j = 0; j < right - left; j++) {
        next = curr->next;
        curr->next = next->next;
        next->next = pre->next;
        pre->next = next;
    }
    return dummyNode->next;
}



int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
