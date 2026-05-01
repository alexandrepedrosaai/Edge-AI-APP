namespace WaveSpaceDL {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open System;
    open System.IO;
    open System.Text.Json;

    // Structures
    newtype Particle = (PosX : Int, PosY : Int, PosZ : Int, Energy : Double, Spin : Double);
    newtype Wave = (Amplitude : Double, Frequency : Double, Phase : Double);
    newtype DLInfo = (Model : String, Activation : String, Embedding : Double[], Confidence : Double, LatentNorm : Double);

    newtype PointState = (
        X : Int,
        Y : Int,
        Z : Int,
        Phi : Double,
        FValue : Double,
        DValue : Double,
        Particle : Particle,
        Wave : Wave,
        DL : DLInfo
    );

    // Math functions
    function AtemporalIrrationalF(x : Int, y : Int, z : Int, phi : Double) : Double {
        let radius = Sqrt(IntAsDouble(x*x + y*y + z*z));
        return Sin(radius + phi) + Cos(IntAsDouble(x - y + z) * phi) + Exp(-((radius*radius)/18.0));
    }

    function DualDerivativeD(x : Int, y : Int, z : Int, phi : Double) : Double {
        return phi * Cos(IntAsDouble(x) + phi)
             - phi * Sin(IntAsDouble(y) - phi)
             + (1.0 / (1.0 + Abs(IntAsDouble(z)))) * Cos(IntAsDouble(z) * phi);
    }

    function Tanh(x : Double) : Double {
        return (Exp(2.0 * x) - 1.0) / (Exp(2.0 * x) + 1.0);
    }

    // DL encoding
    function EncodePointDL(f_value : Double, d_value : Double, phi : Double, energy : Double, phase : Double, amplitude : Double, embeddingDim : Int) : DLInfo {
        mutable embedding = new Double[embeddingDim];
        let seed = f_value + d_value + phi;

        for (index in 0..embeddingDim-1) {
            let phaseFactor = (IntAsDouble(index) + 1.0) * 0.61803398875;
            let channel = Tanh(
                Sin(seed * phaseFactor)
                + Cos((f_value - d_value + phi) * phaseFactor)
                + (energy / (IntAsDouble(index) + 2.0))
                - phase / (IntAsDouble(index) + 3.0)
            );
            set embedding w/= index <- Round(channel, 8);
        }

        let confidence = Round(1.0 / (1.0 + Abs(phase - amplitude)), 8);
        let latentNorm = Round(Sqrt(Sum(embedding, x -> x*x)), 8);

        return DLInfo("procedural-dl", "tanh", embedding, confidence, latentNorm);
    }

    // Build a point
    function TransformPoint(x : Int, y : Int, z : Int, phi : Double, embeddingDim : Int) : PointState {
        let f_value = AtemporalIrrationalF(x, y, z, phi);
        let d_value = DualDerivativeD(x, y, z, phi);

        let amplitude = Sqrt(Abs(f_value * d_value) + 1e-9);
        let frequency = Abs(f_value - d_value) + phi;
        let energy = Round(f_value*f_value + d_value*d_value, 8);
        let spin = Round(Sin(f_value + d_value), 8);
        let phase = Round((f_value + d_value)/2.0, 8);

        let particle = Particle(x, y, z, energy, spin);
        let wave = Wave(Round(amplitude, 8), Round(frequency, 8), phase);
        let dl = EncodePointDL(f_value, d_value, phi, energy, phase, amplitude, embeddingDim);

        return PointState(x, y, z, phi, Round(f_value, 8), Round(d_value, 8), particle, wave, dl);
    }

    // Generate full space
    function GenerateSpace(gridMin : Int, gridMax : Int, phi : Double, embeddingDim : Int) : PointState[] {
        mutable result = new PointState[0];
        for (x in gridMin..gridMax) {
            for (y in gridMin..gridMax) {
                for (z in gridMin..gridMax) {
                    set result += [TransformPoint(x, y, z, phi, embeddingDim)];
                }
            }
        }
        return result;
    }

    // Summarize statistics
    function SummarizeSpace(points : PointState[]) : (AvgEnergy : Double, AvgSpin : Double, AvgAmplitude : Double, AvgConfidence : Double, AvgLatentNorm : Double) {
        let n = IntAsDouble(Length(points));
        let avgEnergy = Round(Sum(points, p -> p::Particle::Energy) / n, 8);
        let avgSpin = Round(Sum(points, p -> p::Particle::Spin) / n, 8);
        let avgAmplitude = Round(Sum(points, p -> p::Wave::Amplitude) / n, 8);
        let avgConfidence = Round(Sum(points, p -> p::DL::Confidence) / n, 8);
        let avgLatentNorm = Round(Sum(points, p -> p::DL::LatentNorm) / n, 8);

        return (avgEnergy, avgSpin, avgAmplitude, avgConfidence, avgLatentNorm);
    }

    // Filters
    function FilterByEnergy(points : PointState[], minEnergy : Double) : PointState[] {
        return Filter(points, p -> p::Particle::Energy >= minEnergy);
    }

    function FilterByConfidence(points : PointState[], minConfidence : Double) : PointState[] {
        return Filter(points, p -> p::DL::Confidence >= minConfidence);
    }

    function FilterByEnergyAndConfidence(points : PointState[], minEnergy : Double, minConfidence : Double) : PointState[] {
        return Filter(points, p -> p::Particle::Energy >= minEnergy and p::DL::Confidence >= minConfidence);
    }

    // Top-N selectors
    function TopNByEnergy(points : PointState[], n : Int) : PointState[] {
        let sorted = SortBy(points, p -> -p::Particle::Energy);
        return Take(sorted, n);
    }

    function TopNByConfidence(points : PointState[], n : Int) : PointState[] {
        let sorted = SortBy(points, p -> -p::DL::Confidence);
        return Take(sorted, n);
    }

    // Combined Top-N by weighted score (Energy + Confidence)
    function TopNByScore(points : PointState[], n : Int, energyWeight : Double, confidenceWeight : Double) : PointState[] {
        let sorted = SortBy(points, p -> -(energyWeight * p::Particle::Energy + confidenceWeight * p::DL::Confidence));
        return Take(sorted, n);
    }

    // Export workflow
    operation ExportSpace(outputPath : String, gridMin : Int, gridMax : Int, phi : Double, embeddingDim : Int) : Unit {
        let space = GenerateSpace(gridMin, gridMax, phi, embeddingDim);
        let summary = SummarizeSpace(space);

        let highEnergyPoints = FilterByEnergy(space, 2.0);
        let reliablePoints = FilterByConfidence(space, 0.6);
        let elitePoints = FilterByEnergyAndConfidence(space, 2.0, 0.6);

        let topEnergy = TopNByEnergy(space, 10);
        let topConfidence = TopNByConfidence(space, 10);
        let topScore = TopNByScore(space, 10, 1.0, 1.0); // equal weights

        let jsonSerializer = new JsonSerializerOptions();
        let json = JsonSerializer.Serialize(space, jsonSerializer);

        Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
        File.WriteAllText(outputPath, json);

        Message($"✅ Export complete: {outputPath}");
        Message($"Summary -> AvgEnergy={summary::AvgEnergy}, AvgSpin={summary::AvgSpin}, AvgAmplitude={summary::AvgAmplitude}, AvgConfidence={summary::AvgConfidence}, AvgLatentNorm={summary::AvgLatentNorm}");
        Message($"Filtered -> HighEnergy={Length(highEnergyPoints)} points, Reliable={Length(reliablePoints)} points, Elite={Length(elitePoints)} points");
        Message($"Top 10 Energy -> First point energy={topEnergy[0]::Particle::Energy}");
        Message($"Top 10 Confidence -> First point confidence={topConfidence[0]::DL::Confidence}");
        Message($"Top 10 Overall Score -> First point score={(topScore[0]::Particle::Energy + topScore[0]::DL::Confidence)}");
    }

    @EntryPoint()
    operation Main() : Unit {
        ExportSpace("dist/wave-space.json", -5, 5, 1.0, 12);
    }
}
