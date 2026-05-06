// TetronSimulation.qs
namespace MajoranaEra.Tetron {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;

    // Operação que representa um Tetron (4 Majoranas = 1 qubit lógico)
    operation SimulateTetron(parityInit : Bool) : Result {
        use majoranas = Qubit[4];  // γ1, γ2, γ3, γ4

        // Preparar estado inicial (paridade controlada)
        ApplyToEach(H, majoranas);
        if (parityInit) {
            X(majoranas[0]);
        }

        // Entanglement inicial do Tetron
        CNOT(majoranas[0], majoranas[1]);
        CNOT(majoranas[2], majoranas[3]);

        // === Braiding Não-Abeliano via Medições (Measurement-based) ===
        // Medição Z-loop (paridade ao longo de uma nanowire)
        let zParity = Measure([PauliZ, PauliZ], [majoranas[0], majoranas[1]]);

        // Medição X-loop (braiding virtual)
        H(majoranas[2]);
        let xParity = Measure([PauliZ, PauliZ], [majoranas[2], majoranas[3]]);
        H(majoranas[2]);

        // Aplicar gate lógico baseado no braiding
        if (xParity == One) {
            S(majoranas[0]);  // Fase topológica
        }

        // Medir qubit lógico final (paridade total)
        let logicalResult = Measure([PauliZ], [majoranas[0]]);
        
        ResetAll(majoranas);
        return logicalResult;
    }

    // Demonstração de não-comutatividade
    operation DemonstrateTetronBraiding() : Unit {
        Message("=== Tetron Braiding Simulation (Microsoft Majorana-1 style) ===");

        // Sequência AB
        let resultAB = SimulateTetron(false);
        Message($"Resultado sequência AB: {resultAB}");

        // Reset e sequência BA
        let resultBA = SimulateTetron(true);
        Message($"Resultado sequência BA: {resultBA}");
        Message("→ Não-Abeliano: ordem dos braids importa!");
    }

    @EntryPoint()
    operation RunTetronDemo() : Unit {
        DemonstrateTetronBraiding();
    }
}
