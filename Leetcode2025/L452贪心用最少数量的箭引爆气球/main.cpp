//
//  main.cpp
//  L452贪心用最少数量的箭引爆气球
//
//  Created by yjsong on 2024/11/16.
//

#include <iostream>
#include <vector>

using namespace std;

bool cmp(const vector<int> &a, const vector<int> &b) {
    return a[0] < b[0];
}

int findMinArrowShots(vector<vector<int>>& points) {
    if (points.size() <= 0) {
        return 0;
    }
    std::sort(points.begin(), points.end(), cmp);
    int arrowCount = 1;
    int indexRight = points[0][1];
    
    for(int i = 1; i < points.size(); i++) {
        if (indexRight >= points[i][0]) {
            if (indexRight > points[i][1]) {
                indexRight = points[i][1];
            }
        } else {
            arrowCount ++;
            indexRight = points[i][1];
        }
    }
    return arrowCount;
}



int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
