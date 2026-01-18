//
//  main.cpp
//  L2两数相加
//
//  Created by chenlina on 2025/2/2.
//

#include <iostream>

struct ListNode {
    int val;
    ListNode *next;
    ListNode():val(0), next(nullptr){};
    ListNode(int val):val(val), next(nullptr){};
    ListNode(int val, ListNode *next): val(val), next(next){};
};

ListNode* addTwoNumber(ListNode *l1, ListNode *l2) {
    ListNode *header = nullptr, *tail = nullptr;
    int carry = 0;
    while (l1 || l2) {
        int n1 = l1 ? l1->val : 0;
        int n2 = l2 ? l2->val : 0;
        
        int sum = n1 + n2 + carry;
        
        if (!header) {
            header = tail = new ListNode(sum % 10);
        } else {
            tail->next = new ListNode(sum % 10);
            tail = tail->next;
        }
        carry = sum / 10;
        
        if (l1) {
            l1 = l1->next;
        }
        if (l2) {
            l2 = l2->next;
        }
    }
    
    if (carry > 0) {
        tail->next = new ListNode(carry);
    }
    
    return header;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
