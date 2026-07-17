// MajoranaStarship_QuantumNebulae.qs
// Quantum Nebulae + Interstellar Clouds

namespace MajoranaStarship {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    function ComplexMul(a : Complex, b : Complex) : Complex {
        return Complex(a::Real * b::Real - a::Imag * b::Imag, a::Real * b::Imag + a::Imag * b::Real);
    }

    function ComplexAdd(a : Complex, b : Complex) : Complex {
        return Complex(a::Real + b::Real, a::Imag + b::Imag);
    }

    operation MajoranaStarshipEngineQuantumNebulae(input : Double[]) : Complex {
        mutable nebulaCalc = Complex(0.0, 0.0);

        // 20 linhas de cálculos Quantum Nebulae
        for i in 0..19 {
<
            
            // Explicitly use Microsoft.Quantum.Math functions to avoid ambiguity with quantum intrinsics
            let gasCloud = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * iDouble / 100.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * iDouble / 100.0));
            let dustParticles = Complex(Microsoft.Quantum.Math.Log(1.0 + iDouble), Microsoft.Quantum.Math.ExpD(-iDouble / 200.0));
            let ionization = Complex(Microsoft.Quantum.Math.Sqrt(0.5), Microsoft.Quantum.Math.Sqrt(0.5));
            let photonEmission = Complex(Microsoft.Quantum.Math.ExpD(-iDouble / 150.0), Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * iDouble / 80.0));
            let resonance = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * iDouble / 90.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * iDouble / 90.0));
            let entanglement = Complex(0.5, 0.5);
            let decoherence = Complex(Microsoft.Quantum.Math.ExpD(-iDouble / 50.0), 0.0);
            let gravitationalCollapse = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * iDouble / 70.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * iDouble / 70.0));
            let starFormation = Complex(0.5, -0.5);
            let turbulence = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * iDouble / 60.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * iDouble / 60.0));
            let magneticField = Complex(Microsoft.Quantum.Math.Log(1.0 + iDouble), Microsoft.Quantum.Math.ExpD(-iDouble / 100.0));
            let shockWave = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * iDouble / 85.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * iDouble / 85.0));
            let recurrence = Complex(Microsoft.Quantum.Math.ExpD(-iDouble / 120.0), Microsoft.Quantum.Math.Log(1.0 + iDouble));
            let holography = Complex(Microsoft.Quantum.Math.Sqrt(0.5), Microsoft.Quantum.Math.Sqrt(0.5));
            let multiverseBranch = Complex(Microsoft.Quantum.Math.Sin(Microsoft.Quantum.Math.PI() * iDouble / 110.0), Microsoft.Quantum.Math.Cos(Microsoft.Quantum.Math.PI() * iDouble / 110.0));
            let synchronization = Complex(0.5, 0.5);
            let normalization = Complex(Microsoft.Quantum.Math.Sqrt(0.5), Microsoft.Quantum.Math.Sqrt(0.5));
            
            // Manual complex multiplication chain to avoid operator overloading issues
            mutable contribution = ComplexMul(gasCloud, dustParticles);
            set contribution = ComplexMul(contribution, ionization);
            set contribution = ComplexMul(contribution, photonEmission);
            set contribution = ComplexMul(contribution, resonance);
            set contribution = ComplexMul(contribution, entanglement);
            set contribution = ComplexMul(contribution, decoherence);
            set contribution = ComplexMul(contribution, gravitationalCollapse);
            set contribution = ComplexMul(contribution, starFormation);
            set contribution = ComplexMul(contribution, turbulence);
            set contribution = ComplexMul(contribution, magneticField);
            set contribution = ComplexMul(contribution, shockWave);
            set contribution = ComplexMul(contribution, recurrence);
            set contribution = ComplexMul(contribution, holography);
            set contribution = ComplexMul(contribution, multiverseBranch);
            set contribution = ComplexMul(contribution, synchronization);
            set contribution = ComplexMul(contribution, normalization);
            
            // Final contribution with input data
            let inputVal = input[i % Length(input)];
            let inputComplex = Complex(inputVal, 0.8 * iDouble);
            set contribution = ComplexMul(contribution, inputComplex);

            set nebulaCalc = ComplexAdd(nebulaCalc, contribution);
        }

        return nebulaCalc;
    }
}
