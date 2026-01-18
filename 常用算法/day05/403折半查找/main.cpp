//
//  main.cpp
//  折半查找
//
//  Created by chenlina on 2025/1/31.
//

#include <iostream>
#include <vector>

using namespace::std;

/**
 *    折半查找：优化查找时间（不用遍历全部数据）
 *
 *    折半查找的原理：
 *   1> 数组必须是有序的
 *   2> 必须已知min和max（知道范围）
 *   3> 动态计算mid的值，取出mid对应的值进行比较
 *   4> 如果mid对应的值大于要查找的值，那么max要变小为mid-1
 *   5> 如果mid对应的值小于要查找的值，那么min要变大为mid+1
 *
 */ 

//long findKey(vector<int> &arr, int key) {
//    long min = 0, max = arr.size() - 1, mid;
//    while (min <= max) {
//        mid = (max  + min) / 2;
//        if (arr[mid] > key) {
//            max = mid - 1;
//        } else if (arr[mid] < key) {
//            min = mid + 1;
//        } else {
//            return mid;
//        }
//    }
//    return -1;
//}

long findKey(vector<int> &arr, int key) {
    long min = 0, max = arr.size() - 1, mid;
    while (min <= max) {
        mid = (max + min) / 2;
        if (arr[mid] > key) {
            max = mid - 1;
        } else if (arr[mid] < key) {
            mid = mid + 1;
        } else {
            return mid;
        }
    }
    return -1;
}


int main(int argc, const char * argv[]) {
    vector<int> arr = {1,2,3,4,5,6,7};
    long index = findKey(arr, 3);
    // insert code here...
    std::cout << index << "\nHello, World!\n";
    return 0;
}
