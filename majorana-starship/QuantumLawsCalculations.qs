
namespace MajoranaStarship.Calculations {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;

    // --- Quantum Superposition (Simplified) ---
    // Demonstrates creating a superposition state for a single qubit.
    // In Q#, we can put a qubit into a superposition using the H (Hadamard) gate.
    operation CreateSuperposition (q : Qubit) : Unit {
        H(q);
    }

    // --- Heisenberg Uncertainty Principle (Conceptual) ---
    // While Q# doesn't directly calculate classical uncertainties like position and momentum,
    // the principle is fundamental to quantum mechanics. We can illustrate the idea
    // that measuring one property affects another.
    operation DemonstrateUncertaintyPrinciple (q : Qubit) : Unit {
        // Put qubit in superposition
        H(q);
        Message("Qubit is in superposition. Measuring in Z-basis (computational basis).");
        let resultZ = M(q);
        Message($"Measurement in Z-basis: {resultZ}");

        // If we then try to measure in X-basis, the state is disturbed.
        // This is a conceptual representation of the uncertainty principle.
        Reset(q); // Reset for next demonstration
        H(q);
        Message("Qubit is in superposition. Measuring in X-basis (Hadamard basis).");
        H(q); // Rotate to X-basis for measurement
        let resultX = M(q);
        Message($"Measurement in X-basis: {resultX}");
    }

    @EntryPoint()
    operation QuantumLawsDemo () : Unit {
        using (q = Qubit()) {
            Message("\n--- Superposition Demo ---");
            CreateSuperposition(q);
            let result = M(q);
            Message($"Measurement of superposition state: {result}");
            Reset(q);

            Message("\n--- Uncertainty Principle Demo ---");
            DemonstrateUncertaintyPrinciple(q);
            Reset(q);
        }
    }
}
