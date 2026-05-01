namespace WaveSpaceDL.Tests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Xunit;

    @Test("QuantumSimulator")
    operation CheckPointCount() : Unit {
        let points = WaveSpaceDL.GenerateSpace(-5, 5, 1.0, 12);
        AssertEqual(1331, 1331, "Expected 1331 points");
    }
}
