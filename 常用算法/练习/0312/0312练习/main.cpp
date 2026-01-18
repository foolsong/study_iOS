//
//  main.cpp
//  0312练习
//
//  Created by chenlina on 2025/3/12.
//

#include <iostream>
#include <vector>
#include <queue>

using namespace::std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val): val(val){};
};

struct Compare {
    bool operator() (ListNode *a, ListNode *b) {
        return a->val > b->val;
    }
};

ListNode* mergeKLists(vector<ListNode*> & lists) {
    priority_queue<ListNode *, vector<ListNode *>, Compare> q;
    for (auto node : lists) {
        q.push(node);
    }
    ListNode *res = new ListNode(0);
    ListNode *curr = res;
    
    while (!q.empty()) {
        ListNode *temp = q.top();
        q.pop();
        
        if (temp->next != nullptr) {
            q.push(temp->next);
        }
        curr->next = temp;
        curr = curr->next;
    }
    return res;
}

int partoin(vector<int> &arr, int low, int high) {
    int temp = arr[high];
    int j = low;
    for (int i = low; i < high; i++) {
        if (arr[i] > temp) {
            j++;
            swap(arr[i], arr[j])
        }
    }
    swap(arr[high], arr[j+1]);
    return j + 1;
}

void quickSort(vector<int> &arr, int low, int high) {
    if (low < high) {
        int p =
        
        return;
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
