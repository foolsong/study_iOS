//
//  main.cpp
//  N有序链表合并
//
//  Created by yjsong on 2025/1/23.
//

#include <iostream>
#include <queue>
#include <vector>
//#include <functional>

using namespace::std;
struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val) : val(val), next(nullptr){}
};

struct Compare {
    bool operator()(ListNode *a, ListNode *b) {
        return a->val > b->val;
    }
};

ListNode* mergeKLists(vector<ListNode*> & lists) {
    priority_queue<ListNode *, vector<ListNode *>, Compare> pq;
    for (auto list : lists) {
        if (list != nullptr) {
            pq.push(list);
        }
    }
    ListNode *dummy = new ListNode(0);
    ListNode *current = dummy;
    
    while (!pq.empty()) {
        ListNode *node = pq.top();
        pq.pop();
        current->next = node;
        current = current->next;
        
        if (node->next != nullptr) {
            pq.push(node->next);
        }
    }
    return dummy;
}

void printList(ListNode *head) {
    while (head != nullptr) {
        std::cout << head->val << " ";
        head = head->next;
    }
    std::cout << std::endl;
}

int main(int argc, const char * argv[]) {
    // 创建几个有序链表
    ListNode* l1 = new ListNode(1);
    l1->next = new ListNode(4);
    l1->next->next = new ListNode(5);

    ListNode* l2 = new ListNode(1);
    l2->next = new ListNode(3);
    l2->next->next = new ListNode(4);

    ListNode* l3 = new ListNode(2);
    l3->next = new ListNode(6);

    std::vector<ListNode*> lists = {l1, l2, l3};

    ListNode* result = mergeKLists(lists);
    printList(result);  // 输出合并后的链表

    return 0;
}
