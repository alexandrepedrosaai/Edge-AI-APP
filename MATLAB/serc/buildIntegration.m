function buildIntegration
    % BuildIntegration - Export and code generation for Edge-AI-APP
    
    % Attempt to install missing support packages
    try
        matlab.addons.installSupportPackage('Deep Learning Toolbox Converter for ONNX Model Format');
        matlab.addons.installSupportPackage('MATLAB Coder');
    catch
        warning('Could not install support packages automatically.');
    end

    % Use networks from workspace if available, otherwise load them
    if ~exist('netCNN', 'var')
        if exist('dist/netCNN.mat', 'file')
            load('dist/netCNN.mat','netCNN');
        else
            warning('netCNN.mat not found and netCNN not in workspace.');
        end
    end
    
    if ~exist('netLSTM', 'var')
        if exist('dist/netLSTM.mat', 'file')
            load('dist/netLSTM.mat','netLSTM');
        else
            warning('netLSTM.mat not found and netLSTM not in workspace.');
        end
    end
    
    % Export CNN and LSTM to ONNX (if support package is available and networks loaded)
    try
        if exist('netCNN', 'var')
            exportONNXNetwork(netCNN,'dist/cnn_model.onnx');
        end
        if exist('netLSTM', 'var')
            exportONNXNetwork(netLSTM,'dist/lstm_model.onnx');
        end
    catch ME
        warning('ONNX export failed. Ensure "Deep Learning Toolbox Converter for ONNX Model Format" is installed.');
        fprintf('Error: %s\n', ME.message);
    end
    
    % Quantization example (requires Deep Learning Toolbox Model Quantization)
    % qNet = dlquantizer(netCNN,'ExecutionEnvironment','CPU');
    % calibrate(qNet,augmentedImageDatastore([64 64],imageDatastore('dataset')));
    % save('dist/quantizedCNN.mat','qNet');
    
    % Generate C code for deployment (if MATLAB Coder is available and networks loaded)
    try
        if exist('netCNN', 'var')
            codegen netCNN -args {ones(64,64,3,'single')} -report
        end
        if exist('netLSTM', 'var')
            codegen netLSTM -args {ones(100,1,'single')} -report
        end
    catch ME
        warning('Code generation failed. Ensure "MATLAB Coder" is installed.');
        fprintf('Error: %s\n', ME.message);
    end
end
