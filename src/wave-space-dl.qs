namespace WaveSpaceDL {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open System;
    open System.IO;

    @EntryPoint()
    operation Main() : Unit {
        // Parse CLI args
        let args = Environment.GetCommandLineArgs();
        mutable outputPath = "dist/wave-space.json";
        mutable embeddingDim = 12;

        for (i in 0..Length(args)-1) {
            if (args[i] == "--output" && i+1 < Length(args)) {
                set outputPath <- args[i+1];
            }
            if (args[i] == "--embedding-dim" && i+1 < Length(args)) {
                set embeddingDim <- Int.Parse(args[i+1]);
            }
        }

        // Generate space
        let points = GenerateSpace(-5, 5, 1.0, embeddingDim);

        // Serialize to JSON
        Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
        File.WriteAllText(outputPath, JsonSerialize(points));

        Message($"✅ Wave-space generated at {outputPath} with {Length(points)} points");
    }

    // Example generator (simplified)
    function GenerateSpace(gridMin : Int, gridMax : Int, phi : Double, embeddingDim : Int) : String {
        // Here you would call TransformPoint for each coordinate and build JSON
        // For demo, return a placeholder JSON string
        return $"{{\"points\": {((gridMax-gridMin+1)*(gridMax-gridMin+1)*(gridMax-gridMin+1))}, \"phi\": {phi}, \"embedding_dim\": {embeddingDim}}}";
    }
}
