
import numpy as np

# --- Quantum Superposition (Simplified) ---
# Representing a quantum state as a superposition of two basis states
# For example, a qubit in a superposition of |0> and |1>

# Coefficients for the superposition state |psi> = a|0> + b|1>
# where |a|^2 + |b|^2 = 1

a = 1 / np.sqrt(2)
b = 1 / np.sqrt(2)

# The quantum state vector
psi = np.array([a, b])

print(f"Simplified Quantum State (Superposition): {psi}")
print(f"Probability of measuring |0>: {np.abs(psi[0])**2:.2f}")
print(f"Probability of measuring |1>: {np.abs(psi[1])**2:.2f}")

# --- Heisenberg Uncertainty Principle (Conceptual) ---
# This principle states that certain pairs of physical properties, like position and momentum,
# cannot both be known to high precision simultaneously.
# Mathematically, it's expressed as: sigma_x * sigma_p >= h_bar / 2
# where sigma_x is uncertainty in position, sigma_p is uncertainty in momentum, and h_bar is the reduced Planck constant.

h_bar = 1.0545718e-34 # Reduced Planck constant (J*s)

# Example: If we know position with high precision (low uncertainty in x)
uncertainty_x = 1e-10 # meters
min_uncertainty_p = h_bar / (2 * uncertainty_x)
print(f"\nIf uncertainty in position (sigma_x) is {uncertainty_x:.1e} m, then minimum uncertainty in momentum (sigma_p) is {min_uncertainty_p:.2e} kg*m/s.")

# Example: If we know momentum with high precision (low uncertainty in p)
uncertainty_p = 1e-25 # kg*m/s
min_uncertainty_x = h_bar / (2 * uncertainty_p)
print(f"If uncertainty in momentum (sigma_p) is {uncertainty_p:.1e} kg*m/s, then minimum uncertainty in position (sigma_x) is {min_uncertainty_x:.2e} m.")
