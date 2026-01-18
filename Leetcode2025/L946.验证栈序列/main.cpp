//
//  main.cpp
//  L946.验证栈序列
//
//  Created by yjsong on 2024/11/16.
//


/**
     给定 pushed 和 popped 两个序列，每个序列中的 值都不重复，只有当它们可能是在最初空栈上进行的推入 push 和弹出 pop 操作序列的结果时，返回 true；否则，返回 false 。

     输入：pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
     输出：true
     解释：我们可以按以下顺序执行：
     push(1), push(2), push(3), push(4), pop() -> 4,
     push(5), pop() -> 5, pop() -> 3, pop() -> 2, pop() -> 1
 */

#include <iostream>
#include <vector>
#include <stack>

using namespace std;

bool validateStackSequences(vector<int>& pushed, vector<int>& popped) {
    std::stack<int> S;
    
    int index = 0;
    for(int i = 0; i < pushed.size(); i++) {
        S.push(pushed[i]);
        while (!S.empty() && popped[index] == S.top()) {
            S.pop();
            index++;
        }
    }
    if (S.empty()) {
        return true;
    } else {
        return false;
    }
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
