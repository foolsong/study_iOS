//
//  main.cpp
//  L70爬楼梯
//
//  Created by yjsong on 2024/11/19.
//

#include <iostream>

int arr[45];
int climbStairs(int n) {
   if(n == 1) {return 1;}
   if(n == 2) {return 2;}
   if(arr[n-1] ==  0) {
       arr[n-1] =  climbStairs(n-1) + climbStairs(n-2);
   }
   return arr[n-1];
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
