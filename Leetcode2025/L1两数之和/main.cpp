//
//  main.cpp
//  L1两数之和
//
//  Created by yjsong on 2024/11/19.
//

#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;

vector<int> twoSum2(vector<int>& nums, int target) {
    for (int i = 0; i < nums.size(); i++) {
        for (int j = i + 1; j < nums.size(); j++) {
            if (nums[i] + nums[j] == target) {
                return {i, j};
            }
        }
    }
    return {};
}

vector<int> twoSum(vector<int>& nums, int target) {
    unordered_map<int, int> hashtable;
    for(int i = 0; i < nums.size(); i++) {
        auto it = hashtable.find(target - nums[i]);
        if (it != hashtable.end()) {
            return {it->second, i};
        }
        hashtable[nums[i]] = i;
    }
    return {};
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
