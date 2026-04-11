function buildFundamentals
    % BuildFundamentals - Basic feedforward network example
    % Creates a simple fully connected network for demonstration
    
    % Sample training data
    XTrain = rand(100,10);
    YTrain = randi([0 1],100,1);
    
    % Define layers
    layers = [
        featureInputLayer(10)
        fullyConnectedLayer(20)
        reluLayer
        fullyConnectedLayer(2)
        softmaxLayer
        classificationLayer];
    
    % Training options
    options = trainingOptions('adam', ...
        'MaxEpochs',10, ...
        'Verbose',false);
    
    % Train network
    netFund = trainNetwork(XTrain,YTrain,layers,options);
    
    % Save model
    save('dist/netFund.mat','netFund');
end
