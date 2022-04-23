#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

/**
 * argv[1] -> number of tests
 * argv[2] ... argv[argc - 1] -> tables
 */
int main(int argc, char *argv[])
{
    int num_tests = stoi(argv[1]);

    vector<ifstream> inputTables;
    vector<ofstream> outputTablesHM;
    vector<ofstream> outputTablesMedian;
    for (int i = 2; i <= argc - 1; i++)
    {
        inputTables.push_back(ifstream(argv[i]));
        outputTablesHM.push_back(ofstream(string(argv[i]) + "_hm"));
        outputTablesMedian.push_back(ofstream(string(argv[i]) + "_median"));
    }
    for (int table = 0; table < inputTables.size(); table++)
    {
        for (int i = 5; i <= 32; i++)
        {
            vector<int> timings;
            int numCacheLines;
            for (int i = 0; i < num_tests; i++)
            {
                int temp;
                inputTables[table] >> numCacheLines >> temp;
                cout<<numCacheLines<<endl;
                timings.push_back(temp);
            }
            sort(timings.begin(), timings.end());
            double denominator = 0;
            for (auto &elem : timings)
            {
                denominator += 1.0 / elem;
            }
            double harmonic_mean = double(timings.size()) / denominator;
            int median = (timings[timings.size() / 2] + timings[timings.size() / 2 + 1]) / 2;
            outputTablesHM[table] << numCacheLines << " " << harmonic_mean << "\n";
            outputTablesMedian[table] << numCacheLines << " " << median << "\n";
        }
    }
}