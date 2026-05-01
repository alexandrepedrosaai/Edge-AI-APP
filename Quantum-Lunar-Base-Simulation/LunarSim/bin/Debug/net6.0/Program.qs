namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation MeasureMoonQubit() : Result {
        using (qubit = Qubit()) {
            H(qubit); // aplica Hadamard → estado superposição
            let result = M(qubit); // mede o qubit
            Reset(qubit);
            return result;
        }
    }

    @EntryPoint()
    operation Main() : Unit {
        Message("🌌 Quantum Lunar Base Simulation started...");
        let measurement = MeasureMoonQubit();
        if (measurement == One) {
            Message("Result: Oxygen molecule detected 🫁");
        } else {
            Message("Result: Water molecule detected 💧");
        }
    }
}
