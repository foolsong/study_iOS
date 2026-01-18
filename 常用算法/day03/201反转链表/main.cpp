//
//  main.cpp
//  反转链表
//
//  Created by yjsong on 2024/11/25.
//

#include <iostream>

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x):val(x),next(nullptr){}
    
    ListNode(int x, ListNode *next):val(x),next(next){}
};

//ListNode* reverseList2(ListNode* head) {
//    ListNode *prev = nullptr;
//    ListNode *curr = head;
//    while (curr) {
//        ListNode *next = curr->next;
//        curr->next = prev;
//        prev = curr;
//        curr = next;
//    }
//    return prev;
//}
//
//ListNode* reverseList(ListNode* head) {
//    if (!head || !head->next) {
//        return head;
//    }
//    ListNode *newHead = reverseList(head->next);
//    
//    head->next->next =  head;
//    head->next = nullptr;
//    return newHead;
//}

ListNode* reverseList(ListNode* head) {
    ListNode *res = nullptr;
    ListNode *curr = head;
    while (curr) {
        ListNode *next = curr->next;
        curr->next = res;
        res = curr;
        curr = next;
    }
    return res;
}

ListNode *reverseList2(ListNode *head) {
    if (head->next == nullptr || head == nullptr) {
        return head;
    }
    
    ListNode *newHead = reverseList2(head->next);
    head->next->next = head;
    head->next = nullptr;
    return newHead;
}

ListNode* reverseList3(ListNode* head) {
    ListNode *curr = head;
    ListNode *pre = nullptr;
    while (curr != nullptr) {
        ListNode *temp =  curr->next;
        curr->next = pre;
        pre = curr;
        curr = temp;
    }
    return pre;
}

// 打印链表
void printList(ListNode* head) {
    ListNode* temp = head;
    while (temp != nullptr) {
        std::cout << temp->val << " ";
        temp = temp->next;
    }
    std::cout << std::endl;
}

int main(int argc, const char * argv[]) {
    // 创建链表 1 -> 2 -> 3 -> 4 -> 5
        ListNode* head = new ListNode(1);
        head->next = new ListNode(2);
        head->next->next = new ListNode(3);
        head->next->next->next = new ListNode(4);
        head->next->next->next->next = new ListNode(5);
        
        std::cout << "Original List: ";
        printList(head);
        
        // 反转链表
        head = reverseList3(head);
        
    std::cout << "Reversed List: ";
        printList(head);
    return 0;
}
