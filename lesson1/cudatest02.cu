#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime_api.h>
#include <iostream>
#include <device_launch_parameters.h>//在定义threadIdx时候需要用到的headfiles
using namespace std;

__global__  void add(int *a , int *b , int * c ,int num)
{
	int i = threadIdx.x;
	if (i < num) {
		c[i] = a[i] + b[i];
	}
}

int main(void) {
	//init data
	const int num = 10;
	int a[num], b[num], c[num];
	int *a_gpu, *b_gpu, *c_gpu;
	for (int i = 0; i < num; i++) {
		a[i] = i;
		b[i] = i * i;
	}
	cudaMalloc((void **)&a_gpu, num * sizeof(int));
	cudaMalloc((void**)&b_gpu, num * sizeof(int));
	cudaMalloc((void**)&c_gpu, num * sizeof(int));
	//copy data to GPU
	cudaMemcpy(a_gpu, a, num*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(b_gpu, b, num * sizeof(int), cudaMemcpyHostToDevice);
	//do 
	add << <1, num >> > (a_gpu,b_gpu, c_gpu,num);

	cudaMemcpy(c, c_gpu, num * sizeof(int), cudaMemcpyDeviceToHost);
	//
	for (int i = 0; i < num; i++) {
		cout << a[i] << " + " << b[i] << " = " << c[i] << endl;
	}
	return 0;
}