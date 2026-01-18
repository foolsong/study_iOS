//
//  main.cpp
//  无序数组中的中位数
//
//  Created by chenlina on 2025/1/31.
//

///  相似题目：  215. 数组中的第K个最大元素

#include <iostream>

#include <vector>
#include <algorithm>

using namespace::std;

//int partition(vector<int>& nums, int low, int high) {
//    int pivot = nums[high]; // 选择最右边的元素作为基准
//    int i = low - 1; // i是分区边界
//
//    // 对数组进行分区操作
//    for (int j = low; j <= high - 1; j++) {
//        if (nums[j] <= pivot) {
//            i++; // 增加分区边界
//            std::swap(nums[i], nums[j]); // 把小于等于pivot的元素放到左边
//        }
//    }
//    std::swap(nums[i + 1], nums[high]); // 将基准元素放到正确的位置
//    return i + 1; // 返回基准元素的位置
//}
//
//int quickSelect(vector<int>& nums, int low, int high, int k) {
//    if (low == high) {
//        return nums[low]; // 如果只有一个元素，返回该元素
//    }
//
//    int pivotIndex = partition(nums, low, high);
//
//    if (k == pivotIndex) {
//        return nums[k]; // 找到第k个元素
//    } else if (k < pivotIndex) {
//        return quickSelect(nums, low, pivotIndex - 1, k); // 在左边递归
//    } else {
//        return quickSelect(nums, pivotIndex + 1, high, k); // 在右边递归
//    }
//}
//
//double findMedian(vector<int>& nums) {
//    int n = nums.size();
//    if (n % 2 == 1) {
//        // 数组长度是奇数，找中间的元素
//        return quickSelect(nums, 0, n - 1, n / 2);
//    } else {
//        // 数组长度是偶数，找中间两个元素的平均值
//        int left = quickSelect(nums, 0, n - 1, n / 2 - 1);
//        int right = quickSelect(nums, 0, n - 1, n / 2);
//        return (left + right) / 2.0;
//    }
//}

int partion(vector<int> &nums, int low, int high) {
    int temp = nums[high];
    int i = low - 1;
    for (int j = low; j < high - 1; j ++) {
        if (nums[j]  < temp) {
            i++;
            swap(nums[i], nums[j]);
        }
    }
    swap(nums[i + 1], nums[high]);
    return i + 1;
}

int quickSortSelect(vector<int> &nums, int low, int high, int k) {
    if (low == high) {
        return nums[low];
    }
    int p = partion(nums, low, high);
    if (p == k) {
        return nums[p];
    } else if(p > k) {
        return quickSortSelect(nums, low, p - 1, k);
    } else {
        return quickSortSelect(nums, p + 1, high, k);
    }
    
}

double findMedNum(vector<int> &nums) {
    int size = (int)nums.size();
    if (size % 2 == 1) {
        return quickSortSelect(nums, 0, size -  1, size / 2);
    } else {
        int left = quickSortSelect(nums, 0, size -  1, size / 2 - 1);
        int right = quickSortSelect(nums, 0, size -  1, size / 2);
        
        return (left + right) / 2;
    }
}




int main() {
    vector<int> nums = {1, 3, 2, 4, 5}; // 示例无序数组

    double median = findMedNum(nums);

    std::cout << "The median is: " << median << std::endl;

    return 0;
}
