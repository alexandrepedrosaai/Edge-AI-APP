// EdgeAIManager.fs
// Edge-AI-APP
// Created by Alexandre on 11/04/2026
// Example extensive F# file

open System
open System.Text

type EdgeAIManager(modelName : string) =
    let mutable isConfigured = false
    let mutable name = modelName.Trim()

    member this.ModelName
        with get() = name
        and set(value) = name <- value.Trim()

    member this.IsConfigured
        with get() = isConfigured
        and set(value) = isConfigured <- value

    member this.LoadModel() =
        printfn "Loading model: %s" name
        System.Threading.Thread.Sleep(1000)
        printfn "Model %s loaded successfully." name

    member this.Configure(options : Map<string,string>) =
        printfn "Configuring EdgeAIManager with options:"
        options |> Map.iter (fun k v -> printfn "  %s = %s" k v)
        isConfigured <- true

    member this.ProcessInput(input : string) =
        printfn "Processing input of length: %d" input.Length
        let output = new string(Array.rev(input.ToCharArray()))
        printfn "Processing complete."
        output

// -------------------------------
// Usage Example
// -------------------------------
[<EntryPoint>]
let main argv =
    let manager = EdgeAIManager(" edge_ai_model.onnx ")
    manager.LoadModel()
    manager.Configure(Map.ofList [("quantization","int8"); ("device","CPU")])

    let inputData = "HelloEdgeAI"
    let outputData = manager.ProcessInput(inputData)
    printfn "Output result: %s" outputData
    0
