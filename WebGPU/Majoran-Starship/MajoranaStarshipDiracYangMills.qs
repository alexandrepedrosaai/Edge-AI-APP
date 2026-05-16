// MajoranaStarship_DiracYangMills.qs
// Dirac Equation + Yang-Mills Gauge Fields

namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Convert;

    function ComplexMultiply(a : Complex, b : Complex) : Complex {
        return Complex((a::Real * b::Real - a::Imag * b::Imag, a::Real * b::Imag + a::Imag * b::Real));
    }

    function ComplexAdd(a : Complex, b : Complex) : Complex {
        return Complex((a::Real + b::Real, a::Imag + b::Imag));
    }

    operation MajoranaStarshipEngineDiracYangMills(input : Double[]) : Complex {
        mutable diracYangMillsCalc = Complex((0.0, 0.0));

        // 10 linhas de cálculos Dirac + Yang-Mills
        for i in 0..9 {
            let idx = IntAsDouble(i);
            
            // Use explicit Math namespace to avoid conflicts with Intrinsic
            let gammaTerm = Complex((Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * idx / 180.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * idx / 180.0))); 
            
            let r1 = DrawRandomDouble();
            let r2 = DrawRandomDouble();
            let spinor = Complex((r1, r2)); 
            
            let massTerm = Complex((0.5 * idx, -0.25 * idx)); 
            let derivative = Complex((Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * idx / 90.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * idx / 90.0))); 
            let gaugeField = Complex((Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * idx / 300.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * idx / 300.0))); 
            
            let r3 = DrawRandomDouble();
            let r4 = DrawRandomDouble();
            let fieldStrength = Complex((r3, -r4)); 
            
            let covariantDeriv = Complex((Microsoft.Quantum.Math.Exp(-idx / 50.0), Microsoft.Quantum.Math.Log(1.0 + idx))); 
            let interaction = Complex((Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * idx / 60.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * idx / 60.0))); 
            
            let r5 = DrawRandomDouble();
            let r6 = DrawRandomDouble();
            let symmetry = Complex((r5, r6)); 
            
            let inputTerm = Complex((input[i % Length(input)], 0.8 * idx));
            
            // Chained ComplexMultiply for the contribution
            mutable contribution = ComplexMultiply(gammaTerm, spinor);
            set contribution = ComplexMultiply(contribution, massTerm);
            set contribution = ComplexMultiply(contribution, derivative);
            set contribution = ComplexMultiply(contribution, gaugeField);
            set contribution = ComplexMultiply(contribution, fieldStrength);
            set contribution = ComplexMultiply(contribution, covariantDeriv);
            set contribution = ComplexMultiply(contribution, interaction);
            set contribution = ComplexMultiply(contribution, symmetry);
            set contribution = ComplexMultiply(contribution, inputTerm);

            set diracYangMillsCalc = ComplexAdd(diracYangMillsCalc, contribution);
        }

        return diracYangMillsCalc;
    }
}
