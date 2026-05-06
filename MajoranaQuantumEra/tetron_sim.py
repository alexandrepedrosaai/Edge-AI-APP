# tetron_sim.py
import numpy as np
from qutip import *
import matplotlib.pyplot as plt

def tetron_hamiltonian(t=1.0, Delta=1.0, mu=0.0):
    """Modelo simplificado de 4 Majoranas (Tetron)"""
    H = 0 * tensor([qeye(2)] * 4)
    # On-site
    for i in range(4):
        ops = [qeye(2)] * 4
        ops[i] = sigmaz()
        H += -mu * tensor(ops)
    # Pairings e hopping entre Majoranas do Tetron
    pairs = [(0,1), (2,3), (0,2), (1,3)]
    for i,j in pairs:
        xx = [qeye(2)] * 4; xx[i] = sigmax(); xx[j] = sigmax()
        yy = [qeye(2)] * 4; yy[i] = sigmay(); yy[j] = sigmay()
        H += -t * (tensor(xx) + tensor(yy))
        H += Delta * tensor([sigmax() if k==i else sigmay() if k==j else qeye(2) for k in range(4)])
    return H

H = tetron_hamiltonian(mu=0.0)
evals = np.real(np.sort(H.eigenenergies()))
print("Energias do Tetron:", np.round(evals, 6))
print("Zero modes presentes:", any(abs(e) < 1e-5 for e in evals))

plt.figure(figsize=(8,5))
plt.plot(evals, 'ro-', label='Espectro Tetron')
plt.axhline(0, color='green', linestyle='--', label='Majorana Zero Modes')
plt.title('Espectro de Energia - Tetron (4 Majoranas)')
plt.xlabel('Estado')
plt.ylabel('Energia')
plt.legend()
plt.grid(True)
plt.show()
