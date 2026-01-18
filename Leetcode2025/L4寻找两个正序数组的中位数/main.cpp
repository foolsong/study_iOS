//
//  main.cpp
//  L4寻找两个正序数组的中位数
//
//  Created by yjsong on 2024/11/20.
//

#include <iostream>
#include <vector>

using namespace std;

double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
    long count = nums1.size() + nums2.size();
    bool midOneNum = count % 2 == 0;
    
    long midIndex = (long) count / 2;
    
    int n1 = 0;
    int n2 = 0;
    int currenIndex = 0;
    while (true) {
        if (midIndex ==  currenIndex && midOneNum) {
            return min(nums1[n1] , nums2[n2]);
        } else if (midIndex ==  currenIndex) {
            
            return ;
        }
        
        if (nums1[n1] < nums2[n2]) {
            n1++;
        } else {
            n2++;
        }
        currenIndex ++;
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
