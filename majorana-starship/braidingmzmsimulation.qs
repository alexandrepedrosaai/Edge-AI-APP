namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    // Definição explícita das matrizes de braiding (2x2)
    function BraidingMatrix() : Complex[,] {
        // Representação simplificada: fase geométrica ±i
        return Complex[,] [
            [ Complex(0.0, 1.0), Complex(0.0, 0.0) ],
            [ Complex(0.0, 0.0), Complex(0.0, -1.0) ]
        ];
    }

    // Operação para aplicar braiding em um qubit
    operation ApplyBraiding(q : Qubit) : Unit {
        let U = BraidingMatrix();
        // Aplicar unitário explicitamente
        // Em Q#, usamos ApplyUnitary para matrizes definidas
        ApplyUnitary(U, [q]);
    }

    // Medição de paridade (Z)
    operation ParityMeasurement(q : Qubit) : Result {
        return Measure([PauliZ], [q]);
    }

    // Sequência de braiding simulando um CNOT-like
    operation SimulateCNOTLike() : Unit {
        use qs = Qubit[4];
        Message("=== Simulação de Braiding MZMs com matrizes explícitas ===");

        for (step in 1..6) {
            ApplyBraiding(qs[0]);
            let r1 = ParityMeasurement(qs[0]);

            ApplyBraiding(qs[1]);
            let r2 = ParityMeasurement(qs[1]);

            ApplyBraiding(qs[2]);
            let r3 = ParityMeasurement(qs[2]);

            Message($"Step {step}: Parities {r1}, {r2}, {r3}");
        }

        ResetAll(qs);
    }
}
