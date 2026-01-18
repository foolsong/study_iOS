//
//  main.cpp
//  动态规划基础
//
//  Created by chenlina on 2025/6/20.
//

#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

// 1   1   2    3     5    8    13

int fib(int n) {
    if(n <= 1) {return 1;}
    int dp[n+1];
    dp[0] = 0;
    dp[1] = 1;
    for (int i = 2; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }
    return dp[n];
}


//  爬楼梯

int clim(int n) {
    if (n <= 2) {
        return n;
    }
    
    int a = 1;
    int b = 2;
    int c = 0;
    
    for (int i =  3; i <= n; i++) {
        c = a + b;
        b = c;
        a = b;
    }
    
    return c;
    
}

// 背包

void printf(vector<vector<int>> dp, int n, int W) {
    // 打印DP数组
       cout << "------------------------------------" << endl;
       for (int i = 0; i <= n; i++) {
           for (int j = 0; j <= W; j++) {
               cout << dp[i][j] << "\t";
           }
           cout << endl;
       }
       
}

int knapsack(int W, vector<int>& w, vector<int>& v) {
    int n = w.size();
    vector<vector<int>> dp(n + 1, vector<int>(W + 1, 0));
    
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= W; j++) {
            if (w[i-1] > j) {
                dp[i][j] = dp[i-1][j]; // 装不下
            } else {
                dp[i][j] = max(dp[i-1][j], dp[i-1][j-w[i-1]] + v[i-1]);
            }
            printf(dp, n, W);
        }
    }
    
    return dp[n][W];
}

int main() {
    int W = 5; // 背包容量
    vector<int> w = {2, 1, 3, 2}; // 物品重量
    vector<int> v = {12, 10, 20, 15}; // 物品价值
    
    int result = knapsack(W, w, v);
    cout << "最大价值: " << result << endl;
    
    return 0;
}



///  数组中连续数的最大乘积
int maxRes(vector<int> &arr) {
    if (arr.empty()) {
        return 0;
    }
    int max_p = arr[0];
    int min_p = arr[0];
    int res = arr[0];
    
    for (int j = 0; j < arr.size(); j++) {
        if (arr[j] < 0) {
            swap(max_p, min_p);
        }
        max_p = max(arr[j], arr[j] * max_p);
        min_p = min(arr[j], arr[j] * min_p);
    }
    res = max(res, max_p);
    return res;
}

// 公共子串

int pubStr(string &str1, string str2) {
    int m = (int)str1.length();
    int n =(int) str2.length();
    
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    
    int maxLen = 0;
    int endPos = 0;
    
    for (int i =  1; i <= m ; i++) {
        for (int j = 1; j <= n; i++) {
            if (str1[i] == str2[j]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
                
                if (dp[i][j] > maxLen) {
                    maxLen = dp[i][j];
                    endPos = i - 1;
                }
            } else {
                dp[i][j] =  0;
            }

            
        }
    }
    
    str1.substr(endPos - maxLen + 1 ,maxLen);
    
    return maxLen;
}
