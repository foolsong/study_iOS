//
//  main.cpp
//  L3无重复字符的最长子串
//
//  Created by yjsong on 2024/11/20.
//

#include <iostream>
#include <string>
#include <unordered_map>

using namespace std;



int lengthOfLongestSubstring(string s) {
    if (s.length() <= 0) {
        return 0;
    }
    int maxLeng = 0;
    unordered_map<char, int> map;
    
    int tempLeng = 0;
    int leftIndex = 0;
    for (int i = 0; i < s.length(); i++) {
        if (map.contains(s[i])) {
            int  index = map[s[i]];
            maxLeng = tempLeng > maxLeng ? tempLeng : maxLeng;
            tempLeng = i - index;
            
            for (int  j = leftIndex; j < index; j++) {
                map.erase(s[j]);
            }
            leftIndex = index + 1;
            
        } else {
            tempLeng++;
        }
        map[s[i]] = i;
    }
    maxLeng = tempLeng > maxLeng ? tempLeng : maxLeng;
    return maxLeng;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    
    int t = lengthOfLongestSubstring("abba");
    std::cout << t << "\n\n\nHello, World!\n";
    return 0;
}
