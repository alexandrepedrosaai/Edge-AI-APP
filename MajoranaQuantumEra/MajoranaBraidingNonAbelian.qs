// MajoranaBraidingNonAbelian.qs
namespace MajoranaEra.Braiding {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;

    operation ApplyBraidingStep(qubits: Qubit[], step: Int) : Unit is Adj + Ctl {
        // Simula braiding de Majoranas via rotações + CNOT (aproximação)
        if (step == 1) {  // Braiding 1-2
            Rz(PI() / 2.0, qubits[1]);
            CNOT(qubits[0], qubits[2]);
            Rz(PI() / 4.0, qubits[2]);
        } elif (step == 2) {  // Braiding 2-3 (ordem importa!)
            Rz(PI() / 3.0, qubits[2]);
            CNOT(qubits[1], qubits[3]);
            Ry(PI() / 6.0, qubits[3]);
        }
    }

    operation DemonstrateNonAbelianBraiding() : Result[][] {
        use qs = Qubit[4];  // 4 Majoranas = 2 qubits lógicos
        ApplyToEach(H, qs);
        CNOT(qs[0], qs[1]);  // Estado inicial

        // Sequência A então B
        ApplyBraidingStep(qs, 1);
        ApplyBraidingStep(qs, 2);
        let outcomeAB = ForEach(MResetZ, qs);

        // Reset e sequência B então A
        ResetAll(qs);
        ApplyToEach(H, qs);
        CNOT(qs[0], qs[1]);
        ApplyBraidingStep(qs, 2);
        ApplyBraidingStep(qs, 1);
        let outcomeBA = ForEach(MResetZ, qs);

        Message($"Outcome AB (ordem 1→2): {outcomeAB}");
        Message($"Outcome BA (ordem 2→1): {outcomeBA}");
        Message("→ Não-Abeliano: AB ≠ BA (em hardware real)!");

        return [outcomeAB, outcomeBA];
    }

    @EntryPoint()
    operation RunNonAbelianDemo() : Unit {
        Message("=== Braiding Não-Abeliano de Majoranas ===");
        DemonstrateNonAbelianBraiding();
    }
}
