//
//  main.cpp
//  0512练习
//
//  Created by chenlina on 2025/5/12.
//

#include <iostream>
#include <vector>
using namespace::std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int val):val(val), next(nullptr){}
};

struct Compare {
    bool operator()(ListNode *a, ListNode *b){
        return a->val > b->val;
    }
};

ListNode * mergeList(vector<ListNode *> lists) {
    priority_queue<ListNode *, vector<ListNode *>, Compare> queue;
    for (auto list : lists) {
        queue.push(list);
    }
    ListNode *dummy = new ListNode(0);
    ListNode *current = dummy;
    while (!queue.empty()) {
        ListNode *t = queue.top();
        queue.pop();
        current->next = t;
        current = current->next;
        if (t->next) {
            queue.push(t->next);
        }
    }
    return dummy;
}




int sum(int tag) {
    if (tag == 1) {
        return 1;
    }
    return tag + sum(tag - 1);
}

int partition(vector<int> &arr, int low, int hight) {
    int temp = arr[hight];
    int i = low - 1;
    for (int j = low; j < hight; j++) {
        if (arr[j] < temp) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[hight]);
    return  i + 1;
}


void quickSort(vector<int> &arr, int low, int hight) {
    if (low < hight) {
        int p = 0;
        quickSort(arr, p + 1, hight);
        quickSort(arr, low, p + 1);
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
