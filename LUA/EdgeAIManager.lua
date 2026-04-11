-- EdgeAIManager.lua
-- Edge-AI-APP
-- Created by Alexandre on 11/04/2026
-- Example extensive Lua file (English version)

-- Main class
EdgeAIManager = {}
EdgeAIManager.__index = EdgeAIManager

-- Constructor
function EdgeAIManager:new(modelName)
    local self = setmetatable({}, EdgeAIManager)
    self.modelName = modelName:match("^%s*(.-)%s*$") -- trim whitespace
    self.isConfigured = false
    return self
end

-- Load model
function EdgeAIManager:loadModel()
    print("Loading model: " .. self.modelName)
    -- Simulate loading
    os.execute("sleep 1")
    print("Model " .. self.modelName .. " loaded successfully.")
end

-- Configure options
function EdgeAIManager:configure(options)
    print("Configuring EdgeAIManager with options:")
    for k,v in pairs(options) do
        print("  " .. k .. " = " .. v)
    end
    self.isConfigured = true
end

-- Process input (simulation: reverse string)
function EdgeAIManager:processInput(input)
    print("Processing input of length: " .. #input)
    local reversed = input:reverse()
    print("Processing complete.")
    return reversed
end

-- Usage example
local manager = EdgeAIManager:new(" edge_ai_model.onnx ")
manager:loadModel()
manager:configure({quantization="int8", device="CPU"})

local inputData = "HelloEdgeAI"
local outputData = manager:processInput(inputData)
print("Output result: " .. outputData)
