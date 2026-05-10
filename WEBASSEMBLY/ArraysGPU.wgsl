struct Tensor {
    shape: vec2<u32>;              // dimensions (rows, cols)
    values: array<f32>;            // tensor data
};

@group(0) @binding(0)
var<storage, read_write> tensorA: Tensor;

@group(0) @binding(1)
var<storage, read_write> tensorB: Tensor;

@group(0) @binding(2)
var<storage, read_write> tensorOut: Tensor;

// Activation functions
fn relu(x: f32) -> f32 {
    if (x > 0.0) { return x; }
    return 0.0;
}

fn sigmoid(x: f32) -> f32 {
    return 1.0 / (1.0 + exp(-x));
}

fn tanh_fn(x: f32) -> f32 {
    return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
}

fn softmax(x: f32, sum: f32) -> f32 {
    return exp(x) / sum;
}

@compute @workgroup_size(64)
fn add_tensors(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    tensorOut.values[i] = tensorA.values[i] + tensorB.values[i];
}

@compute @workgroup_size(64)
fn mul_tensors(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    tensorOut.values[i] = tensorA.values[i] * tensorB.values[i];
}

@compute @workgroup_size(64)
fn relu_tensor(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    tensorOut.values[i] = relu(tensorA.values[i]);
}

@compute @workgroup_size(64)
fn sigmoid_tensor(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    tensorOut.values[i] = sigmoid(tensorA.values[i]);
}

@compute @workgroup_size(64)
fn tanh_tensor(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    tensorOut.values[i] = tanh_fn(tensorA.values[i]);
}

@compute @workgroup_size(64)
fn normalize_tensor(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    let maxVal = 100.0; // placeholder
    tensorOut.values[i] = tensorA.values[i] / maxVal;
}

@compute @workgroup_size(64)
fn softmax_tensor(@builtin(global_invocation_id) id: vec3<u32>) {
    let i = id.x;
    var sum: f32 = 0.0;
    for (var j: u32 = 0u; j < tensorA.shape.x * tensorA.shape.y; j = j + 1u) {
        sum = sum + exp(tensorA.values[j]);
    }
    tensorOut.values[i] = softmax(tensorA.values[i], sum);
}
