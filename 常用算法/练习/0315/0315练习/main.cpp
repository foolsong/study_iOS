//
//  main.cpp
//  0315练习
//
//  Created by chenlina on 2025/3/15.
//

#include <iostream>
#include <vector>

using namespace::std;
// 快排

int partition(vector<int> &arr, int low, int high) {
    int temp = arr[high];
    int i = low - 1;
    for (int j = low; j < high; j++) {
        if (arr[j] < temp) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}

void quickSort(vector<int> &arr, int low, int high) {
    if (low < high) {
        int p = partition(arr, low, high);
        quickSort(arr, low, p -1 );
        quickSort(arr, p + 1, high);
        
    }
}


int main(int argc, const char * argv[]) {
    vector<int > arr = {2, 4, 6, 9, 12, 10};
    
    for (int i = 0; i < arr.size(); i++) {
        std::cout <<"  " << arr[i];
    }
    
    std::cout << "Hello, World!\n";
    quickSort(arr, 0, arr.size() - 1);
    for (int i = 0; i < arr.size(); i++) {
        std::cout <<"  " << arr[i];
    }
    return 0;
}
