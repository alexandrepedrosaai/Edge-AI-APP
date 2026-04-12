// kernel_dl.cu
// Conjunto de kernels CUDA para operações de DL

// Convolução 2D
__global__ void kernel_conv2d(float *input, float *filter, float *output,
                              int H, int W, int FH, int FW) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < H && col < W) {
        float sum = 0.0f;
        for (int i = 0; i < FH; i++) {
            for (int j = 0; j < FW; j++) {
                int r = row + i;
                int c = col + j;
                if (r < H && c < W) {
                    sum += input[r * W + c] * filter[i * FW + j];
                }
            }
        }
        output[row * W + col] = sum;
    }
}

// Softmax
__global__ void kernel_softmax(float *input, float *output, int N) {
    extern __shared__ float sdata[];
    int tid = threadIdx.x;
    if (tid < N) {
        float max_val = input[0];
        for (int i = 1; i < N; i++) {
            if (input[i] > max_val) max_val = input[i];
        }
        float sum = 0.0f;
        for (int i = 0; i < N; i++) {
            sdata[i] = expf(input[i] - max_val);
            sum += sdata[i];
        }
        output[tid] = sdata[tid] / sum;
    }
}

// Atenção simplificada
__global__ void kernel_attention(float *Q, float *K, float *V, float *O,
                                 int N, int D) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < N && col < D) {
        float score = 0.0f;
        for (int k = 0; k < D; k++) {
            score += Q[row * D + k] * K[col * D + k];
        }
        O[row * D + col] = score * V[col * D + col];
    }
}
