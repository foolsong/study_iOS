//
//  main.cpp
//  回文串
//
//  Created by yjsong on 2024/11/24.
//

#include <iostream>
#include "string"

using namespace::std;

//bool isPalindrome(const string &s, int start, int end) {
//    while (start <= end) {
//        if (s[start] != s[end]) {
//            return false;
//        }
//        start++;
//        end--;
//    }
//    return true;
//}
//
//string longestPalindrome(string s) {
//    if (s.length() <= 0) {
//        return "";
//    }
//    int start = 0;
//    int end = 0;
//
//    for(int i = 0; i < s.length(); i++) {
//        for(int j = i; j < s.length(); j++) {
//            if (isPalindrome(s, i, j) && (end - start) < (j - i)) {
//                start = i;
//                end = j;
//            }
//        }
//    }
//    return s.substr(start, end - start + 1);
//}

/**
 示例 1：

 输入：s = "babad"
 输出："bab"
 解释："aba" 同样是符合题意的答案。
 示例 2：

 输入：s = "cbbd"
 输出："bb"
 
 */


bool isP(string s, int start, int end) {
    if (s.length() <= 0) {
        return false;
    }
    while (start <= end) {
        if (s[start] != s[end]) {
            return false;
        }
        start++;
        end--;
    }
    return true;
}

string longestPalindrome(string s) {
    if (s.length() <= 0) {
        return "";
    }
    int startIndex = 0;
    int endIndex = 0;
    for (int i = 0; i < s.length(); i++) {
        for (int j = i; j < s.length(); j++) {
            if (isP(s, i, j) && j - i > endIndex - startIndex) {
                startIndex = i;
                endIndex = j;
            }
        }
    }
    return s.substr(startIndex, endIndex - startIndex + 1);
}





int main(int argc, const char * argv[]) {
    
    std::cout << longestPalindrome("aacabdkacaa") << "\n";
    return 0;
}
