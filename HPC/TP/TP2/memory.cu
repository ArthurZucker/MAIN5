#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define PINMEMORY  0


// vecteur en mémoire globale
__device__   float b[7]         = {0.2316419f,0.3193815f,-0.3565638f,1.781478f,-1.821256f,1.330274f,0.3989423f};
__constant__ float constant_b[7]= {0.2316419f,0.3193815f,-0.3565638f,1.781478f,-1.821256f,1.330274f,0.3989423f};
__shared__ float shared_b[7];
__device__ float NP_r(float x);
__device__ float NP_g(float x);
__device__ float NP_s(float x);
__device__ float NP_c(float x);

__global__ void NP_register     (float *x, float *y, int N);
__global__ void NP_global       (float *x, float *y, int N);
__global__ void NP_constant     (float *x, float *y, int N);
__global__ void NP_global2      (float *x, float *y, int N);
__global__ void NP_shared       (float *x, float *y, int N);
// __global__ void NP_shared2      (float *x, float *y, int N);       

int main() {
  srand((unsigned int)time(NULL));
  int nDevices;
  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Max Grid size: %dx%d\n",  prop.maxGridSize[1], prop.maxGridSize[2]);
    printf("Max Thread Dim: %d,%d,%d\n", prop.maxThreadsDim[0], prop.maxThreadsDim[1], prop.maxThreadsDim[2]);
    printf("Max Thread per blocks: %d\n", prop.maxThreadsPerBlock);
    }
  
  cudaSetDevice(0);


  FILE *fptr=NULL;

  for (int k=2;k<1679000;k+=1000){
    int N = k;
    int threadsPerBlock = 1024;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
    size_t size = N * sizeof(float);

    // Allocate input vectors x and y in host memory
    float* x    = (float*)malloc(size);
    float* yS   = (float*)malloc(size);
    float* yS2  = (float*)malloc(size);
    float* yR   = (float*)malloc(size);
    float* yG   = (float*)malloc(size);
    float* yG2  = (float*)malloc(size);
    float* yC   = (float*)malloc(size);
    // Initialize input vectors
    for (int i =0; i<N;i++){
        x[i] =  (float)rand();
    }

    // Allocate vectors in device memory
    float* d_xg;
    float* d_yg;
    float* d_xr;
    float* d_yr;
    float* d_xs;
    float* d_ys;
    float* d_xc;
    float* d_yc;
    float* d_xs2;
    float* d_ys2;
    float* d_xg2;
    float* d_yg2;

    // CUDA malloc, page lock memory + pin memory 
    // global
    cudaMalloc(&d_xg, size);
    cudaMalloc(&d_yg, size);
    // global2
    cudaMalloc(&d_xg2, size);
    cudaMalloc(&d_yg2, size);
    // register
    cudaMalloc(&d_xr, size);
    cudaMalloc(&d_yr, size);
    // shared
    cudaMalloc(&d_xs, size);
    cudaMalloc(&d_ys, size);
    // shared2
    cudaMalloc(&d_xs2, size);
    cudaMalloc(&d_ys2, size);
    // constant
    cudaMalloc(&d_xc, size);
    cudaMalloc(&d_yc, size);
    
    #if PINMEMORY == 1
    cudaHostRegister(&d_xg2, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_xg, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_yg, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_yg2, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_xs, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_yr, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_xr, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_ys, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_xs2, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_ys2, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_yc, size,cudaHostRegisterDefault);
    cudaHostRegister(&d_xc, size,cudaHostRegisterDefault);
    #endif
    // Time measurment
    cudaEvent_t startR, stopR,startcp,stopcp,startG,stopG,startS,stopS,startC,stopC,startG2,stopG2,startS2,stopS2;
    cudaEventCreate(&startR);
    cudaEventCreate(&stopR);
    cudaEventCreate(&startcp);
    cudaEventCreate(&stopcp);
    cudaEventCreate(&startG);
    cudaEventCreate(&stopG);
    cudaEventCreate(&startS);
    cudaEventCreate(&stopS);
    cudaEventCreate(&startC);
    cudaEventCreate(&stopC);
    cudaEventCreate(&startG2);
    cudaEventCreate(&stopG2);
    cudaEventCreate(&startS2);
    cudaEventCreate(&stopS2);
    cudaEventRecord(startcp);
    // measure global time taken 

    // Copy vectors from host memory to device memory
    cudaMemcpy(d_xg, x, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_xr, x, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_xs, x, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_xc, x, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_xg2, x, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_xs2, x, size, cudaMemcpyHostToDevice);
    //-----------************ Kernel usage ************-----------//

    // Using registers
    cudaEventRecord(startR);
    NP_register<<<blocksPerGrid, threadsPerBlock>>>(d_xr, d_yr, N);
    cudaEventRecord(stopR);
    // End registers
    cudaMemcpy(yR, d_yr, size, cudaMemcpyDeviceToHost);              // first result, useless?

    
    // Using global
    cudaEventRecord(startG);
    NP_global<<<blocksPerGrid, threadsPerBlock>>>(d_xg, d_yg, N);
    cudaEventRecord(stopG);
    // End global
    cudaMemcpy(yG, d_yg, size, cudaMemcpyDeviceToHost);

    // Using global2
    cudaEventRecord(startG2);
    NP_global2<<<blocksPerGrid, threadsPerBlock>>>(d_xg2, d_yg2, N);
    cudaEventRecord(stopG2);
    // End global2
    cudaMemcpy(yG2, d_yg2, size, cudaMemcpyDeviceToHost);

    // Using shared
    cudaEventRecord(startS);
    NP_shared<<<blocksPerGrid, threadsPerBlock>>>(d_xs, d_ys, N);
    cudaEventRecord(stopS);
    // End shared
    cudaMemcpy(yS, d_ys, size, cudaMemcpyDeviceToHost);

//     // Using shared2
//     cudaEventRecord(startS2);
//     NP_shared2<<<blocksPerGrid, threadsPerBlock>>>(d_xs2, d_ys2, N);
//     cudaEventRecord(stopS2);
//     // End shared2
//     cudaMemcpy(yS2, d_ys2, size, cudaMemcpyDeviceToHost); 

    // Using constant
    cudaEventRecord(startC);
    NP_constant<<<blocksPerGrid, threadsPerBlock>>>(d_xc, d_yc, N);
    cudaEventRecord(stopC);
    // End constant
    cudaMemcpy(yC, d_yc, size, cudaMemcpyDeviceToHost);

    cudaEventRecord(stopcp);
    // End global time 


    cudaEventSynchronize(stopR);
    cudaEventSynchronize(stopcp);
    cudaEventSynchronize(stopG);
    cudaEventSynchronize(stopS);
    cudaEventSynchronize(stopC);
    //-----------************ End Kernel usage **********----------//

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, startR, stopR);

    float milliseconds2 = 0;
    cudaEventElapsedTime(&milliseconds2, startcp, stopcp);

    float milliseconds3 = 0;
    cudaEventElapsedTime(&milliseconds3, startG, stopG);

    float milliseconds4 = 0;
    cudaEventElapsedTime(&milliseconds4, startS, stopS);

    float milliseconds5 = 0;
    cudaEventElapsedTime(&milliseconds5, startC, stopC);

    float milliseconds6 = 0;
    cudaEventElapsedTime(&milliseconds6, startG2, stopG2);

//     float milliseconds6 = 0;
//     cudaEventElapsedTime(&milliseconds6, startS2, stopS2);

    // File writing
    fptr = fopen("results.txt","a");
    if(fptr == NULL){
        printf("Error in file opening!");   
        exit(1);             
    }
    fprintf(fptr,"%f,%f,%f,%f,%f\n",milliseconds,milliseconds3,milliseconds4,milliseconds5,milliseconds6);
    fclose(fptr);
    // End file writing
    printf("Iteration : %d\n",k-2);
    printf("Elapsed time : %f ms\n",milliseconds2);
    printf("Elapsed time : %.2f s\n" ,milliseconds2/1000);

//     printf("Checking answers %%\n");
//     for(int i=0;i<N;i++){
//             if(yS[i]!=yG[i] || yC[i]!=yR[i] || yC[i]!=yS[i] || yS[i]!=yR[i] || yG[i]!=yR[i]) {
//                 printf("Some answeres were wrong");
//                 exit(0);
//             }
//     }
//     printf("Done. Answers are correct %%\n");
    // Free device memory
    cudaFree(d_xg);
    cudaFree(d_yg);
    cudaFree(d_xr);
    cudaFree(d_yr);
  }
}

__device__ float NP_r(float x ){
        float p = 0.2316419f; 
        float b1 = 0.3193815f; 
        float b2 = -0.3565638f; 
        float b3 = 1.781478f; 
        float b4 = -1.821256f; 
        float b5 = 1.330274f; 
        float one_over_twopi = 0.3989423f; 
        float t; 
        if(x>=0.0f){
                t = 1.0f / ( 1.0f + p * x);
                return (1.0f - one_over_twopi * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*b5+b4)+b3)+b2)+b1) );
        }
        else {
            t = 1.0f /( 1.0f -p *x);
            return (one_over_twopi * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*b5+b4)+b3)+b2)+b1));
        }
}
      
      
__device__ float NP_g(float x){
        float t; 
        if(x>=0.0f){
                t = 1.0f / ( 1.0f + b[0] * x);
                return (1.0f - b[6] * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*b[5]+b[4])+b[3])+b[2])+b[1]) );
        }
        else {
            t = 1.0f /( 1.0f -b[0] *x);
            return (b[6] * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*b[5]+b[4])+b[3])+b[2])+b[1]));
        }
}
      
__device__ float NP_s(float x){
              float t; 
              if(x>=0.0f){
                      t = 1.0f / ( 1.0f + shared_b[0] * x);
                      return (1.0f - shared_b[6] * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*shared_b[5]+shared_b[4])+shared_b[3])+shared_b[2])+shared_b[1]) );
              }
              else {
                  t = 1.0f /( 1.0f -shared_b[0] *x);
                  return (shared_b[6] * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*shared_b[5]+shared_b[4])+shared_b[3])+shared_b[2])+shared_b[1]));
              }
}
  
__device__ float NP_c(float x){
        float t; 
        if(x>=0.0f){
                t = 1.0f / ( 1.0f + constant_b[0] * x);
                return (1.0f - constant_b[6] * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*constant_b[5]+constant_b[4])+constant_b[3])+constant_b[2])+constant_b[1]) );
        }
        else {
            t = 1.0f /( 1.0f -constant_b[0] *x);
            return (constant_b[6] * expf(-x * x / 2.0f) * t * (t*(t*(t*(t*constant_b[5]+constant_b[4])+constant_b[3])+constant_b[2])+constant_b[1]) );
        }
}


__global__ void NP_register(float *x, float *y, int N){
          int i = blockDim.x * blockIdx.x + threadIdx.x;
          if (i < N)
            y[i] = NP_r(x[i]);
}
      
__global__ void NP_global(float *x,float *y,int N){
  int i = blockDim.x * blockIdx.x + threadIdx.x;
  if (i < N) y[i] = NP_g(x[i]);
}
      
      
__global__ void NP_constant(float *x,float *y,int N){
  int i = blockDim.x * blockIdx.x + threadIdx.x;
  if (i < N) y[i] = NP_c(x[i]);         
}
      
__global__ void NP_shared(float *x,float *y,int N){
              int i = blockDim.x * blockIdx.x + threadIdx.x;
              if (i < 7) shared_b[i] = b[i];
              __syncthreads(); //wait for the 7 threads to have loaded in the shared memory 
              if (i < N) y[i] = NP_s(x[i]);
}
/*__global__ void NP_shared2(float *x,float *y,int N){
        int i = blockDim.x * blockIdx.x + threadIdx.x;
        cooperative_groups::thread_block block = cooperative_groups::this_thread_block();
        pipeline pipe;
        if (i < 7){
                memcpy_async(shared_b[i], b[i], pipe ); // Async-Copy Dispatch
                pipe.commit_and_wait(); //wait for the 7 threads to have loaded in the shared memory
        } 
        block.sync();
        if (i < N) y[i] = NP_s(x[i]);
        block.sync();
}*/

__global__ void NP_global2(float *x,float *y,int N){
        int i = blockDim.x * blockIdx.x + threadIdx.x;
        if (i < N) y[i] = NP_g(__ldg(&x[i]));         
      }