# qkd_topological_attack.py
import numpy as np

def generate_majorana_key(num_bits=128):
    return np.random.randint(0, 2, num_bits)  # paridade de Majoranas

def simulate_quantum_attack(alice_key, attack_rate=0.15):
    bob_key = alice_key.copy()
    attack_mask = np.random.rand(len(bob_key)) < attack_rate
    bob_key[attack_mask] = 1 - bob_key[attack_mask]  # Eve mede e perturba
    return bob_key

def detect_attack(alice, bob, threshold=0.08):
    error_rate = np.mean(alice != bob)
    print(f"Taxa de erro: {error_rate:.1%}")
    if error_rate > threshold:
        print("🚨 ATAQUE QUÂNTICO DETECTADO! (Proteção topológica ativada)")
        return False
    print("✅ Chave segura (sem ataque detectado)")
    return True

# Simulação
alice = generate_majorana_key()
bob_no_attack = alice.copy()
bob_with_attack = simulate_quantum_attack(alice, attack_rate=0.20)

print("=== Sem Ataque ===")
detect_attack(alice, bob_no_attack)
print("\n=== Com Ataque Quântico (Eve interferindo) ===")
detect_attack(alice, bob_with_attack)
