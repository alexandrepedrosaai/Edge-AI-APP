"""
GNN Module
Graph Neural Network (GNN) for Edge-AI-APP.
Provides graph-based data relationship modeling for CPU/GPU/NPU execution.
"""

import sys
import json
import math


def build_adjacency_matrix(edges, num_nodes):
    """Build an adjacency matrix from edge list."""
    adj = [[0.0] * num_nodes for _ in range(num_nodes)]
    for src, dst in edges:
        adj[src][dst] = 1.0
        adj[dst][src] = 1.0
    return adj


def normalize_adjacency(adj):
    """Degree-normalize the adjacency matrix (symmetric normalization)."""
    n = len(adj)
    degree = [sum(adj[i]) + 1 for i in range(n)]  # +1 for self-loop
    norm_adj = [[0.0] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            if adj[i][j] != 0 or i == j:
                norm_adj[i][j] = adj[i][j] / math.sqrt(degree[i] * degree[j])
    return norm_adj


def relu(x):
    return max(0.0, x)


def matmul(A, B):
    """Simple matrix multiplication."""
    rows_A, cols_A = len(A), len(A[0])
    cols_B = len(B[0])
    result = [[0.0] * cols_B for _ in range(rows_A)]
    for i in range(rows_A):
        for j in range(cols_B):
            for k in range(cols_A):
                result[i][j] += A[i][k] * B[k][j]
    return result


def gcn_layer(adj, features, weights):
    """Single GCN layer: A_hat * X * W with ReLU."""
    ax = matmul(adj, features)
    axw = matmul(ax, weights)
    return [[relu(v) for v in row] for row in axw]


def main():
    print("Initializing GNN module...")

    # Example: 5-node graph
    num_nodes = 5
    edges = [(0, 1), (0, 2), (1, 3), (2, 3), (3, 4)]
    feature_dim = 4
    hidden_dim = 3

    # Random-like deterministic features
    features = [
        [(i + j * 0.1) % 1.0 for j in range(feature_dim)] for i in range(num_nodes)
    ]

    # Deterministic weights
    weights_l1 = [
        [(i * 0.2 + j * 0.1) % 1.0 for j in range(hidden_dim)]
        for i in range(feature_dim)
    ]

    adj = build_adjacency_matrix(edges, num_nodes)
    norm_adj = normalize_adjacency(adj)

    print(f"Graph: {num_nodes} nodes, {len(edges)} edges")
    print("Running GCN forward pass...")

    hidden = gcn_layer(norm_adj, features, weights_l1)

    print("Node embeddings (hidden layer):")
    for i, emb in enumerate(hidden):
        formatted = [f"{v:.4f}" for v in emb]
        print(f"  Node {i}: [{', '.join(formatted)}]")

    output = {
        "module": "GNN",
        "version": "1.0.0",
        "graph": {"nodes": num_nodes, "edges": len(edges)},
        "embedding_dim": hidden_dim,
        "status": "success",
    }
    print("\nGNN JSON output:")
    print(json.dumps(output, indent=2))

    print("\nGNN module completed successfully.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
