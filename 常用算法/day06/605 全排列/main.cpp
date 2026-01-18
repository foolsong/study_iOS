//
//  main.cpp
//  605 全排列
//
//  Created by chenlina on 2025/3/12.
//

// https://leetcode.cn/problems/7p8L0Z/description/
// https://leetcode.cn/problems/VvJkup/description/



#include <iostream>

#include <vector>
using namespace std;

void permute(vector<int>& nums, int start) {
    if (start == nums.size()) {
        // 输出当前的排列
        for (int num : nums) {
            cout << num << " ";
        }
        cout << endl;
        return;
    }
    for (int i = start; i < nums.size(); ++i) {
        // 交换元素
        swap(nums[start], nums[i]);
        // 递归生成后续的排列
        permute(nums, start + 1);
        // 交换回来
        swap(nums[start], nums[i]);
    }
}

int main() {
    vector<int> nums = {1, 2, 3};
    permute(nums, 0);
    return 0;
}


