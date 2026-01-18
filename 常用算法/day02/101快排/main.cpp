//
//  main.cpp
//  快排
//
//  Created by yjsong on 2024/12/10.
//

#include <iostream>
#include <vector>

using namespace std;

//int partition(vector<int>& arr, int low, int high) {
//    int pivot = arr[high];
//    int i = low - 1;
//    for(int j = low; j < high; j++) {
//        if (arr[j] < pivot) {
//            i++;
//            swap(arr[i], arr[j]);
//        }
//    }
//    swap(arr[i + 1], arr[high]);
//    return i + 1;
//}
//
//void quickSort(vector<int>& arr, int low, int high) {
//    if (low < high) {
//        int pi = partition(arr, low, high);
//
//        quickSort(arr, low, pi - 1);
//        quickSort(arr, pi + 1, high);
//    }
//}

int partition(vector<int>& arr, int low, int high) {
    int temp = arr[high];
    int i = low - 1;
    for (int j =  low; j < high; j++) {
        if (arr[j] < temp) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}

void quickSort(vector<int>& arr, int low, int high) {
    if (low < high) {
        int p = partition(arr, low, high);
        quickSort(arr, p + 1, high);
        quickSort(arr, low,  p - 1);
    }
}


int main(int argc, const char * argv[]) {
    vector<int> arr = {10, 7, 8, 9, 1, 5};
    long n = arr.size();
    std::cout << "原始数组：";
    for (int i : arr) {
        std::cout << i << " ";
    }
    std::cout << endl;
    
    quickSort(arr, 0, (int)n-1);
    
    std::cout << "排序后数组:" ;
    
    for(int i : arr) {
        std::cout << i << " ";
    }
    
    std::cout << "\n Hello, World!\n";
    return 0;
}


void sore(vector<int> arr) {
    long size = arr.size();
    for (int i = 0; i < size - 1; i++) {
        for (int j = i; j < size - 1 - i; j ++) {
            if (arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
            }
        }
    }
}

/** 冒泡
 
 void bubbleSort(std::vector<int>& vec) {
     int n = vec.size();
     // 外层循环控制排序趟数
     for (int i = 0; i < n - 1; i++) {
         // 内层循环进行相邻元素的比较和交换
         for (int j = 0; j < n - i - 1; j++) {
             if (vec[j] > vec[j + 1]) {
                 // 交换相邻元素
                 std::swap(vec[j], vec[j + 1]);
             }
         }
     }
 }
 
 */

/** 选择排序
 
 void selectionSort(int arr[], int n) {
     for (int i = 0; i < n - 1; i++) {
         int minIndex = i;
         for (int j = i + 1; j < n; j++) {
             if (arr[j] < arr[minIndex]) {
                 minIndex = j;
             }
         }
         // 交换
         std::swap(arr[i], arr[minIndex]);
     }
 }
 
 */
