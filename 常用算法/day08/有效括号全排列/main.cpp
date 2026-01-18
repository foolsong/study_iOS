//
//  main.cpp
//  有效括号全排列
//
//  Created by chenlina on 2025/4/23.
//

#include <iostream>
#include <vector>
#include <string>

using namespace::std;

void genParisHelp(int open, int close, string current, vector<string> &res) {
    if (open == 0 && close == 0) {
        res.push_back(current);
        return;
    }
    if (open > 0) {
        genParisHelp(open - 1, close, current + "(", res);
    }
    if (close > open) {
        genParisHelp(open, close - 1, current + ")", res);
    }
}

vector<string>genPar(int n) {
    vector<string> res;
    genParisHelp(n, n, "", res);
    return res;
}

int main(int argc, const char * argv[]) {
    int n = 11;
       vector<string> validParentheses = genPar(n);
       
    cout << "All valid parentheses combinations for n=" << n << validParentheses.size()  <<":" << endl;
       for (const string& s : validParentheses) {
           cout << s << endl;
       }
       
       return 0;
}
