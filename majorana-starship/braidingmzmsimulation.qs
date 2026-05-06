namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation BraidingMZMs(q1 : Qubit, q2 : Qubit) : Result {
        // Fase geométrica típica do braiding não-abeliano
        let phase = if (RandomBool()) { Complex(0.0, 1.0) } else { Complex(0.0, -1.0) };
        // Aplicar unitário correspondente (simplificado)
        Rz(phase, q1);

        // Medição de paridade
        let result = Measure([PauliZ], [q1]);
        return result;
    }

    operation SimulateCNOTLike() : Unit {
        use qs = Qubit[4];
        Message("=== Simulação de Braiding MZMs em Q# ===");

        for (step in 1..6) {
            let r1 = BraidingMZMs(qs[0], qs[1]);
            let r2 = BraidingMZMs(qs[1], qs[2]);
            let r3 = BraidingMZMs(qs[2], qs[3]);
            Message($"Step {step}: Parities {r1}, {r2}, {r3}");
        }

        ResetAll(qs);
    }
}
