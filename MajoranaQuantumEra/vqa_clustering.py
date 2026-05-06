# vqa_clustering.py  (com dataset real)
import numpy as np
from qutip import *
from scipy.optimize import minimize

# Dataset real gerado (3 clusters em 2D)
np.random.seed(42)
data = np.vstack([
    np.random.randn(8, 2) * 0.5 + np.array([0, 0]),
    np.random.randn(8, 2) * 0.5 + np.array([3, 3]),
    np.random.randn(8, 2) * 0.5 + np.array([-2, 4])
])

# Hamiltoniano de custo (Max-Cut style para clustering)
N = 4  # reduza pra simulação rápida
edges = [(0,1),(0,2),(1,3),(2,3)]
def build_cost_hamiltonian():
    H = 0 * tensor([qeye(2)] * N)
    for i,j in edges:
        zz = [qeye(2)] * N
        zz[i] = sigmaz(); zz[j] = sigmaz()
        H += 0.5 * tensor(zz)
    return H

H_cost = build_cost_hamiltonian()
mixer = sum([sigmax(j) for j in range(N)])

def qaoa_expectation(theta, p=2):
    gamma, beta = theta[:p], theta[p:]
    state = basis(2**N, 0)
    for i in range(p):
        state = (-1j * gamma[i] * H_cost).expm() * state
        state = (-1j * beta[i] * mixer).expm() * state
    return expect(H_cost, state)

res = minimize(lambda th: qaoa_expectation(th, p=3), np.random.rand(6), method='COBYLA')
print("Parâmetros otimizados:", res.x)
print("Custo final (melhor clustering):", res.fun)
