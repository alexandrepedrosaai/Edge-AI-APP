namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation LunarQuantumGovernance() : Unit {
        let bases = 3;
        let qubitsPerBase = 2;

        Message("🌌 Lunar Base - Quantum Governance Simulation");

        using (qs = Qubit[bases * qubitsPerBase]) {
            for i in 0..Length(qs)-1 {
                H(qs[i]);
            }

            for i in 0..bases-2 {
                CNOT(qs[i], qs[i+1]);
            }

            for i in 0..Length(qs)-1 {
                let result = M(qs[i]);
                Message($"Base {i/2 + 1} decision qubit {i%2}: {result}");
            }

            ResetAll(qs);
        }

        Message("✅ Quantum governance protocol executed across lunar bases.");
    }
}
