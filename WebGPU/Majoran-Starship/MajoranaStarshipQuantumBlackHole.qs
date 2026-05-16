// MajoranaStarship_QuantumBlackHole.qs
// Black Hole Information + Hawking Radiation + Entropy

namespace MajoranaStarship {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation MajoranaStarshipEngineQuantumBlackHole(input : Double[]) : Complex {
        mutable blackHoleCalc = Complex(0.0, 0.0);

        // 10 linhas de cálculos Quantum Black Hole
        for i in 0..9 {
            let horizonArea = Complex(8.0 * Microsoft.Quantum.Math.PI() * IntAsDouble(i+1), 0.0); // área do horizonte
            let entropyBH = Complex(Microsoft.Quantum.Math.Log(1.0 + IntAsDouble(i)), Microsoft.Quantum.Convert.ExpD(-IntAsDouble(i) / 200.0)); // entropia de Bekenstein-Hawking
            let hawkingRadiation = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * IntAsDouble(i) / 90.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * IntAsDouble(i) / 90.0)); // radiação Hawking
            let rand1 = DrawRandomDouble();
            let rand2 = DrawRandomDouble();
            let informationFlow = Complex(rand1, rand2);
            let holographicBound = Complex(Microsoft.Quantum.Math.Sqrt(0.5), Microsoft.Quantum.Math.Sqrt(0.5)); // princípio holográfico
            let evaporation = Complex(Microsoft.Quantum.Convert.ExpD(-IntAsDouble(i) / 50.0), 0.0); // evaporação do buraco negro
            let entanglement = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * IntAsDouble(i) / 80.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * IntAsDouble(i) / 80.0)); // entrelaçamento quântico
            let rand3 = DrawRandomDouble();
            let rand4 = DrawRandomDouble();
            let firewall = Complex(rand3, -rand4);
            let normalization = Complex(Microsoft.Quantum.Math.Sqrt(0.5), Microsoft.Quantum.Math.Sqrt(0.5)); // normalização
            let contribution = ComplexMul(ComplexMul(ComplexMul(ComplexMul(ComplexMul(ComplexMul(ComplexMul(ComplexMul(ComplexMul(horizonArea, entropyBH), hawkingRadiation), informationFlow), holographicBound), evaporation), entanglement), firewall), normalization), Complex(input[i % Length(input)], 0.8 * IntAsDouble(i)));

            set blackHoleCalc = ComplexAdd(blackHoleCalc, contribution);
        }

        return blackHoleCalc;
    }

    function ComplexMul(a : Complex, b : Complex) : Complex {
        let (aRe, aIm) = a!;
        let (bRe, bIm) = b!;
        return Complex(aRe * bRe - aIm * bIm, aRe * bIm + aIm * bRe);
    }

    function ComplexAdd(a : Complex, b : Complex) : Complex {
        let (aRe, aIm) = a!;
        let (bRe, bIm) = b!;
        return Complex(aRe + bRe, aIm + bIm);
    }
}
