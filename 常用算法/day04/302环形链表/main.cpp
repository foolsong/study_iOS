//
//  main.cpp
//  环形链表
//
//  Created by yjsong on 2024/11/26.
//

#include <iostream>

//struct ListNode {
//    int val;
//    ListNode *next;
//    ListNode(int val):val(val){}
//};

//bool hasCycle(ListNode *head) {
//    if (!head || !head->next) {
//        return false;
//    }
//    ListNode *p = head;
//    ListNode *q = head->next;
//    while (p != q &&  q!= nullptr) {
//        if (p->next == nullptr || q->next->next ==nullptr) {
//            return false;
//        }
//        p = p->next;
//        q = q->next->next;
//    }
//    return true;
//}

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val): val(val){}
};

bool hasCycle(ListNode *head) {
    if (!head || head->next) {
        return false;
    }
    ListNode *s = head;
    ListNode *q = head->next;
    while (s != q || q != nullptr) {
        if (q->next->next == nullptr || s->next == nullptr) {
            return false;
        }
        s = s->next;
        q = q->next->next;
    }
    return true;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
