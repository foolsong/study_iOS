//
//  main.cpp
//  0430c++练习
//
//  Created by chenlina on 2025/4/30.
//

#include <iostream>
#include <string>

using namespace::std;

void test(int left, int right, string str) {
    if (left == 0 && right == 0) {
        std::cout << str << "\n";
        return;
    }
    
    if (left  > 0) {
        test(left - 1 , right, str + "(");
    }
    
    if (left < right) {
        test(left , right - 1, str + ")");
    }
    
}

void test2(vector<int> &nums, int f,int len) {
    if (f == len) {
        for(int n : nums) {
            std::cout << n << " ";
        }
        std::cout << "\n";
        return;
    }
    
    for (int i = f; i < len; i++) {
        swap(nums[i], nums[f]);
        test2(nums, i + 1, len);
        swap(nums[i], nums[f]);
    }
}

int main(int argc, const char * argv[]) {
//    test(3, 3, "");
    vector<int> n = {1,2,3,4};
    test2(n, 0, 4);
    
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
