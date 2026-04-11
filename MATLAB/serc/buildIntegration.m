function buildIntegration
    % BuildIntegration - Export and code generation for Edge-AI-APP
    
    % Load previously trained networks
    load('dist/netCNN.mat','netCNN');
    load('dist/netLSTM.mat','netLSTM');
    
    % Export CNN and LSTM to ONNX (if support package is available)
    try
        exportONNXNetwork(netCNN,'dist/cnn_model.onnx');
        exportONNXNetwork(netLSTM,'dist/lstm_model.onnx');
    catch ME
        warning('ONNX export failed. Ensure "Deep Learning Toolbox Converter for ONNX Model Format" is installed.');
        fprintf('Error: %s\n', ME.message);
    end
    
    % Quantization example (requires Deep Learning Toolbox Model Quantization)
    % qNet = dlquantizer(netCNN,'ExecutionEnvironment','CPU');
    % calibrate(qNet,augmentedImageDatastore([64 64],imageDatastore('dataset')));
    % save('dist/quantizedCNN.mat','qNet');
    
    % Generate C code for deployment (if MATLAB Coder is available)
    try
        codegen netCNN -args {ones(64,64,3,'single')} -report
        codegen netLSTM -args {ones(100,1,'single')} -report
    catch ME
        warning('Code generation failed. Ensure "MATLAB Coder" is installed.');
        fprintf('Error: %s\n', ME.message);
    end
end
