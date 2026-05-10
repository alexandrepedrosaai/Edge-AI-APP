// arraysGPU.js - inicialização e expansão dos buffers GPU
export async function initArraysGPU() {
  const adapter = await navigator.gpu.requestAdapter();
  const device = await adapter.requestDevice();

  // Cria múltiplos arraysGPU para clusters expandidos
  const buffers = {
    blue: device.createBuffer({ size: 2048, usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC }),
    green: device.createBuffer({ size: 4096, usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC }),
    red: device.createBuffer({ size: 8192, usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC }),
    quantum: device.createBuffer({ size: 16384, usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC })
  };

  return { device, buffers };
}

// Função auxiliar para escrever dados nos buffers
export async function writeBuffer(device, buffer, data) {
  const arrayBuffer = new ArrayBuffer(data.length * 4);
  const view = new Uint32Array(arrayBuffer);
  view.set(data);
  device.queue.writeBuffer(buffer, 0, arrayBuffer);
}

// Função auxiliar para ler dados dos buffers
export async function readBuffer(device, buffer, size) {
  const readBuffer = device.createBuffer({
    size,
    usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.MAP_READ
  });
  const commandEncoder = device.createCommandEncoder();
  commandEncoder.copyBufferToBuffer(buffer, 0, readBuffer, 0, size);
  device.queue.submit([commandEncoder.finish()]);
  await readBuffer.mapAsync(GPUMapMode.READ);
  const arrayBuffer = readBuffer.getMappedRange();
  const result = new Uint32Array(arrayBuffer.slice(0));
  readBuffer.unmap();
  return result;
}
