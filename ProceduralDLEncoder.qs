namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    // Configuração procedural
    newtype ProceduralDLConfig = (
        EmbeddingDim : Int,
        LatentTemperature : Double,
        ModelName : String,
        Activation : String
    );

    function DefaultConfig() : ProceduralDLConfig {
        return ProceduralDLConfig(12, 0.61803398875, "procedural-dl", "tanh");
    }

    // PointState is defined in dataclass.qs, we should use that or define a local version if namespaces were different.
    // To avoid "PointState already exists", we use the one from the project.
    // If it's in the same namespace, we don't need to redefine it.

    // Codificação de um ponto
    function EncodePoint(config : ProceduralDLConfig, point : PointState) : (Double[], Double, Double) {
        let (dim, temp, name, act) = config!;
        let (x, y, z, phi, fval, dval, energy, spin, amplitude, frequency, phase) = point!;
        mutable embedding = new Double[dim];
        let seed = fval + dval + phi;

        for (index in 0..dim-1) {
            let phaseFactor = (IntAsDouble(index) + 1.0) * temp;
            let channel = Tanh(
                Sin(seed * phaseFactor)
                + Cos((IntAsDouble(x - y + z) + 1.0) * phaseFactor)
                + (energy / (IntAsDouble(index) + 2.0))
                - phase / (IntAsDouble(index) + 3.0)
            );
            set embedding w/= index <- channel;
        }

        let confidence = 1.0 / (1.0 + Abs(phase - amplitude));
        
        mutable sumSq = 0.0;
        for val in embedding {
            set sumSq += val * val;
        }
        let latentNorm = Sqrt(sumSq);

        return (embedding, confidence, latentNorm);
    }

    operation Main_ProceduralDLEncoder() : Unit {
        let config = DefaultConfig();
        // PointState(x, y, z, phi, fval, dval, energy, spin, amplitude, frequency, phase)
        let point = PointState(1, 0, -1, 0.3, 0.7, 0.4, 2.0, 0.5, 0.9, 1.2, 0.8);
        let (embedding, confidence, latentNorm) = EncodePoint(config, point);

        Message($"#Q Procedural DL Encoder");
        Message($"Model: {config::ModelName}");
        Message($"Confidence: {confidence}");
        Message($"Latent Norm: {latentNorm}");
    }
}
