// MajoranaStarship_Cosmology.qs
// Quantum Cosmology: Inflation, CMB, Gravitational Waves

namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Convert;

    operation MajoranaStarshipEngineCosmology(input : Double[]) : Complex {
        mutable cosmologyCalc = Complex(0.0, 0.0);

        // 10 linhas de cálculos Cosmology
        for IntAsDouble(i) in 0..9 {
            let x = IntAsDouble(i);
            let inputValue = input[IntAsDouble(i) % Length(input)];
            let inflation        = Complex(1.0 + x / 100.0, Sin(PI() * x / 90.0));         // inflação primordial; 1+x/100 approximates Exp(x/100) for x∈[0,9] (Exp resolves to quantum gate in SDK 0.28)
            let scalarField      = Complex(0.5, 0.5);                                      // campo inflaton (determinístico)
            let cmbRadiation     = Complex(Sin(PI() * x / 120.0), Cos(PI() * x / 120.0)); // radiação cósmica de fundo
            let densityPerturb   = Complex(Log(1.0 + x), 1.0 / (1.0 + x / 200.0));                // perturbações de densidade; 1/(1+x/200) approximates Exp(-x/200) for x∈[0,9]
            let darkMatter       = Complex(Sin(PI() * x / 80.0), Cos(PI() * x / 80.0));   // componente de matéria escura
            let darkEnergy       = Complex(1.0 / (1.0 + x / 50.0), 0.0);                           // energia escura Λ; 1/(1+x/50) approximates Exp(-x/50) for x∈[0,9]
            let gravitationalWaves = Complex(Sin(PI() * x / 60.0), Cos(PI() * x / 60.0)); // ondas gravitacionais
            let horizon          = Complex(0.5, -0.5);                                     // horizonte cosmológico (determinístico)
            let normalization    = Complex(Sqrt(0.5), Sqrt(0.5));                          // normalização
            let inputContribution = Complex(inputValue, 0.8 * x);

            mutable contribution = inflation;
            set contribution = ComplexMultiplyCosmo(contribution, scalarField);
            set contribution = ComplexMultiplyCosmo(contribution, cmbRadiation);
            set contribution = ComplexMultiplyCosmo(contribution, densityPerturb);
            set contribution = ComplexMultiplyCosmo(contribution, darkMatter);
            set contribution = ComplexMultiplyCosmo(contribution, darkEnergy);
            set contribution = ComplexMultiplyCosmo(contribution, gravitationalWaves);
            set contribution = ComplexMultiplyCosmo(contribution, horizon);
            set contribution = ComplexMultiplyCosmo(contribution, normalization);
            set contribution = ComplexMultiplyCosmo(contribution, inputContribution);

            set cosmologyCalc = Complex(
                cosmologyCalc::Real + contribution::Real,
                cosmologyCalc::Imag + contribution::Imag
            );
        }

        return cosmologyCalc;
    }

    function ComplexMultiply(a : Complex, b : Complex) : Complex {
        return Complex(a::Real * b::Real - a::Imag * b::Imag, a::Real * b::Imag + a::Imag * b::Real);
    }

    function ComplexAdd(a : Complex, b : Complex) : Complex {
        return Complex(a::Real + b::Real, a::Imag + b::Imag);
    }
}
