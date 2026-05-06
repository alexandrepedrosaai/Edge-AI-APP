
namespace MajoranaStarship.Calculations {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    // While polymorphism in classical programming refers to objects taking on many forms,
    // in quantum computing, we can think of operations that can act on different quantum states
    // or types of qubits. This is a conceptual example.
    operation ApplyOperationOnQubit (q : Qubit, op : (Qubit => Unit)) : Unit {
        op(q);
    }

    operation SayHello (q : Qubit) : Unit {
        Message("Hello from a Qubit!");
        H(q);
    }

    operation SayGoodbye (q : Qubit) : Unit {
        Message("Goodbye from a Qubit!");
        X(q);
    }

    @EntryPoint()
    operation PolymorphismDemo () : Unit {
        using (q = Qubit()) {
            ApplyOperationOnQubit(q, SayHello);
            let result = M(q);
            Message($"Measurement result after SayHello: {result}");

            Reset(q);

            ApplyOperationOnQubit(q, SayGoodbye);
            let result2 = M(q);
            Message($"Measurement result after SayGoodbye: {result2}");

            Reset(q);
        }
    }
}
