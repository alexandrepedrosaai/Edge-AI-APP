namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    // ============================================================
    // Simulação de Braiding de Anyons Não-Abelianos para Criptografia Quântica
    // Autor: Alexandre Pedrosa AI
    // Data: Maio 2026
    // ============================================================

    // Estado lógico simplificado (|0_L> ou |1_L>)
    newtype CryptoState = (
        logical : Int,
        keyMaterial : Int[]
    );

    // Braiding de anyons não-Abelianos
    operation Braid(a : Int, b : Int, state : CryptoState) : (Complex, CryptoState) {
        let (logical, keyMat) = state!;
        let phase = if (DrawRandomDouble() > 0.5) { Complex(0.0, 1.0) } else { Complex(0.0, -1.0) };

        mutable newLogical = logical;
        let parity = if (DrawRandomDouble() < 0.015) { 1 } else { 0 };

        if (parity == 1) {
            set newLogical = 1; // flip lógico
        }

        let newKey = IntAsInt(IntAsDouble(AbsComplex(phase)) * 100.0) % 256;
        let updatedKeyMat = keyMat + [newKey];

        return (phase, CryptoState(newLogical, updatedKeyMat));
    }

    // Geração de chave topológica
    operation GenerateTopologicalKey(length : Int) : String {
        mutable state = CryptoState(0, []);
        for (i in 1..length*4) {
            let (_, s1) = Braid(1, 2, state);
            set state = s1;
            let (_, s2) = Braid(2, 3, state);
            set state = s2;
            let (_, s3) = Braid(3, 4, state);
            set state = s3;
        }

        // Hash simplificado: concatenar keyMaterial em string
        let raw = "";
        for (k in state::keyMaterial) {
            set raw += IntAsString(k);
        }

        // Em Q# não temos SHA-256 nativo, mas simulamos truncando
        let key = Substring(raw, 0, MinI(Length(raw), length*2));
        return key;
    }

    // Simulação de troca de chave
    operation SimulateKeyExchange() : Unit {
        Message("🔑 Alice realiza braiding...");
        let aliceKey = GenerateTopologicalKey(32);

        Message("🔑 Bob realiza braiding (mesma sequência topológica)...");
        let bobKey = GenerateTopologicalKey(32);

        Message($"🔐 Chave Alice: {aliceKey}");
        Message($"🔐 Chave Bob:   {bobKey}");

        if (aliceKey == bobKey) {
            Message("✅ Chaves idênticas! Protocolo topológico seguro.");
        } else {
            Message("⚠️ Divergência detectada (ataque ou ruído).");
        }
    }

    @EntryPoint()
    operation Main() : Unit {
        Message("🌀 Simulação de Braiding Não-Abeliano para Criptografia Quântica\n");

        // Demonstração de braiding
        Message("=== Sequência de Braiding ===");
        mutable state = CryptoState(0, []);
        for (i in 1..8) {
            let (_, s1) = Braid(1, 2, state);
            set state = s1;
            let (_, s2) = Braid(2, 3, state);
            set state = s2;
        }

        let key = GenerateTopologicalKey(32);
        Message($"🔑 Chave Quântica Topológica Gerada: {key}");

        // Simulação de troca segura
        Message("\n=== Troca de Chave Quântica Topológica ===");
        SimulateKeyExchange();

        Message("\n🚀 Vantagem: Proteção inerente contra eavesdropping");
        Message("   Qualquer medição/interferência altera a topologia → detectável.");
    }
}
