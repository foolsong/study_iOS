//
//  main.cpp
//  反转字符串
//
//  Created by yjsong on 2024/11/27.
//

#include <iostream>
#include <vector>

using namespace std;

//void reverseString(vector<char>& s) {
//    long start = 0;
//    long end = s.size() - 1;
//    if (end < 0) {
//        return;
//    }
//    while (end > start) {
//        char temp = s[start];
//        s[start] = s[end];
//        s[end] = temp;
//        start++;
//        end--;
//    }
//}

void print(vector<char> &s) {
    for (char c : s) {
        std::cout << c ;
    }
    std::cout << "\n";
}

void reverseString (vector<char> &s) {
    print(s);
    int left = 0;
    int right = (int)s.size() - 1;
    while (left < right) {
        char temp = s[left];
        s[left] = s[right];
        s[right] = temp;
    }
    print(s);
}



int main(int argc, const char * argv[]) {
    vector<char> vec3 = {'H','e','l','l','o',' ','w','o','r','l','d'};
    reverseString(vec3);
    // insert code here...
    std::cout << "\n";
    return 0;
}
