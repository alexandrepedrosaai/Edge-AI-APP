namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    // Representação de um ponto no espaço quântico
    newtype PointState = (
        X : Int,
        Y : Int,
        Z : Int,
        Phi : Double,
        FValue : Double,
        DValue : Double,
        Energy : Double,
        Spin : Double,
        Amplitude : Double,
        Frequency : Double,
        Phase : Double
    );

    // Função atemporal irracional f
    function AtemporalIrrationalF(x : Int, y : Int, z : Int, phi : Double) : Double {
        let radius = Sqrt(IntAsDouble(x * x + y * y + z * z));
        return Sin(radius + phi) + Cos(IntAsDouble(x - y + z) * phi) + Exp(-((radius * radius) / 18.0));
    }

    // Função derivada dual d
    function DualDerivativeD(x : Int, y : Int, z : Int, phi : Double) : Double {
        return phi * Cos(IntAsDouble(x) + phi)
             - phi * Sin(IntAsDouble(y) - phi)
             + (1.0 / (1.0 + Abs(IntAsDouble(z)))) * Cos(IntAsDouble(z) * phi);
    }

    // Transformar coordenadas em PointState
    function TransformPoint(x : Int, y : Int, z : Int, phi : Double) : PointState {
        let f_value = AtemporalIrrationalF(x, y, z, phi);
        let d_value = DualDerivativeD(x, y, z, phi);
        let amplitude = Sqrt(Abs(f_value * d_value) + 1e-9);
        let frequency = Abs(f_value - d_value) + phi;
        let energy = f_value * f_value + d_value * d_value;
        let spin = Sin(f_value + d_value);
        let phase = (f_value + d_value) / 2.0;

        return PointState(x, y, z, phi, f_value, d_value, energy, spin, amplitude, frequency, phase);
    }

    // Gerar espaço de pontos
    function GenerateSpace(gridMin : Int, gridMax : Int, phi : Double) : PointState[] {
        mutable result = [];
        for x in gridMin..gridMax {
            for y in gridMin..gridMax {
                for z in gridMin..gridMax {
                    set result += [TransformPoint(x, y, z, phi)];
                }
            }
        }
        return result;
    }

    operation Main_DataClass() : Unit {
        let phi = 1.0;
        let space = GenerateSpace(-2, 2, phi);
        Message($"#Q QuantumOS Procedural Space generated with {Length(space)} points.");
    }
}
