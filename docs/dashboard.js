// dashboard.js - visualização 3D + métricas + gráfico
import { initArraysGPU, readBuffer } from './arraysGPU.js';

export async function renderDashboard() {
  const { device, buffers } = await initArraysGPU();

  // Configuração inicial do canvas WebGL/WebGPU
  const canvas = document.getElementById('dashboard');
  const gl = canvas.getContext('webgl');
  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.clear(gl.COLOR_BUFFER_BIT);

  // Renderização simples de métricas
  const metrics = {
    blue: await readBuffer(device, buffers.blue, 2048),
    green: await readBuffer(device, buffers.green, 4096),
    red: await readBuffer(device, buffers.red, 8192),
    quantum: await readBuffer(device, buffers.quantum, 16384)
  };

  // Exibe métricas no console
  console.log("Cluster Azul:", metrics.blue.slice(0, 10));
  console.log("Cluster Verde:", metrics.green.slice(0, 10));
  console.log("Cluster Vermelho:", metrics.red.slice(0, 10));
  console.log("Cluster Quântico:", metrics.quantum.slice(0, 10));

  // Gráfico simples em 2D
  const ctx = canvas.getContext('2d');
  ctx.fillStyle = 'blue';
  ctx.fillRect(10, 10, metrics.blue[0] % 100, 20);
  ctx.fillStyle = 'green';
  ctx.fillRect(10, 40, metrics.green[0] % 100, 20);
  ctx.fillStyle = 'red';
  ctx.fillRect(10, 70, metrics.red[0] % 100, 20);
  ctx.fillStyle = 'purple';
  ctx.fillRect(10, 100, metrics.quantum[0] % 100, 20);
}
