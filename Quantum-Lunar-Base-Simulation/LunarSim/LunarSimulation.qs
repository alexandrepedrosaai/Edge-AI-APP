namespace Quantum.LunarBase {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation LunarSimulation() : Result {
        using (q = Qubit()) {
            // Estado passado: origem da Lua
            H(q); // Superposição: Terra + fragmento lunar

            // Estado futuro: base semi-esférica
            X(q); // Representa instalação humana

            let result = M(q);

            Reset(q);
            return result;
        }
    }
}
