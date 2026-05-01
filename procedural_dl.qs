namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    // Sumarizar espaço de pontos
    function SummarizeSpace(config : ProceduralDLConfig, points : PointState[]) : (Double[], Double, Int) {
        let (dim, temp, name, act) = config!;
        mutable channelMeans = new Double[dim];
        mutable totalConfidence = 0.0;

        for (i in 0..Length(points)-1) {
            let (embedding, confidence, _) = EncodePoint(config, points[i]);
            set totalConfidence += confidence;
            for (j in 0..dim-1) {
                set channelMeans w/= j <- channelMeans[j] + embedding[j];
            }
        }

        for (j in 0..dim-1) {
            set channelMeans w/= j <- channelMeans[j] / IntAsDouble(Length(points));
        }

        let avgConfidence = totalConfidence / IntAsDouble(Length(points));

        return (channelMeans, avgConfidence, Length(points));
    }

    operation Main_ProceduralDL() : Unit {
        let config = DefaultConfig();
        let point = PointState(1, 0, -1, 0.3, 0.7, 0.4, 2.0, 0.5, 0.9, 1.2, 0.8);
        
        let (embedding, confidence, latentNorm) = EncodePoint(config, point);

        Message($"#Q Procedural DL Summary");
        let summary = SummarizeSpace(config, [point]);
        let (sig, avgC, count) = summary;
        Message($"Encoded Points: {count}");
    }
}
