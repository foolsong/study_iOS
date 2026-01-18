//
//  main.cpp
//  0303遍历查找父节点
//
//  Created by chenlina on 2025/3/3.
//

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
};

#include <iostream>
#include <vector>
#include <unordered_map>

using namespace::std;

char findOnecChar(string s) {
    unordered_map<char, int> map;
    for (auto c : s) {
        int count = map[c];
        map[c] = count  + 1;
    }
    
    for (auto c : s) {
        int count = map[c];
        if (count == 1) {
            return c;
        }
    }
    return '\0';
    
}

TreeNode * findLCA (TreeNode *node, TreeNode *p, TreeNode *q) {
    if (node == nullptr || node == p || node == q) {
        return node;
    }
    TreeNode *left = findLCA(node->left, p, p);
    TreeNode *right = findLCA(node->right, p, q);
    if (left != nullptr && right != nullptr) {
        return node;
    }
    
    return left != nullptr ? left : right;
}

int findKey(vector<int> &arr, int key) {
    int max = (int)arr.size() - 1, mid, min = 0;
    while (min <= max) {
        mid = (max + min) / 2;
        if (arr[mid] == key) {
            return mid;
        } else if (arr[mid] > key) {
            max = mid - 1 ;
        } else {
            min = mid + 1;
        }
    }
    return -1;
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

string lengthMaxSubString(string s) {
    if (s.length() <= 1) {
        return s;
    }
    long length = s.length();
    int start = 0;
    int end = 0;
    for (int i = 0; i < length; i++) {
        for (int j = 0; j < length; j++) {
            if (isP(s, i, j) && end - start < i - j) {
                start = i;
                end = j;
            }
        }
    }
    return s.substr(start, end - start + 1);
}



int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
