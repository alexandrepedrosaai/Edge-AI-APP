namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    operation Main_CLI() : Unit {
        // Q# does not support System.Environment or System.Text.Json
        Message("Quantum CLI Simulator: Running default generation...");
        
        let phi = 1.0;
        let space = GenerateSpace(-2, 2, phi);
        
        Message($"✅ Generated {Length(space)} points in simulation.");
    }
}
