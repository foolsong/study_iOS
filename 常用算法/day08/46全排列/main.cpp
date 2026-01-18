//
//  main.cpp
//  46全排列
//
//  Created by chenlina on 2025/4/16.
//

/**
 给定一个不含重复数字的数组 nums ，返回其 所有可能的全排列 。你可以 按任意顺序 返回答案。

  

 示例 1：

 输入：nums = [1,2,3]
 输出：[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
 示例 2：

 输入：nums = [0,1]
 输出：[[0,1],[1,0]]
 示例 3：

 输入：nums = [1]
 输出：[[1]]
  
 */


#include <iostream>
#include <vector>

using namespace::std;

void backtrack(vector<vector<int>> &res, vector<int> &output, int first, int len) {
    if (first == len) {
        res.emplace_back(output);
    }
    
    for (int i = first; i < len; i++) {
        swap(output[i], output[first]);
        backtrack(res, output, first + 1, len);
        swap(output[i], output[first]);
    }
}

vector<vector<int>> permute(vector<int>& nums) {
    vector<vector<int>> res;
    backtrack(res, nums, 0, (int)nums.size());
    return res;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
