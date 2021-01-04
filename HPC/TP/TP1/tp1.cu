#include <stdio.h> 
#include <time.h>


__global__ void VecAdd(float* A, float* B, float* C, int N)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < N)
        C[i] = A[i] + B[i];
}


int main() {
  int nDevices;

  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Max Grid size: %dx%d\n",  prop.maxGridSize[1], prop.maxGridSize[2]);
    printf("Max Thread Dim: %d,%d,%d\n", prop.maxThreadsDim[0], prop.maxThreadsDim[1], prop.maxThreadsDim[2]);
    printf("Max Thread per blocks: %d\n", prop.maxThreadsPerBlock);
    printf("Device Number: %d\n", i);
    printf("  Device name: %s\n", prop.name);
    printf("  Memory Clock Rate (KHz): %d\n",prop.memoryClockRate);
    printf("  Memory Bus Width (bits): %d\n",prop.memoryBusWidth);
    printf("  Peak Memory Bandwidth (GB/s): %f\n\n",2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
  }
  
  cudaSetDevice(0);

  int N = 300000;
  size_t size = N * sizeof(float);
  // Allocate input vectors h_A and h_B in host memory
  float* h_A = (float*)malloc(size);
  float* h_B = (float*)malloc(size);
  float* h_C = (float*)malloc(size);
  // Initialize input vectors
  for (int i =0; i<N;i++){
      h_A[i] =  i;
      h_B[i] = -i;
  }

  // Allocate vectors in device memory
  float* d_A;
  cudaMalloc(&d_A, size);
  float* d_B;
  cudaMalloc(&d_B, size);
  float* d_C;
  cudaMalloc(&d_C, size);



  cudaEvent_t start, stop,startcp,stopcp;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  cudaEventCreate(&startcp);
  cudaEventCreate(&stopcp);



  clock_t begin_cp = clock();
  cudaEventRecord(startcp);
  // Copy vectors from host memory to device memory
  cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
  int threadsPerBlock = 256;
  int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;

  clock_t begin = clock();
  cudaEventRecord(start);

  // Kernel
  VecAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N);
  cudaEventRecord(stop);
  clock_t end = clock();

  double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
  // Copy result from device memory to host memory
  // h_C contains the result in host memory
  cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
  
  cudaEventRecord(stopcp);
  clock_t end_cp = clock();
  double time_spent2 = (double)(end_cp - begin_cp) / CLOCKS_PER_SEC;

  cudaEventSynchronize(stop);
  cudaEventSynchronize(stopcp);
  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);

  float milliseconds2 = 0;
  cudaEventElapsedTime(&milliseconds2, startcp, stopcp);

  printf("elapsed time no\t cp GPU: %f\n",milliseconds);
  printf("elapsed time no\t cp CPU: %f\n",time_spent);

  printf("elapsed time with cp GPU: %f\n",milliseconds2);
  printf("elapsed time with cp CPU: %f",time_spent2);
  // Free device memory
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
}