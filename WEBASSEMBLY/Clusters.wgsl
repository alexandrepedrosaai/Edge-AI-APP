const MATRIX_SIZE: u32 = 128;

@group(0) @binding(0)
var<storage, read> matrixA: array<f32>;

@group(0) @binding(1)
var<storage, read> matrixB: array<f32>;

@group(0) @binding(2)
var<storage, read_write> matrixOut: array<f32>;

fn sigmoid(x: f32) -> f32 {
    return 1.0 / (1.0 + exp(-x));
}

fn relu(x: f32) -> f32 {
    if (x > 0.0) { return x; }
    return 0.0;
}

fn wave_fn(x: f32, y: f32) -> f32 {
    return sin(x) + cos(y);
}

fn tanh_fn(x: f32) -> f32 {
    return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
}

@compute @workgroup_size(16, 16)
fn cluster_matrix_mul(@builtin(global_invocation_id) id: vec3<u32>) {
    let row = id.x;
    let col = id.y;

    var sum: f32 = 0.0;
    for (var k: u32 = 0u; k < MATRIX_SIZE; k = k + 1u) {
        sum = sum + matrixA[row * MATRIX_SIZE + k] * matrixB[k * MATRIX_SIZE + col];
    }
    matrixOut[row * MATRIX_SIZE + col] = sum;
}

@compute @workgroup_size(32)
fn cluster_neural(@builtin(global_invocation_id) id: vec3<u32>) {
    let neuron = id.x;
    let weighted = matrixA[neuron] * matrixB[neuron] + 0.5; // bias
    matrixOut[neuron] = sigmoid(weighted);
}

@compute @workgroup_size(64)
fn cluster_wave(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    matrixOut[i] = wave_fn(matrixA[i], matrixB[i]);
}

@compute @workgroup_size(64)
fn cluster_relu(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    matrixOut[i] = relu(matrixA[i]);
}

@compute @workgroup_size(64)
fn cluster_tanh(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    matrixOut[i] = tanh_fn(matrixA[i]);
}

@compute @workgroup_size(64)
fn cluster_combined(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    let val = matrixA[i] * 0.7 + matrixB[i] * 0.3;
    matrixOut[i] = tanh_fn(val);
}
