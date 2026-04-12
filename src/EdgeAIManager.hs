-- EdgeAIManager.hs
-- Edge-AI-APP
-- Created by Alexandre on 11/04/2026
-- Example extensive Haskell file

module Main where

import Control.Concurrent (threadDelay)
import Data.Char (isSpace)

-- Definição do tipo Manager
data Manager = Manager {
    modelName    :: String,
    isConfigured :: Bool
} deriving Show

-- Função para criar um Manager
createManager :: String -> Manager
createManager name = Manager { modelName = trim name, isConfigured = False }

-- Função para carregar modelo
loadModel :: Manager -> IO ()
loadModel m = do
    putStrLn $ "Loading model: " ++ modelName m
    threadDelay 1000000
    putStrLn $ "Model " ++ modelName m ++ " loaded successfully."

-- Função para configurar opções
configure :: Manager -> [(String, String)] -> IO Manager
configure m options = do
    putStrLn "Configuring EdgeAIManager with options:"
    mapM_ (\(k,v) -> putStrLn $ "  " ++ k ++ " = " ++ v) options
    return m { isConfigured = True }

-- Função para processar entrada (inverter string)
processInput :: String -> IO String
processInput input = do
    putStrLn $ "Processing input of length: " ++ show (length input)
    let output = reverse input
    putStrLn "Processing complete."
    return output

-- Função auxiliar para trim
trim :: String -> String
trim = f . f
   where f = reverse . dropWhile isSpace

-- -------------------------------
-- Uso de exemplo
-- -------------------------------
main :: IO ()
main = do
    let manager = createManager " edge_ai_model.onnx "
    loadModel manager
    manager2 <- configure manager [("quantization","int8"), ("device","CPU")]
    outputData <- processInput "HelloEdgeAI"
    putStrLn $ "Output result: " ++ outputData
