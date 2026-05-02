namespace WaveSpaceDL.Tests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Xunit;
    open WaveSpaceDL;

    @Test("QuantumSimulator")
    operation CheckPointCount() : Unit {
        let points = GenerateSpace(-5, 5, 1.0, 12);
        AssertEqual(1331, Length(points), "Unexpected number of points.");
    }
}
