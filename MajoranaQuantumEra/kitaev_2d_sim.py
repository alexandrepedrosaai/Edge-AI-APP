# kitaev_2d_sim.py
import numpy as np
from qutip import *
import matplotlib.pyplot as plt

def kitaev_2d_hamiltonian(Lx, Ly, t=1.0, Delta=1.0, mu=0.0):
    """Hamiltoniano Kitaev em grade 2D (simplificado)"""
    N = Lx * Ly
    H = 0 * tensor([qeye(2)] * N)
    idx = lambda x, y: (x % Lx) + (y % Ly) * Lx
    
    for y in range(Ly):
        for x in range(Lx):
            i = idx(x, y)
            # Termo on-site
            ops = [qeye(2)] * N
            ops[i] = sigmaz()
            H += -mu * tensor(ops)
            
            # Hopping e pairing horizontal
            j = idx(x+1, y)
            H += -t * (tensor([sigmax() if k in (i,j) else qeye(2) for k in range(N)]) +
                       tensor([sigmay() if k in (i,j) else qeye(2) for k in range(N)]))
            H += Delta * (tensor([sigmax() if k==i else sigmay() if k==j else qeye(2) for k in range(N)]) -
                          tensor([sigmay() if k==i else sigmax() if k==j else qeye(2) for k in range(N)]))
            
            # Hopping e pairing vertical
            jv = idx(x, y+1)
            H += -t * (tensor([sigmax() if k in (i,jv) else qeye(2) for k in range(N)]) +
                       tensor([sigmay() if k in (i,jv) else qeye(2) for k in range(N)]))
            H += Delta * (tensor([sigmax() if k==i else sigmay() if k==jv else qeye(2) for k in range(N)]) -
                          tensor([sigmay() if k==i else sigmax() if k==jv else qeye(2) for k in range(N)]))
    
    return H

# Simulação pequena (Lx=3, Ly=3)
Lx, Ly = 3, 3
H2d = kitaev_2d_hamiltonian(Lx, Ly, mu=0.0)
evals = np.real(np.sort(H2d.eigenenergies()))
print("Energias em 2D (μ=0):")
print(np.round(evals[:8], 6))

# Gráfico de espectro
plt.figure(figsize=(10,6))
plt.plot(range(len(evals)), evals, 'bo-', label='Energias')
plt.axhline(0, color='red', linestyle='--', label='Zero Modes')
plt.title('Espectro Majorana em Rede 2D (Kitaev)')
plt.xlabel('Índice da energia')
plt.ylabel('Energia')
plt.legend()
plt.grid(True)
plt.show()
