//
//  main.cpp
//  接雨水
//
//  Created by chenlina on 2025/3/12.
//

#include <iostream>
#include <vector>
#include <algorithm>

using namespace::std;

int trap(vector<int>& height) {
    int left = 0, right = height.size() - 1;
    int left_max = 0, right_max = 0;
    int res = 0;
    
    while (left < right) {
        if (height[left] < height[right]) {
            height[left] >= left_max ? (left_max = height[left]) : res += (left_max - height[left]);
            ++left;
        } else {
            height[right] >= right_max ? (right_max = height[right]) : res += (right_max - height[right]);
            --right;
        }
    }
    return res;
}




using namespace std;

int trap(vector<int>& height) {
    if (height.empty()) return 0;
    
    int left = 0, right = height.size() - 1;  // 左右指针
    int left_max = 0, right_max = 0;  // 分别记录左右边界的最大值
    int water_trapped = 0;  // 存储接住的水量

    while (left <= right) {
        if (height[left] < height[right]) {
            if (height[left] >= left_max) {
                left_max = height[left];  // 更新左边的最大高度
            } else {
                water_trapped += left_max - height[left];  // 计算接住的水量
            }
            left++;
        } else {
            if (height[right] >= right_max) {
                right_max = height[right];  // 更新右边的最大高度
            } else {
                water_trapped += right_max - height[right];  // 计算接住的水量
            }
            right--;
        }
    }

    return water_trapped;
}

int trap2(vector<int> &high) {
    if (high.empty()) {
        return 0;
    }
    int left = 0, right = (int)high.size() - 1;
    int leftMax = 0, rightMax = 0;
    int waterCount = 0;
    while (left < right) {
        if (high[left] < high[right]) {
            if (high[left] > leftMax) {
                leftMax = high[left];
            } else {
                waterCount += leftMax - high[left];
            }
            left++;
        } else {
            if (high[right] > rightMax) {
                rightMax = high[right];
            } else {
                waterCount += rightMax - high[right];
            }
            right--;
        }
    }
    return waterCount;
}

int main() {
    vector<int> height = {0,1,0,2,1,0,1,3,2,1,2,1};
    cout << "Total water trapped: " << trap(height) << endl;
    return 0;
}


//int main(int argc, const char * argv[]) {
//    // insert code here...
//    std::cout << "Hello, World!\n";
//    return 0;
//}
