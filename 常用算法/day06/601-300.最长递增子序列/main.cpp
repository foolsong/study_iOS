//
//  main.cpp
//  601-300.最长递增子序列
//
//  Created by chenlina on 2025/3/11.
//

// https://leetcode.cn/problems/longest-increasing-subsequence/description/

/*
 给你一个整数数组 nums ，找到其中最长严格递增子序列的长度。

 子序列 是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。例如，[3,6,2,7] 是数组 [0,3,1,6,2,2,7] 的子序列。

  
 示例 1：

 输入：nums = [10,9,2,5,3,7,101,18]
 输出：4
 解释：最长递增子序列是 [2,3,7,101]，因此长度为 4 。
 示例 2：

 输入：nums = [0,1,0,3,2,3]
 输出：4
 示例 3：

 输入：nums = [7,7,7,7,7,7,7]
 输出：1
 
 */

#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

// ****************************** 方法 一  ******************************
int lengthOfLIS(vector<int>& nums) {
    if (nums.empty()) return 0;
    
    int n = nums.size();
    vector<int> dp(n, 1);  // dp[i] 表示以 nums[i] 结尾的最长递增子序列的长度

    // 填充 dp 数组
    for (int i = 1; i < n; ++i) {
        for (int j = 0; j < i; ++j) {
            if (nums[i] > nums[j]) {
                dp[i] = max(dp[i], dp[j] + 1);  // 更新 dp[i]
            }
        }
    }

    // 返回 dp 数组中的最大值，即为最长递增子序列的长度
    return *max_element(dp.begin(), dp.end());
}

// ****************************** 方法 二  ******************************
int lengthOfLIS2(vector<int>& nums) {
    if (nums.empty()) return 0;
    
    vector<int> tails;  // 用来保存递增子序列的尾部元素

    for (int num : nums) {
        // 使用二分查找找到 tails 中第一个不小于 num 的位置
        auto it = lower_bound(tails.begin(), tails.end(), num);
        
        if (it == tails.end()) {
            tails.push_back(num);  // 如果没找到，则将 num 添加到 tails 的末尾
        } else {
            *it = num;  // 否则更新该位置的值
        }
    }

    return tails.size();  // tails 的大小即为最长递增子序列的长度
}


int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
