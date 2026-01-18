//
//  main.cpp
//  删除链表的倒数第 N 个结点
//
//  Created by yjsong on 2024/11/25.
//

#include <iostream>
//struct ListNode {
//    int val;
//    ListNode *next;
//    ListNode(int x):val(x),next(nullptr){}
//    
//    ListNode(int x, ListNode *next):val(x),next(next){}
//    };
//
//
//ListNode* removeNthFromEnd(ListNode* head, int n) {
//    ListNode *dummy = new ListNode(0, head);
//    ListNode* left = dummy;
//    ListNode* right = head;
//    
//    int index = 1;
//    while (right->next) {
//        right = right->next;
//        index ++;
//        if (index > n) {
//            left = left->next;
//        }
//    }
//    left->next = left->next->next;
//    return dummy->next;
//}

struct ListNode{
    int val;
    ListNode *next;
    ListNode():val(0),next(nullptr){}
    ListNode(int val):val(val),next(nullptr){}
};

void removeNthFromEnd(ListNode *head, int n) {
    ListNode *dummy = new ListNode(0);
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
//    ListNode *a = ListNode(1);
    ListNode b = ListNode(2);
//    ListNode *c = ListNode(3);
//    ListNode *d = ListNode(4);
//    ListNode *e = ListNode(5);
//    a->next
    ListNode h = ListNode(1);
    h.next = &b;
    
    removeNthFromEnd(&h, 2);
    std::cout << "Hello, World!\n";
    return 0;
}
