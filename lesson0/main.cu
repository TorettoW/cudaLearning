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
    
	cudaDeviceProp pro;//�Կ���һЩ��Ϣ
	cudaGetDeviceProperties(&pro,0);
	std::cout<<"maxThreadperBlock:"<<pro.maxThreadsPerBlock <<std::endl;
	std::cout << "maxThreadsDim:" << pro.maxThreadsDim << std::endl;
	std::cout << "maxGridSize:" << pro.maxGridSize << std::endl;
	std::cout << "totalConstMem:" << pro.totalConstMem << std::endl;
	std::cout << "clockRate:" << pro.clockRate << std::endl;
	std::cout << "Intergrated:" << pro.integrated << std::endl;
}

//����7�����裺
//�����Կ��豸
//�����Դ�ռ�
//�������ݴ��ڴ浽�Դ�
//ִ�в��к���
//��������Դ濽���ڴ�
//�ͷ��Դ�ռ�cudaFree
//�豸����