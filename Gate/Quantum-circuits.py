# ==================================================
# CÓDIGO RUDO - SIMULAÇÃO DE PORTAS LÓGICAS
# Baseado no conteúdo sobre Circuitos Digitais e Lógica Booleana
# ==================================================

# ------------------------------
# 1. DEFINIÇÃO DAS PORTAS LÓGICAS
# ------------------------------

# PORTAS BÁSICAS
def AND(a, b):
    return 1 if (a == 1 and b == 1) else 0

def OR(a, b):
    return 1 if (a == 1 or b == 1) else 0

def NOT(a):
    return 1 if a == 0 else 0

# PORTAS DERIVADAS
def NAND(a, b):
    return NOT(AND(a, b))

def NOR(a, b):
    return NOT(OR(a, b))

def XOR(a, b):
    return OR(AND(a, NOT(b)), AND(NOT(a), b))

def XNOR(a, b):
    return NOT(XOR(a, b))

# ------------------------------
# 2. PORTAS UNIVERSAIS
# Implementação de todas as portas usando apenas NAND ou NOR
# ------------------------------

# USANDO SOMENTE NAND
def NOT_nand(a):
    return NAND(a, a)

def AND_nand(a, b):
    return NOT_nand(NAND(a, b))

def OR_nand(a, b):
    return NAND(NOT_nand(a), NOT_nand(b))

# USANDO SOMENTE NOR
def NOT_nor(a):
    return NOR(a, a)

def OR_nor(a, b):
    return NOT_nor(NOR(a, b))

def AND_nor(a, b):
    return NOR(NOT_nor(a), NOT_nor(b))

# ------------------------------
# 3. FLUXO DE PROJETO DE CIRCUITOS
# Exemplo: Função Maioria 2 entradas e Função Complexa
# ------------------------------

def tabela_verdade(funcao):
    """Gera e exibe a tabela verdade de qualquer função lógica de 2 entradas"""
    print("\nTabela Verdade:")
    print("A | B | Y")
    print("-" * 9)
    for a in [0, 1]:
        for b in [0, 1]:
            y = funcao(a, b)
            print(f"{a} | {b} | {y}")

# Função Maioria (saída 1 somente quando ambas entradas são 1)
def maioria_2(a, b):
    return AND(a, b)

# Função complexa exemplo: F = AB + ~C(A + B)
def funcao_complexa(a, b, c):
    termo1 = AND(a, b)
    termo2 = AND(NOT(c), OR(a, b))
    return OR(termo1, termo2)

# ------------------------------
# 4. IMPLEMENTAÇÃO COM PORTAS UNIVERSAIS
# Exemplo: F = AB + ~C usando apenas NAND
# ------------------------------

def funcao_nand(a, b, c):
    # Conversão aplicando dupla negação e Lei de De Morgan
    ab_nand = NAND(a, b)
    not_c = NAND(c, c)
    resultado = NAND(ab_nand, not_c)
    return resultado

# ------------------------------
# 5. TESTES E EXECUÇÃO
# ------------------------------

if __name__ == "__main__":
    print("===== SIMULAÇÃO DE PORTAS LÓGICAS =====")

    # Teste das portas básicas e derivadas
    print("\n--- Teste das Portas Lógicas ---")
    entradas = [(0,0), (0,1), (1,0), (1,1)]
    for a,b in entradas:
        print(f"A={a}, B={b} | AND={AND(a,b)} | OR={OR(a,b)} | NAND={NAND(a,b)} | NOR={NOR(a,b)} | XOR={XOR(a,b)} | XNOR={XNOR(a,b)}")

    # Tabela verdade da função maioria
    tabela_verdade(maioria_2)

    # Teste da função complexa de 3 entradas
    print("\n--- Saída da Função Complexa F = AB + ~C(A+B) ---")
    for a in [0,1]:
        for b in [0,1]:
            for c in [0,1]:
                res = funcao_complexa(a,b,c)
                print(f"A={a}, B={b}, C={c} -> F = {res}")

    # Comparação entre implementação padrão e com NAND
    print("\n--- Comparação: Função Original vs Apenas NAND ---")
    for a in [0,1]:
        for b in [0,1]:
            for c in [0,1]:
                original = OR(AND(a,b), NOT(c))
                apenas_nand = funcao_nand(a,b,c)
                print(f"A={a}, B={b}, C={c} | Original: {original} | NAND: {apenas_nand} | IGUAIS: {original == apenas_nand}")
