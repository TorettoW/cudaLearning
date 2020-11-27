#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime_api.h>
#include <iostream>
#include <device_launch_parameters.h>//在定义threadIdx时候需要用到的headfiles

__global__  void kernel(float * a) 
{
	a[ threadIdx.x] = 1;
}


int main(int argc, char **argv)
{
	cudaSetDevice(0);
	float* aGpu;
	cudaMalloc((void**)&aGpu,16* sizeof(float));//分配显存空间
	float a[16] = {0};//分配内存空间
	cudaMemcpy(aGpu, a, 16 * sizeof(float), cudaMemcpyHostToDevice);//将数据从内存拷贝到显存
	kernel << <1, 16 >> > (aGpu);
	cudaMemcpy(a, aGpu, 16 * sizeof(float), cudaMemcpyDeviceToHost);
	for (int i = 0; i < 16; i++) {
		std::cout << a[i] << std::endl;
	}
	cudaFree(aGpu);//释放显存空间
	cudaDeviceReset();
    
	int gpuCount = -1;
	cudaGetDeviceCount(&gpuCount);
	std::cout << std::endl;
	std::cout << gpuCount << std::endl;


}