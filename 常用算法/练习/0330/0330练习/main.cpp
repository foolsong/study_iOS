//
//  main.cpp
//  0330练习
//
//  Created by chenlina on 2025/3/30.
//

#include <iostream>
#include <queue>

using namespace::std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val): val(val){};
};

struct Compare {
    bool operator()(ListNode *a, ListNode *b) {
        return a->val > b->val;
    }
};

// 合并 n 链表
ListNode * mergeKList(vector<ListNode *> lists) {
    priority_queue<ListNode *,  vector<ListNode *>, Compare> pq;
    for (auto list : lists) {
        if (list != nullptr) {
            pq.push(list);
        }
    }
    ListNode *dummy = new ListNode(-1);
    ListNode *curr = dummy;
    
    while (!pq.empty()) {
        ListNode *temp = pq.top();
        pq.pop();
        curr->next = temp;
        curr = curr->next;
        if (temp->next) {
            pq.push(temp->next);
        }
    }
    return dummy->next;
}

//  快排

int patation(vector<int> &arr, int low, int high){
    int temp = arr[high];
    int i = low - 1;
    for (int j =  low; j < high; j++) {
        if (arr[j] < temp) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}

void quickSort(vector<int> &arr, int low, int high){
    if (low < high) {
        int p = patation(arr, low, high);
        quickSort(arr, p + 1, high);
        quickSort(arr, low, p - 1);
    }
}

void printVec(vector<int> &arr) {
    for (int i : arr) {
        std::cout << i << "  ";
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    
    vector<int> arr = {3, 6, 8, 9, 1, 12, 54, 23};
    quickSort(arr, 0, arr.size() - 1);
    printVec(arr);
    return 0;
}
