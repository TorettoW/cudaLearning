#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime_api.h>
#include <iostream>
#include <device_launch_parameters.h>//�ڶ���threadIdxʱ����Ҫ�õ���headfiles

__global__  void kernel(float * a) 
{
	a[ threadIdx.x] = 1;
}


int main(int argc, char **argv)
{
	cudaSetDevice(0);
	float* aGpu;
	cudaMalloc((void**)&aGpu,16* sizeof(float));//�����Դ�ռ�
	float a[16] = {0};//�����ڴ�ռ�
	cudaMemcpy(aGpu, a, 16 * sizeof(float), cudaMemcpyHostToDevice);//�����ݴ��ڴ濽�����Դ�
	kernel << <1, 16 >> > (aGpu);
	cudaMemcpy(a, aGpu, 16 * sizeof(float), cudaMemcpyDeviceToHost);
	for (int i = 0; i < 16; i++) {
		std::cout << a[i] << std::endl;
	}
	cudaFree(aGpu);//�ͷ��Դ�ռ�
	cudaDeviceReset();
    
	int gpuCount = -1;
	cudaGetDeviceCount(&gpuCount);
	std::cout << std::endl;
	std::cout << gpuCount << std::endl;


}