//
//  main.cpp
//  L23合并 K 个升序链表
//
//  Created by chenlina on 2025/2/5.
//

#include <iostream>
#include <vector>
#include <iostream>
#include <queue>

using namespace::std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

struct Status {
    int val;
    ListNode *ptr;
    bool operator < (const Status &rhs) const {
        return val > rhs.val;
    }
};

priority_queue <Status> q;

ListNode* mergeKLists(vector<ListNode*>& lists) {
    for (auto node: lists) {
        if (node) q.push({node->val, node});
    }
    ListNode head, *tail = &head;
    while (!q.empty()) {
        auto f = q.top(); q.pop();
        tail->next = f.ptr;
        tail = tail->next;
        if (f.ptr->next) q.push({f.ptr->next->val, f.ptr->next});
    }
    return head.next;
}

int main() {
    vector<int>v1;
    v1.push_back(10);
    v1.push_back(24);
    v1.erase(v1.begin());
    v1.pop_back();
    v1.empty();
    
    
    
    
    
    
    
    
    
    std::priority_queue<Status> pq;

    Status s1 = {10, nullptr};
    Status s2 = {20, nullptr};
    Status s3 = {15, nullptr};

    pq.push(s1);
    pq.push(s2);
    pq.push(s3);

    while (!pq.empty()) {
        std::cout << pq.top().val << std::endl;  // 打印优先队列中 val 的值
        pq.pop();
    }

    return 0;
}
