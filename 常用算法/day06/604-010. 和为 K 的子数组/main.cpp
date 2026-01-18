//
//  main.cpp
//  604-010. 和为 K 的子数组
//
//  Created by chenlina on 2025/3/12.
//

//LCR 010. 和为 K 的子数组
/**
 给定一个整数数组和一个整数 k ，请找到该数组中和为 k 的连续子数组的个数。

  

 示例 1：

 输入:nums = [1,1,1], k = 2
 输出: 2
 解释: 此题 [1,1] 与 [1,1] 为两种不同的情况
 示例 2：

 输入:nums = [1,2,3], k = 3
 输出: 2
 
 */

#include <iostream>
#include <vector>
using namespace std;


int subarraySum(vector<int>& nums, int k) {
        int count = 0;
        for (int start = 0; start < nums.size(); ++start) {
            int sum = 0;
            for (int end = start; end >= 0; --end) {
                sum += nums[end];
                if (sum == k) {
                    count++;
                }
            }
        }
        return count;
    }



int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
