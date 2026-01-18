//
//  main.cpp
//  142. 环形链表 II
//
//  Created by yjsong on 2024/11/26.
//

#include <iostream>

//struct ListNode {
//    int val;
//    ListNode *next;
//    ListNode(int val):val(val){}
//};

//ListNode *detectCycle(ListNode *head) {
//    if (!head || !head->next) {
//        return nullptr;
//    }
//    ListNode *s = head;
//    ListNode *f = head;
//    while (f != nullptr) {
//        if (s->next == nullptr || f->next == nullptr) {
//            return nullptr;
//        }
//        s = s->next;
//        f = f->next->next;
//        if (s == f) {
//            ListNode *p = head;
//            while (p != s) {
//                p = p->next;
//                s = s->next;
//            }
//            return p;
//        }
//    }
//    return nullptr;
//}

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val) : val(val){};
};

ListNode *detectCycle(ListNode *head) {
    if (!head && !head->next) {
        return nullptr;
    }
    ListNode *quick = head;
    ListNode *slow = head;
    while (quick != nullptr) {
        if (quick->next == nullptr || slow->next == nullptr) {
            return nullptr;
        }
        quick = quick->next->next;
        slow = slow->next;
        if (quick == slow) {
            ListNode *temp = head;
            while (temp != quick) {
                temp = temp->next;
                quick = quick->next;
            }
            return temp;
        }
    }
    return nullptr;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
