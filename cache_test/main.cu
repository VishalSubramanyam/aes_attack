#include <iostream>
#include <fstream>
#include <algorithm>
using namespace std;
int numCacheLines = 6; // num of blocks
int stride = 64;       // value for the cache line size
int const max_space = sizeof(int) * 32; // allocating space for 32 different indices, each index is of type int
__device__ long long int tempVar = 0;
__global__ void testKernel(char *A, int *indices, char *result, int *_time)
{
    int index = indices[threadIdx.x];
    *_time = clock();
    result[threadIdx.x] = A[index];
    *_time = clock() - *_time;
}

__global__ void clearKernel(int *B)
{
    int result = B[threadIdx.x];
    tempVar += result;
}

// generating all the indices
void setIndices(int *local_indices)
{
    int curCacheLineIndex = 0;
    for (int i = 1; i <= 32; i++)
    {
        local_indices[i - 1] = curCacheLineIndex * stride;
        if (curCacheLineIndex < numCacheLines - 1)
        {
            curCacheLineIndex++;
        }
    }
    random_shuffle(local_indices, local_indices + 32);
}

/**
 * Command-line args:
 * argv[1] -> stride (32, 64, 128)
 * argv[2] -> output file
 * argv[3] -> number of tests
 */
int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        cerr << "Need 2 arguments" << endl;
        return -1;
    }
    stride = stoi(argv[1]);
    ofstream outputTable(argv[2]);
    int num_tests = stoi(argv[3]);

    char *A;
    int *indices;
    char *result;
    int *_time;
    cudaMalloc((char **)&A, 10 * 1024 * 1024); // Allocating 10 MiB
    cudaMalloc((int **)&indices, max_space);  // 32 indices for 32 threads at most
    cudaMalloc((char **)&result, max_space);   // same logic as above
    cudaMalloc((int **)&_time, sizeof(int));
    cudaMemset(indices, 0, max_space);
    int *local_indices = (int *)malloc(max_space);

    int *garbage;
    cudaMalloc((int **)&garbage, 10 * 1024 * 1024); // Allocating 10MiB of garbage

    for (int j = 5; j <= 32; j++)
    {
        numCacheLines = j;
        for (int i = 0; i < num_tests; i++)
        {
            memset(local_indices, 0, max_space);
            setIndices(local_indices);
            cudaMemcpy(indices, local_indices, max_space, cudaMemcpyHostToDevice);
            clearKernel<<<1, 32>>>(garbage); // warm up GPU
            testKernel<<<1, 32>>>(A, indices, result, _time);
            cudaDeviceSynchronize();
            int local_time;
            cudaMemcpy(&local_time, _time, sizeof(int), cudaMemcpyDeviceToHost);
            outputTable << j << " " << local_time << endl;
        }
    }

    cudaFree(A);
    cudaFree(result);
    cudaFree(indices);
    cudaFree(_time);
}