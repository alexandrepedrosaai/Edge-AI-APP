import fs from "fs";
import { WASI } from "wasi";
import { instantiate } from "wasmtime-wasi";

// Carrega o binário WASM
const wasmBytes = fs.readFileSync("mega_math.wasm");

// Instancia
const wasi = new WASI({});
const { instance } = await WebAssembly.instantiate(wasmBytes, {
  wasi_snapshot_preview1: wasi.wasiImport
});

// Acessa memória e funções
const memory = instance.exports.memory;
const mat_mul = instance.exports.mat_mul;
const sin = instance.exports.sin;
const pi = instance.exports.pi;
const phi = instance.exports.phi;

// Helpers para ler/escrever floats
function writeMatrix(ptr, mat, N) {
  const buf = new DataView(memory.buffer);
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      const offset = ptr + (i * N + j) * 4;
      buf.setFloat32(offset, mat[i][j], true);
    }
  }
}

function readMatrix(ptr, N) {
  const buf = new DataView(memory.buffer);
  const mat = [];
  for (let i = 0; i < N; i++) {
    const row = [];
    for (let j = 0; j < N; j++) {
      const offset = ptr + (i * N + j) * 4;
      row.push(buf.getFloat32(offset, true));
    }
    mat.push(row);
  }
  return mat;
}

// Matrizes de exemplo
const A = [[1, 2], [3, 4]];
const B = [[5, 6], [7, 8]];
const N = 2;

// Ponteiros
const ptrA = 0;
const ptrB = N*N*4;
const ptrC = 2*N*N*4;

// Escreve matrizes
writeMatrix(ptrA, A, N);
writeMatrix(ptrB, B, N);

// Multiplica
mat_mul(ptrA, ptrB, ptrC, N);
const C = readMatrix(ptrC, N);
console.log("Matrix multiplication result:", C);

// Irracionais
console.log("π ≈", pi());
console.log("φ ≈", phi());

// Trigonometria
console.log("sin(π/4) ≈", sin(pi()/4));
