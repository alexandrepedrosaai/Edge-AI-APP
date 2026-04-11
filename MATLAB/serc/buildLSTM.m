function buildLSTM
    % BuildLSTM - LSTM network for time series prediction
    
    % Generate synthetic sequential data
    XTrain = {rand(100,1)};
    YTrain = sin(100); % Single numeric response for sequence-to-one regression
    
    % Define LSTM layers
    layers = [
        sequenceInputLayer(100)
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
    if ~exist('dist', 'dir')
        mkdir('dist');
    end
    save('dist/netLSTM.mat','netLSTM');
end
