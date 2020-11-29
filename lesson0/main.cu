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
	int gpuCount = -1;
	cudaGetDeviceCount(&gpuCount);
	std::cout << "GPU number:" << gpuCount << std::endl;
	if (gpuCount < 0)
		std::cout << "No device to use" << std::endl;

	cudaSetDevice(gpuCount-1);
	int deviceID;
	cudaGetDevice(&deviceID);
	std::cout << "deviceID :" << deviceID << std::endl;
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
    
	cudaDeviceProp pro;//显卡的一些信息
	cudaGetDeviceProperties(&pro,0);
	std::cout<<"maxThreadperBlock:"<<pro.maxThreadsPerBlock <<std::endl;
	std::cout << "maxThreadsDim:" << pro.maxThreadsDim << std::endl;
	std::cout << "maxGridSize:" << pro.maxGridSize << std::endl;
	std::cout << "totalConstMem:" << pro.totalConstMem << std::endl;
	std::cout << "clockRate:" << pro.clockRate << std::endl;
	std::cout << "Intergrated:" << pro.integrated << std::endl;
}

//经历7个步骤：
//设置显卡设备
//分配显存空间
//拷贝数据从内存到显存
//执行并行函数
//将结果从显存拷回内存
//释放显存空间cudaFree
//设备重置