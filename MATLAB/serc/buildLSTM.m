function buildLSTM
    % BuildLSTM - LSTM network for time series prediction
    
    % Generate synthetic sequential data
    XTrain = num2cell(rand(100,1),2);
    YTrain = num2cell(sin(1:100)',2);
    
    % Define LSTM layers
    layers = [
        sequenceInputLayer(1)
        lstmLayer(100,'OutputMode','last')
        fullyConnectedLayer(1)
        regressionLayer];
    
    % Training options
    options = trainingOptions('adam', ...
        'MaxEpochs',50, ...
        'GradientThreshold',1, ...
        'Verbose',false, ...
        'Plots','training-progress');
    
    % Train network
    netLSTM = trainNetwork(XTrain,YTrain,layers,options);
    
    % Save model
    save('dist/netLSTM.mat','netLSTM');
end
