//
//  main.cpp
//  56合并区间
//
//  Created by chenlina on 2025/4/6.
//

#include <iostream>
#include "unordered_map"
#include "vector"

using namespace::std;

vector<vector<int>> mergeL(vector<vector<int>>& intervals) {
    int max = 0;
    for(auto intVal : intervals) {
        int right = intVal[1];
        max = max > right ? max : right;
    }

    vector<int> vec((max + 2) * 2, 0);
    for(auto intVal : intervals) {
        int left = intVal[0] * 2;
        int right = intVal[1] * 2;
        for(int i = left; i <= right; i++) {
            vec[i] = 1;
        }
    }
    vector<vector<int>> res;
    int star = 0;
    int end = 0;
    int lastNum = vec[0];
    int s = (int)vec.size();
    for(int i = 0; i < s; i++) {
        if(lastNum == 0 && vec[i] == 1) {
            star = i;
            end = end < star ? star : end;
        } else if(lastNum == 1 && vec[i] == 0) {
            res.push_back({star/ 2, end / 2});
        } else if(lastNum == 1 && vec[i] == 1) {
            end = i;
        }
        lastNum= vec[i];
    }
    return res;
}

void name (vector<vector<int>>& intervals) {
    std::cout << "Hello, World!\n";
}

int main(int argc, const char * argv[]) {
    
    
    
    vector<vector<int>> m = {{2,3},{5,5},{2,2},{3,4},{3,4}};
    mergeL(m);
//    name(&m);
//    mergeL({{1,4},{0,0}});
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}

