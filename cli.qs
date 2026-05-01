namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // Importa namespaces .NET para CLI
    open System;
    open System.IO;
    open System.Text.Json;

    operation Main_CLI() : Unit {
        // Captura argumentos da linha de comando
        let args = Environment.GetCommandLineArgs();

        mutable gridMin = -5;
        mutable gridMax = 5;
        mutable phi = 1.0;
        mutable output = "dist/wave-space.json";
        mutable withDL = false;
        mutable embeddingDim = 12;
        mutable showVersion = false;

        // Parse simples dos argumentos
        for (i in 0..Length(args)-1) {
            if (args[i] == "--grid-min" && i+1 < Length(args)) {
                set gridMin <- Int.Parse(args[i+1]);
            }
            if (args[i] == "--grid-max" && i+1 < Length(args)) {
                set gridMax <- Int.Parse(args[i+1]);
            }
            if (args[i] == "--phi" && i+1 < Length(args)) {
                set phi <- Double.Parse(args[i+1]);
            }
            if (args[i] == "--output" && i+1 < Length(args)) {
                set output <- args[i+1];
            }
            if (args[i] == "--with-dl") {
                set withDL <- true;
            }
            if (args[i] == "--embedding-dim" && i+1 < Length(args)) {
                set embeddingDim <- Int.Parse(args[i+1]);
            }
            if (args[i] == "--version") {
                set showVersion <- true;
            }
        }

        if (showVersion) {
            Message("#Q Semantic Version: 0.2.0");
            return ();
        }

        // Gera espaço de pontos
        let space = GenerateSpace(gridMin, gridMax, phi);

        // Serializa para JSON
        let jsonSerializer = new JsonSerializerOptions();
        let json = JsonSerializer.Serialize(space, jsonSerializer);

        // Cria diretório e salva arquivo
        Directory.CreateDirectory(Path.GetDirectoryName(output));
        File.WriteAllText(output, json);

        Message($"✅ generated={output}");
    }

    // Funções auxiliares (já definidas antes)
    function GenerateSpace(gridMin : Int, gridMax : Int, phi : Double) : PointState[] {
        mutable result = new PointState[0];
        for (x in gridMin..gridMax) {
            for (y in gridMin..gridMax) {
                for (z in gridMin..gridMax) {
                    set result += [TransformPoint(x, y, z, phi)];
                }
            }
        }
        return result;
    }

    function TransformPoint(x : Int, y : Int, z : Int, phi : Double) : PointState {
        let f_value = AtemporalIrrationalF(x, y, z, phi);
        let d_value = DualDerivativeD(x, y, z, phi);
        let amplitude = Sqrt(Abs(f_value * d_value) + 1e-9);
        let frequency = Abs(f_value - d_value) + phi;
        let energy = Round(f_value * f_value + d_value * d_value, 8);
        let spin = Round(Sin(f_value + d_value), 8);
        let phase = Round((f_value + d_value) / 2.0, 8);

        return PointState(x, y, z, phi, Round(f_value, 8), Round(d_value, 8), energy, spin, Round(amplitude, 8), Round(frequency, 8), phase);
    }
}
