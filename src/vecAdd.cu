// vecAdd.cu
__global__ void vecAdd(float *A, float *B, float *C, int N) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < N) {
        C[tid] = A[tid] + B[tid];
    }
}
