//
//  main.cpp
//  L15三数之和
//
//  Created by yjsong on 2024/11/20.
//

/**
 给你一个整数数组 nums ，判断是否存在三元组 [nums[i], nums[j], nums[k]] 满足 i != j、i != k 且 j != k ，同时还满足 nums[i] + nums[j] + nums[k] == 0 。请你返回所有和为 0 且不重复的三元组。

 注意：答案中不可以包含重复的三元组。
 */

#include <iostream>
#include <vector>

using namespace std;

vector<vector<int>> threeSum(vector<int>& nums) {
    vector<vector<int>> res;
    long n = nums.size();
    std::sort(nums.begin(), nums.end());
    for(int i = 0; i < n - 2; i++) {
        if (i > 0 &&nums[i - 1] == nums[i] ) {
            continue;
        }
        vector<int> temp;
        int val = nums[i];
        long p = i + 1;
        long q = n - 1;
        
        while (q > p) {
            if (val + nums[p] + nums[q] == 0) {
                temp = { nums[i], nums[p], nums[q]};
                res.push_back(temp);
                p++;
                while (p - 1 > 0 && p < n && nums[p] == nums[p - 1]) {
                    p++;
                }
                q = n - 1;
            } else if (val + nums[p] + nums[q] > 0) {
                q--;
            } else {
                p++;
            }
        }
    }
    
    return res;
}

int main(int argc, const char * argv[]) {
//    vector<int> t= {-1,0,1,2,-1,-4};
    vector<int> t= {0, 0, 0, 0};
    vector<vector<int>> res = threeSum(t);
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
