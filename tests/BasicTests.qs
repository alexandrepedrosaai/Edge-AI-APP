namespace WaveSpaceDL.Tests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open WaveSpaceDL;

    @Test("QuantumSimulator")
    operation CheckPointCount() : Unit {
        let points : Int[] = GenerateSpace(-5, 5, 1.0, 12);
        EqualityFactI(Length(points), 1331, "Unexpected number of points.");
    }
}
