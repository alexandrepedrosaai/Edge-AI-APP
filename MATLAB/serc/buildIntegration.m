function buildIntegration
    % BuildIntegration - Export and code generation for Edge-AI-APP
    
    % Load previously trained networks
    load('dist/netCNN.mat','netCNN');
    load('dist/netLSTM.mat','netLSTM');
    
    % Export CNN to ONNX
    exportONNXNetwork(netCNN,'dist/cnn_model.onnx');
    
    % Export LSTM to ONNX
    exportONNXNetwork(netLSTM,'dist/lstm_model.onnx');
    
    % Quantization example (requires Deep Learning Toolbox Model Quantization)
    % qNet = dlquantizer(netCNN,'ExecutionEnvironment','CPU');
    % calibrate(qNet,augmentedImageDatastore([64 64],imageDatastore('dataset')));
    % save('dist/quantizedCNN.mat','qNet');
    
    % Generate C code for deployment
    codegen netCNN -args {ones(64,64,3,'single')} -report
    codegen netLSTM -args {ones(100,1,'single')} -report
end
