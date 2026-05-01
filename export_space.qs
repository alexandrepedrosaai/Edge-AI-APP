namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;

    // Representação de um ponto
    newtype PointState = (
        X : Int,
        Y : Int,
        Z : Int,
        Phi : Double,
        FValue : Double,
        DValue : Double,
        ParticleEnergy : Double,
        ParticleSpin : Double,
        WaveAmplitude : Double,
        WaveFrequency : Double,
        WavePhase : Double
    );

    function AtemporalIrrationalF(x : Int, y : Int, z : Int, phi : Double) : Double {
        let radius = Sqrt(IntAsDouble(x * x + y * y + z * z));
        return Sin(radius + phi) + Cos(IntAsDouble(x - y + z) * phi) + Exp(-((radius * radius) / 18.0));
    }

    function DualDerivativeD(x : Int, y : Int, z : Int, phi : Double) : Double {
        return phi * Cos(IntAsDouble(x) + phi)
             - phi * Sin(IntAsDouble(y) - phi)
             + (1.0 / (1.0 + Abs(IntAsDouble(z)))) * Cos(IntAsDouble(z) * phi);
    }

    function TransformPoint(x : Int, y : Int, z : Int, phi : Double) : PointState {
        let f_value = AtemporalIrrationalF(x, y, z, phi);
        let d_value = DualDerivativeD(x, y, z, phi);
        let amplitude = Sqrt(Abs(f_value * d_value) + 1e-9);
        let frequency = Abs(f_value - d_value) + phi;
        let energy = Round(f_value * f_value + d_value * d_value, 8);
        let spin = Round(Sin(f_value + d_value), 8);
        let phase = Round((f_value + d_value) / 2.0, 8);

        return PointState(x, y, z, phi, Round(f_value, 8), Round(d_value, 8), energy, spin, Round(amplitude, 8), Round(frequency, 8), phase);
    }

    function GenerateSpace(gridMin : Int, gridMax : Int, phi : Double) : PointState[] {
        mutable result = new PointState[0];
        for (x in gridMin..gridMax) {
            for (y in gridMin..gridMax) {
                for (z in gridMin..gridMax) {
                    set result += [TransformPoint(x, y, z, phi)];
                }
            }
        }
        return result;
    }

    // Exportar espaço para JSON via .NET interop
    @EntryPoint()
    operation Main() : Unit {
        let phi = 1.0;
        let space = GenerateSpace(-5, 5, phi);

        Message($"#Q Exporting QuantumOS Procedural Space with {Length(space)} points...");

        // Interop com .NET para salvar JSON
        let jsonSerializer = new System.Text.Json.JsonSerializerOptions();
        let payload = new Microsoft.FSharp.Collections.List<PointState>(space);

        let json = System.Text.Json.JsonSerializer.Serialize(payload, jsonSerializer);
        System.IO.File.WriteAllText("QuantumSpace.json", json);

        Message("✅ Export complete: QuantumSpace.json");
    }
}
