//
//  main.cpp
//  查找第一个只出现一次的字符
//
//  Created by chenlina on 2025/1/31.
//

#include <iostream>
#include <vector>
#include <unordered_map>

using namespace::std;

char firstUniqChar(string &s) {
    unordered_map<char, int> map;
    for (char c : s) {
        int count = map[c];
        map[c] = count + 1;
    }
    
    for (char c : s) {
        int count = map[c];
        if (count == 1) {
            return c;
        }
    }
    
    return '\0';
}

int main(int argc, const char * argv[]) {
    std::string s = "swiss";
    char result = firstUniqChar(s);

    if (result != '\0') {
        std::cout << "The first unique character is: " << result << std::endl;
    } else {
        std::cout << "No unique character found!" << std::endl;
    }

    std::cout << "Hello, World!\n";
    return 0;
}
