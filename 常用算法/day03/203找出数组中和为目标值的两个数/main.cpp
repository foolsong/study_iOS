//
//  main.cpp
//  找出数组中和为目标值的两个数
//
//  Created by chenlina on 2025/1/31.
//

#include <iostream>
#include <vector>
#include <unordered_map>

using namespace::std;

bool findTwoSumHashMap(vector<int>& nums, int target) {
    std::unordered_map<int, int> numMap;

    for (int num : nums) {
        int complement = target - num;
        if (numMap.find(complement) != numMap.end()) {
            std::cout << "Pair found: (" << complement << ", " << num << ")" << std::endl;
            return true;
        }
        
        numMap[num] = 1;
    }
    return false;
}

//bool findTwoSumHashMap(vector<int>& nums, int target) {
//    
//}

int main() {
    vector<int> nums = {2, 7, 11, 15};
    int target = 9;
    
    if (!findTwoSumHashMap(nums, target)) {
        std::cout << "No pair found with the target sum." << std::endl;
    }

    return 0;
}
