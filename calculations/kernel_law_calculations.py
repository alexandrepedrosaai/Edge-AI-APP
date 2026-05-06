
import numpy as np
from scipy.linalg import null_space

# --- Kernel of a Linear Transformation (Null Space of a Matrix) ---
# The kernel (or null space) of a linear transformation L: V -> W is the set of all vectors v in V
# such that L(v) = 0, where 0 is the zero vector in W.
# For a matrix A, the null space is the set of all vectors x such that Ax = 0.

# Example 1: A simple 2x2 matrix
A1 = np.array([
    [1, 2],
    [2, 4]
])

print("Matrix A1:")
print(A1)

# Calculate the null space (kernel) of A1
# The columns of null_space(A) form an orthonormal basis for the null space of A.
ns1 = null_space(A1)

print("\nNull space (kernel) of A1:")
print(ns1)

# Verification: A1 @ ns1 should be approximately zero
print("Verification (A1 @ ns1):")
print(A1 @ ns1)

# Example 2: A 3x3 matrix
A2 = np.array([
    [1, 1, 1],
    [0, 1, 2],
    [1, 0, -1]
])

print("\nMatrix A2:")
print(A2)

# Calculate the null space (kernel) of A2
ns2 = null_space(A2)

print("\nNull space (kernel) of A2:")
print(ns2)

# Verification: A2 @ ns2 should be approximately zero
print("Verification (A2 @ ns2):")
print(A2 @ ns2)

# Example 3: A matrix with only the zero vector in its null space
A3 = np.array([
    [1, 0],
    [0, 1]
])

print("\nMatrix A3:")
print(A3)

ns3 = null_space(A3)

print("\nNull space (kernel) of A3:")
print(ns3)

# Verification: A3 @ ns3 should be approximately zero
print("Verification (A3 @ ns3):")
print(A3 @ ns3)
