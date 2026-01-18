//
//  main.cpp
//  有序数组合并
//
//  Created by chenlina on 2025/1/31.
//

/*
 88. 合并两个有序数组
 
 给你两个按 非递减顺序 排列的整数数组 nums1 和 nums2，另有两个整数 m 和 n ，分别表示 nums1 和 nums2 中的元素数目。

 请你 合并 nums2 到 nums1 中，使合并后的数组同样按 非递减顺序 排列。

 注意：最终，合并后数组不应由函数返回，而是存储在数组 nums1 中。为了应对这种情况，nums1 的初始长度为 m + n，其中前 m 个元素表示应合并的元素，后 n 个元素为 0 ，应忽略。nums2 的长度为 n 。


 
 */

#include <iostream>
#include <vector>

using namespace::std;

vector<int> mergeSortedArrays(vector<int> & arr1, vector<int> & arr2) {
    int i = 0, j = 0;
    vector<int> result;
    
    while (i < arr1.size() && j < arr2.size()) {
        if (arr1[i] < arr2[j]) {
            result.push_back(arr1[i]);
            i++;
        } else {
            result.push_back(arr2[j]);
            j++;
        }
    }
    
    while (i < arr1.size()) {
        result.push_back(arr1[i]);
        i++;
    }
    
    while (j < arr2.size()) {
        result.push_back(arr2[j]);
        j++;
    }
    
    return result;
}

int main(int argc, const char * argv[]) {
    vector<int> arr1 = {1, 3, 5, 7};
    vector<int> arr2 = {2, 4, 6, 8};

    vector<int> mergedArray = mergeSortedArrays(arr1, arr2);

    // 输出合并后的数组
    for (int num : mergedArray) {
        cout << num << " ";
    }
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
