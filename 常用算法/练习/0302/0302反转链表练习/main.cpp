//
//  main.cpp
//  0302反转链表练习
//
//  Created by chenlina on 2025/3/2.
//

#include <iostream>
#include <string>
#include <unordered_map>
#include <stack>

using namespace::std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(): val(0), next(nullptr){};
};

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
}
void reverseList(ListNode *head) {
    ListNode *res = nullptr;
    ListNode *curr = head;
    while (curr->next) {
        ListNode *temp = curr->next;
        curr->next = res;
        res = curr;
        curr = temp;
        
    }
}

void reverseString(string s) {
    int i = 0;
    int j = (int)s.length() - 1;
    while (i < j) {
        swap(s[i], s[j]);
    }
}

bool findTwoSumHashMap(vector<int>& nums, int target) {
    unordered_map<int, int> map;
    for (int i = 0; i < nums.size(); i++) {
        int temp = target - nums[i];
        if (map.contains(temp) ) {
            return true;
        }
        map[nums[i]] = nums[i];
    }
    return false;
}

int lengthOfSubSring (string s) {
    unordered_map<char, int> map;
    int maxLength = 0;
    int tempLength = 0;
    int startIndex = 0;
    for (int i = 0; i < s.length(); i++) {
        char currChar = s[i];
        if (map.contains(currChar)) {
            int index = map[currChar];
            maxLength = maxLength > tempLength ? maxLength : tempLength;
            tempLength = i - index;
            startIndex = index + 1;
            for (int j =  startIndex; j <= index; j++) {
                map.erase(s[j]);
            }
        } else {
            tempLength ++;
        }
        map[currChar] = i;
    }
    maxLength = maxLength > tempLength ? maxLength : tempLength;
    return  maxLength;
}

ListNode * detectCycle(ListNode *head) {
    if (!head && !head->next) {
        return nullptr;
    }
    ListNode *quick = head;
    ListNode *slow = head;
    while (quick != nullptr) {
        if (quick == nullptr || quick->next == nullptr) {
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

void tree(TreeNode *node) {
    stack<TreeNode *> s;
    s.push(node);
    while (!s.empty()) {
        TreeNode *temp = s.top();
        s.pop();
        if (temp->left) {
            s.push(temp->left);
        }
        if (temp->right) {
            s.push(temp->right);
        }
        
    }
}

char firstChar (string s) {
    unordered_map<char, int> map;
    for (char c : s) {
        int count = map[c];
        map[c] = count + 1;
    }
    
    for (char c : s) {
        int count = map[c];
        if (count == 1) {
            return c;
        }
    }
    return '\0';
}

bool isP(string s, int start, int end) {
    while (start < end) {
        if (s[start] != s[end]) {
            return false;
        }
        start++;
        end--;
    }
    return true;
}

string length (string s) {
    if (s.length() <= 1) {
        return s;
    }
    int start = 0, end = 0;
    for (int i = 0; i < s.length(); i ++) {
        for (int j = i; j < s.length(); j++) {
            if (isP(s, i, j) && j - i > end - start) {
                start = i;
                end = j;
            }
        }
    }
    return s.substr(start, end - start + 1);
}

TreeNode *findCA(TreeNode *node, TreeNode *p, TreeNode *q) {
    if (node == nullptr || node == p || node == q) {
        return node;
    }
    
    TreeNode *left = findCA(node->left, p, q);
    TreeNode *right = findCA(node->right, p, q);
    
    if (left != nullptr && right != nullptr) {
        return node;
    }
    
    return left !=nullptr ? left : right;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
