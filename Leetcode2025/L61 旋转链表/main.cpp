//
//  main.cpp
//  L61 旋转链表
//
//  Created by chenlina on 2025/2/2.
//

#include <iostream>

struct ListNode {
    int val;
    ListNode *next;
    ListNode():val(0),next(nullptr){};
    ListNode(int val):val(val),next(nullptr){};
    ListNode(int val, ListNode *next):val(val),next(next){};
};

ListNode* rotateRight(ListNode* head, int k) {
    if (k == 0 || head == nullptr || head->next == nullptr) {
        return head;
    }
    int n = 1;
    ListNode *tail = head;
    while (tail->next != nullptr) {
        tail = tail->next;
        n++;
    }
    int add = n - k % n;
    if (add == n) {
        return head;
    }
    tail->next = head;
    while (add--) {
        tail = tail->next;
    }
    ListNode *re = tail->next;
    tail->next = nullptr;
    return re;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
