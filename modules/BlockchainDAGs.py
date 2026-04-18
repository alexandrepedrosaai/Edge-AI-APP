"""
BlockchainDAGs Module
Distributed transaction and state graph (DAG) for Edge-AI-APP.
Simulates a DAG-based blockchain with hash chaining and state verification.
"""

import sys
import json
import hashlib
import time


class Transaction:
    def __init__(self, tx_id, sender, receiver, amount, timestamp=None):
        self.tx_id = tx_id
        self.sender = sender
        self.receiver = receiver
        self.amount = amount
        self.timestamp = timestamp or time.time()

    def to_dict(self):
        return {
            "tx_id": self.tx_id,
            "sender": self.sender,
            "receiver": self.receiver,
            "amount": self.amount,
            "timestamp": self.timestamp,
        }

    def hash(self):
        data = json.dumps(self.to_dict(), sort_keys=True)
        return hashlib.sha256(data.encode()).hexdigest()


class DAGNode:
    def __init__(self, node_id, transaction, parents=None):
        self.node_id = node_id
        self.transaction = transaction
        self.parents = parents or []  # list of parent node_ids
        self.hash = self._compute_hash()

    def _compute_hash(self):
        content = {
            "node_id": self.node_id,
            "tx_hash": self.transaction.hash(),
            "parents": sorted(self.parents),
        }
        data = json.dumps(content, sort_keys=True)
        return hashlib.sha256(data.encode()).hexdigest()

    def to_dict(self):
        return {
            "node_id": self.node_id,
            "hash": self.hash[:16] + "...",
            "parents": self.parents,
            "transaction": self.transaction.to_dict(),
        }


class BlockchainDAG:
    def __init__(self):
        self.nodes = {}  # node_id -> DAGNode
        self.tips = []   # current tips (nodes with no children)

    def add_node(self, node):
        self.nodes[node.node_id] = node
        # Update tips: remove parents from tips, add this node
        for p in node.parents:
            if p in self.tips:
                self.tips.remove(p)
        self.tips.append(node.node_id)

    def verify_dag(self):
        """Verify that all parent references are valid."""
        for node_id, node in self.nodes.items():
            for parent_id in node.parents:
                if parent_id not in self.nodes:
                    return False, f"Node {node_id} references missing parent {parent_id}"
        return True, "DAG is valid"

    def topological_sort(self):
        """Kahn's algorithm for topological sort."""
        in_degree = {nid: 0 for nid in self.nodes}
        children = {nid: [] for nid in self.nodes}

        for node_id, node in self.nodes.items():
            for parent_id in node.parents:
                in_degree[node_id] += 1
                children[parent_id].append(node_id)

        queue = [nid for nid, deg in in_degree.items() if deg == 0]
        order = []
        while queue:
            nid = queue.pop(0)
            order.append(nid)
            for child in children[nid]:
                in_degree[child] -= 1
                if in_degree[child] == 0:
                    queue.append(child)

        return order


def build_sample_dag():
    """Build a sample DAG with 7 transactions."""
    dag = BlockchainDAG()

    # Genesis transactions (no parents)
    t0 = Transaction("tx0", "genesis", "Alice", 100, timestamp=1000)
    t1 = Transaction("tx1", "genesis", "Bob", 80, timestamp=1001)

    n0 = DAGNode("n0", t0, parents=[])
    n1 = DAGNode("n1", t1, parents=[])
    dag.add_node(n0)
    dag.add_node(n1)

    # Second layer
    t2 = Transaction("tx2", "Alice", "Charlie", 30, timestamp=1002)
    t3 = Transaction("tx3", "Bob", "Dave", 20, timestamp=1003)
    n2 = DAGNode("n2", t2, parents=["n0"])
    n3 = DAGNode("n3", t3, parents=["n1"])
    dag.add_node(n2)
    dag.add_node(n3)

    # Third layer (merging branches)
    t4 = Transaction("tx4", "Charlie", "Eve", 15, timestamp=1004)
    n4 = DAGNode("n4", t4, parents=["n2", "n3"])
    dag.add_node(n4)

    # Fourth layer
    t5 = Transaction("tx5", "Dave", "Frank", 10, timestamp=1005)
    t6 = Transaction("tx6", "Eve", "Alice", 5, timestamp=1006)
    n5 = DAGNode("n5", t5, parents=["n4"])
    n6 = DAGNode("n6", t6, parents=["n4"])
    dag.add_node(n5)
    dag.add_node(n6)

    return dag


def main():
    print("Initializing BlockchainDAGs module...")

    dag = build_sample_dag()

    print(f"DAG nodes: {len(dag.nodes)}")
    print(f"Current tips: {dag.tips}")

    valid, msg = dag.verify_dag()
    print(f"DAG verification: {msg}")

    order = dag.topological_sort()
    print(f"Topological order: {order}")

    print("\nNode details:")
    for nid in order:
        node = dag.nodes[nid]
        tx = node.transaction
        parents_str = ", ".join(node.parents) if node.parents else "genesis"
        print(f"  {nid}: {tx.sender} -> {tx.receiver} ({tx.amount}) | parents: [{parents_str}]")

    output = {
        "module": "BlockchainDAGs",
        "version": "1.0.0",
        "num_nodes": len(dag.nodes),
        "tips": dag.tips,
        "topological_order": order,
        "dag_valid": valid,
        "status": "success",
    }
    print("\nBlockchainDAGs JSON output:")
    print(json.dumps(output, indent=2))

    print("\nBlockchainDAGs module completed successfully.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
