//
//  main.cpp
//  递归1到100
//
//  Created by yjsong on 2024/11/24.
//

#include <iostream>
//
//int sum(int tag) {
//    if (tag == 1) {
//        return 1;
//    }
//
//    return tag + sum(tag - 1);
//}


int sum(int tag) {
    if (tag == 1) {
        return 1;
    }
    return tag + sum(tag - 1);
}




int main(int argc, const char * argv[]) {
    int t =  sum2(6);
    std::cout << t << "\nHello, World!\n";
    return 0;
}
