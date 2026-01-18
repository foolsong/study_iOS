//
//  main.cpp
//  L473火柴拼正方形
//
//  Created by yjsong on 2024/11/17.
//

/**
 你将得到一个整数数组 matchsticks ，其中 matchsticks[i] 是第 i 个火柴棒的长度。你要用 所有的火柴棍 拼成一个正方形。你 不能折断 任何一根火柴棒，但你可以把它们连在一起，而且每根火柴棒必须 使用一次 。

 如果你能使这个正方形，则返回 true ，否则返回 false 。
 */

#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>

using namespace std;

bool dfs(int index, vector<int> &matchsticks, vector<int> &edges, int len) {
    if (index == matchsticks.size()) {
        return true;
    }
    for(int i = 0; i < edges.size(); i++) {
        edges[i] += matchsticks[index];
        if (edges[i] <= len && dfs(index+1, matchsticks, edges, len)) {
            return true;
        }
        edges[i] -= matchsticks[index];
    }
    return false;
}

bool makesquare(vector<int>& matchsticks) {
    int sum = std::accumulate(matchsticks.begin(), matchsticks.end(), 0);
    if (sum % 4 != 0) {
        return false;
    }
    sort(matchsticks.begin(), matchsticks.end());
    vector<int> edges[4];
    return false;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
