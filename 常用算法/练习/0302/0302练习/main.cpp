//
//  main.cpp
//  0302练习
//
//  Created by chenlina on 2025/3/2.
//

#include <iostream>
#include <vector>
#include <queue>


using namespace::std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val):val(val){};
};

struct Compare {
    bool operator()(ListNode *a, ListNode *b){
        return a->val > b->val;
    }
};

ListNode * mergerKList(vector<ListNode *> &lists) {
    priority_queue<ListNode *,vector<ListNode *>, Compare> pq;
    for (auto listNode : lists) {
        if (listNode) {
            pq.push(listNode);
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
    return dummy->next;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
