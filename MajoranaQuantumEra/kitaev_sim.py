# kitaev_sim.py
import numpy as np
from qutip import *
import matplotlib.pyplot as plt

def kitaev_hamiltonian(N, t=1.0, Delta=1.0, mu=0.0):
    H = 0 * tensor([qeye(2)] * N)
    for j in range(N):
        ops = [qeye(2)] * N
        ops[j] = sigmaz()
        H += -mu * tensor(ops)
    for j in range(N-1):
        xx = [qeye(2)] * N; xx[j] = sigmax(); xx[j+1] = sigmax()
        H += -t * tensor(xx)
        yy = [qeye(2)] * N; yy[j] = sigmay(); yy[j+1] = sigmay()
        H += -t * tensor(yy)
        xy = [qeye(2)] * N; xy[j] = sigmax(); xy[j+1] = sigmay()
        H += Delta * tensor(xy)
        yx = [qeye(2)] * N; yx[j] = sigmay(); yx[j+1] = sigmax()
        H += -Delta * tensor(yx)
    return H

# Rodar simulação
N = 6
H_topo = kitaev_hamiltonian(N, mu=0.0)
evals = np.real(np.sort(H_topo.eigenenergies()))
print("Zero modes aproximados:", [round(e,6) for e in evals if abs(e) < 0.01])

# Gráfico (já gerado acima)
mu_values = np.linspace(-3.0, 3.0, 61)
min_gaps = [np.min(np.abs(kitaev_hamiltonian(N, mu=mu).eigenenergies())) for mu in mu_values]

plt.figure(figsize=(10,6))
plt.plot(mu_values, min_gaps, 'bo-', linewidth=2)
plt.axvspan(-2, 2, alpha=0.25, color='green', label='Fase Topológica')
plt.title('Kitaev Chain - Majorana Zero Modes')
plt.xlabel('μ / t')
plt.ylabel('Menor |Energia|')
plt.legend()
plt.grid(True)
plt.show()
