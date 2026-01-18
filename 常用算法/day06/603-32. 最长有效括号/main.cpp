//
//  main.cpp
//  603-32. 最长有效括号
//
//  Created by chenlina on 2025/3/12.
//

// 32. 最长有效括号

/**
 
 给你一个只包含 '(' 和 ')' 的字符串，找出最长有效（格式正确且连续）括号子串的长度。

  

 示例 1：

 输入：s = "(()"
 输出：2
 解释：最长有效括号子串是 "()"
 示例 2：

 输入：s = ")()())"
 输出：4
 解释：最长有效括号子串是 "()()"
 示例 3：

 输入：s = ""
 输出：0

 
 */

#include <iostream>
#include <stack>
#include <string>
#include <algorithm>
using namespace::std;

int longestValidParentheses(string s) {
    stack<int> stk;
    stk.push(-1);  // 初始栈，栈里存储的是下标
    int max_len = 0;

    for (int i = 0; i < s.length(); i++) {
        if (s[i] == '(') {
            stk.push(i);  // 入栈，记录 '(' 的索引
        } else {
            stk.pop();  // 弹出栈顶元素
            if (stk.empty()) {
                stk.push(i);  // 栈空时，记录当前 ')' 的位置
            } else {
                max_len = max(max_len, i - stk.top());  // 计算有效括号的长度
            }
        }
    }

    return max_len;
}

int longestValidParentheses2(string s) {
    int n = s.length();
    vector<int> dp(n, 0);  // dp[i] 表示以 s[i] 结尾的最长有效括号的长度
    int max_len = 0;

    for (int i = 1; i < n; i++) {
        if (s[i] == ')') {
            if (s[i - 1] == '(') {
                dp[i] = (i >= 2 ? dp[i - 2] : 0) + 2;  // s[i-1] 和 s[i] 是一对有效括号
            } else if (i - dp[i - 1] - 1 >= 0 && s[i - dp[i - 1] - 1] == '(') {
                dp[i] = dp[i - 1] + 2 + (i - dp[i - 1] - 2 >= 0 ? dp[i - dp[i - 1] - 2] : 0);
            }
            max_len = max(max_len, dp[i]);
        }
    }

    return max_len;
}


int main() {
    string s = "))))(()())";
    std::cout << "最长有效括号的长度是: " << longestValidParentheses(s) << std::endl;
    return 0;
}



