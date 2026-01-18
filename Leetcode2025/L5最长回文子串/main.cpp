//
//  main.cpp
//  L5最长回文子串
//
//  Created by yjsong on 2024/11/24.
//

#include <iostream>
#include <string>
//#include <>

using namespace std;

pair<int, int> palindrome(const string& s, int start, int end) {
    while (start >= 0 && end < s.length() && s[start] == s[end]) {
        start--;
        end++;
    }
    return {start + 1, end - 1};
}

string longestPalindrome(string s) {
    if (s.length() <= 0) {
        return "";
    }
    int start = 0;
    int end = 0;
    for(int i = 0; i < s.length(); i++) {
        auto[left, right] = palindrome(s, i, i);
        auto[left2, right2] = palindrome(s, i, i+ 1);
        if (end - start < right - left) {
            start = left;
            end = right;
        }
        if (end - start < right2 - left2) {
            start = left2;
            end = right2;
        }
    }
    return s.substr(start, end - start + 1);
}

int main(int argc, const char * argv[]) {
    
    std::cout << longestPalindrome("bb") << "\n";
    return 0;
}
