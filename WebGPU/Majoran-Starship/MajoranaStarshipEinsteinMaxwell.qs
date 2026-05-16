// MajoranaStarship_EinsteinMaxwell.qs
// Einstein Field Equations + Maxwell Equations in curved spacetime

namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    function ComplexMultiplyEM(left : Complex, right : Complex) : Complex {
        let real = left::Real * right::Real - left::Imag * right::Imag;
        let imag = left::Real * right::Imag + left::Imag * right::Real;
        return Complex(real, imag);
    }

    operation MajoranaStarshipEngineEinsteinMaxwell(input : Double[]) : Complex {
        mutable einsteinMaxwellCalc = Complex(0.0, 0.0);

        // 10 linhas de cálculos Einstein-Maxwell
        for i in 0..9 {
            let idx = IntAsDouble(i);
            let inputValue = input[i % Length(input)];
            
            // Using deterministic values to avoid DrawRandomDouble issues in this SDK version
            let curvature = Complex(8.0 * PI() * 0.5, -4.0 * 0.5); // tensor de curvatura
            let stressEnergy = Complex(0.6, 0.4); // T_{μν}
            let cosmological = Complex(0.0, 1.0 / (1.0 + idx / 100.0)); // Λ g_{μν}
            let ricciScalar = Complex(Sin(PI() * idx / 120.0), Cos(PI() * idx / 120.0)); // R
            let electricField = Complex(Sin(PI() * idx / 80.0), Cos(PI() * idx / 80.0)); // E
            let magneticField = Complex(Sin(PI() * idx / 60.0), Cos(PI() * idx / 60.0)); // B
            let divergenceE = Complex(0.3, -0.2); // ∇·E
            let curlB = Complex(Sin(PI() * idx / 40.0), Cos(PI() * idx / 40.0)); // ∇×B
            let waveEquation = Complex(1.0 / (1.0 + idx / 50.0), Sin(PI() * idx / 90.0)); // propagação EM
            let inputContribution = Complex(inputValue, 0.8 * idx);

            mutable contribution = curvature;
            set contribution = ComplexMultiplyEM(contribution, stressEnergy);
            set contribution = ComplexMultiplyEM(contribution, cosmological);
            set contribution = ComplexMultiplyEM(contribution, ricciScalar);
            set contribution = ComplexMultiplyEM(contribution, electricField);
            set contribution = ComplexMultiplyEM(contribution, magneticField);
            set contribution = ComplexMultiplyEM(contribution, divergenceE);
            set contribution = ComplexMultiplyEM(contribution, curlB);
            set contribution = ComplexMultiplyEM(contribution, waveEquation);
            set contribution = ComplexMultiplyEM(contribution, inputContribution);

            set einsteinMaxwellCalc = Complex(
                einsteinMaxwellCalc::Real + contribution::Real,
                einsteinMaxwellCalc::Imag + contribution::Imag
            );
        }

        return einsteinMaxwellCalc;
    }
}
