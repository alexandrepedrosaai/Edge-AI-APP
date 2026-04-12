// kernel_all.cu
// Pacote de kernels CUDA básicos para CI/CD PTX

// 1. Soma de vetores
__global__ void kernel_vec_add(float *A, float *B, float *C, int N) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < N) {
        C[tid] = A[tid] + B[tid];
    }
}

// 2. Multiplicação de vetores
__global__ void kernel_vec_mul(float *A, float *B, float *C, int N) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < N) {
        C[tid] = A[tid] * B[tid];
    }
}

// 3. Multiplicação de matrizes
__global__ void kernel_mat_mul(float *A, float *B, float *C, int N) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < N && col < N) {
        float sum = 0.0f;
        for (int k = 0; k < N; k++) {
            sum += A[row * N + k] * B[k * N + col];
        }
        C[row * N + col] = sum;
    }
}

// 4. Redução paralela (soma de array)
__global__ void kernel_reduce_sum(float *input, float *output, int N) {
    extern __shared__ float sdata[];
    int tid = threadIdx.x;
    int i = blockIdx.x * blockDim.x + tid;

    sdata[tid] = (i < N) ? input[i] : 0.0f;
    __syncthreads();

    // redução em árvore
    for (int s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s) {
            sdata[tid] += sdata[tid + s];
        }
        __syncthreads();
    }

    if (tid == 0) output[blockIdx.x] = sdata[0];
}

// 5. Convolução 1D simples
__global__ void kernel_conv1d(float *signal, float *kernel, float *output, int N, int K) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < N) {
        float sum = 0.0f;
        for (int k = 0; k < K; k++) {
            int idx = tid + k;
            if (idx < N) {
                sum += signal[idx] * kernel[k];
            }
        }
        output[tid] = sum;
    }
}
