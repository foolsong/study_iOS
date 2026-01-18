//
//  main.cpp
//  有序数组合并练习
//
//  Created by chenlina on 2025/3/2.
//

#include <iostream>
#include <vector>

using namespace::std;

vector<int>mergerList(vector<int> &arr1, vector<int> &arr2) {
    vector<int> res;
    int i = 0, j = 0;
    while (i < arr1.size() || j < arr2.size()) {
        if (arr1[i] > arr2[j]) {
            res.push_back(arr2[j]);
            j++;
        } else {
            res.push_back(arr1[i]);
            i++;
        }
    }
    
    while (i < arr1.size()) {
        res.push_back(arr1[i]);
        i++;
    }
    
    while (j < arr2.size()) {
        res.push_back(arr2[j]);
        j++;
    }
    return res;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
