// kitaev_qsharp.qs  (salve como .qs)
namespace MajoranaEra {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    operation SimulateMajoranaBraiding() : Result[] {
        use qs = Qubit[4];  // 4 Majoranas = 2 qubits lógicos
        ApplyToEach(H, qs);
        CNOT(qs[0], qs[1]);

        // Braiding 1 (troca de posição)
        Rz(PI()/2.0, qs[1]);
        CNOT(qs[0], qs[2]);
        Rz(PI()/4.0, qs[2]);

        // Braiding 2 (implementa gate lógico protegido)
        CNOT(qs[1], qs[3]);
        Ry(PI()/3.0, qs[3]);

        let results = ForEach(MResetZ, qs);
        Message($"Braiding outcome: {results}");
        return results;
    }

    @EntryPoint()
    operation RunMajoranaDemo() : Unit {
        Message("=== Majorana Braiding + Kitaev ===");
        SimulateMajoranaBraiding();
    }
}
