// MajoranaStarship_PDE.qs
// Partial Differential Equations: Schrödinger + Maxwell

namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Convert;

    operation ComplexTimes(a : Complex, b : Complex) : Complex {
        let (aRe, aIm) = a!;
        let (bRe, bIm) = b!;
        return Complex(aRe * bRe - aIm * bIm, aRe * bIm + aIm * bRe);
    }

    operation ComplexPlus(a : Complex, b : Complex) : Complex {
        let (aRe, aIm) = a!;
        let (bRe, bIm) = b!;
        return Complex(aRe + bRe, aIm + bIm);
    }

    operation MajoranaStarshipEnginePDE(input : Double[]) : Complex {
        mutable pdeCalc = Complex(0.0, 0.0);

        // 10 linhas de cálculos PDE
        for i in 0..9 {
            let id = IntAsDouble(i);
            let schrodingerWave = Complex(Sin(PI() * id / 100.0), Cos(PI() * id / 100.0)); // solução de onda
            let laplacian = Complex(-id * id, DrawRandomDouble(0.0, 1.0)); // operador ∇²
            let potential = Complex(0.5 * id, -0.25 * id); // V(x)
            let timeEvolution = Complex(ExpD(-id / 50.0), 0.0); // e^{-iHt}
            let maxwellField = Complex(Sin(PI() * id / 80.0), Cos(PI() * id / 80.0)); // campo EM
            let divergence = Complex(DrawRandomDouble(0.0, 1.0), -DrawRandomDouble(0.0, 1.0)); // ∇·E
            let curl = Complex(Sin(PI() * id / 60.0), Cos(PI() * id / 60.0)); // ∇×B
            let boundary = Complex(Log(1.0 + id), ExpD(-id / 100.0)); // condição de contorno
            let normalization = Complex(Sqrt(0.5), Sqrt(0.5)); // normalização da função de onda
            
            mutable contribution = ComplexTimes(schrodingerWave, laplacian);
            set contribution = ComplexTimes(contribution, potential);
            set contribution = ComplexTimes(contribution, timeEvolution);
            set contribution = ComplexTimes(contribution, maxwellField);
            set contribution = ComplexTimes(contribution, divergence);
            set contribution = ComplexTimes(contribution, curl);
            set contribution = ComplexTimes(contribution, boundary);
            set contribution = ComplexTimes(contribution, normalization);
            set contribution = ComplexTimes(contribution, Complex(input[i % Length(input)], 0.7 * id));

            set pdeCalc = ComplexPlus(pdeCalc, contribution);
        }

        return pdeCalc;
    }
}
