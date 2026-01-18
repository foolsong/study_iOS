//
//  main.cpp
//  3. 无重复字符的最长子串
//
//  Created by yjsong on 2024/11/27.
//

#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;

//int lengthOfLongestSubstring(string s) {
//    if (s.length() <= 0) {
//        return 0;
//    }
//    int maxLength = 0;
//    int startIndex = 0;
//    unordered_map<char, int> map;
//
//    int tempLength = 0;
//    for(int i = 0; i < s.size(); i++) {
//
//        if (map.contains(s[i])) {
//            int index = map[s[i]];
//            maxLength = maxLength < tempLength ? tempLength: maxLength;
//            for(int j = startIndex; j < index; j++) {
//                map.erase(s[j]);
//            }
//            startIndex = index + 1;
//            tempLength = i - index;
//
//        } else {
//            tempLength ++;
//        }
//        map[s[i]] = i;
//    }
//    maxLength = maxLength < tempLength ? tempLength: maxLength;
//    return maxLength;
//}

int lengthOfLongestSubstring(string s) {
    unordered_map<char, int> map;
    int maxLength = 0;
    int tempLength = 0;
    int startIndex = 0;
    for (int i = 0; i < s.length(); i++) {
        char c = s[i];
        if (map.contains(c)) {
            int index = map[c];
            maxLength = maxLength > tempLength ? maxLength : tempLength;
            tempLength = i - index;
            for (int j = startIndex; j <= index; j++) {
                map.erase(s[j]);
            }
            startIndex = index + 1;
        } else {
            tempLength ++;
        }
        map[c] = i;
    }
    maxLength = maxLength > tempLength ? maxLength : tempLength;
    
    return maxLength;
}

int main(int argc, const char * argv[]) {
    
    std::cout << lengthOfLongestSubstring("abcabcbb");
    
    std::cout << "\nHello, World!\n";
    return 0;
}
