function buildFundamentals
    % buildFundamentals - Basic feedforward network example
    % This script creates and trains a simple fully connected network
    % and saves the trained model into the dist folder.

    % --- Generate synthetic training data ---
    % 100 samples, each with 10 features
    XTrain = rand(100,10);
    % Binary labels (0 or 1)
    YTrain = categorical(randi([0 1],100,1));

    % --- Define network layers ---
    layers = [
        featureInputLayer(10,"Name","input")
        fullyConnectedLayer(20,"Name","fc1")
        reluLayer("Name","relu1")
        fullyConnectedLayer(2,"Name","fc2")
        softmaxLayer("Name","softmax")
        classificationLayer("Name","output")];

    % --- Training options ---
    options = trainingOptions('adam', ...
        'MaxEpochs',15, ...
        'MiniBatchSize',32, ...
        'Shuffle','every-epoch', ...
        'Verbose',false, ...
        'Plots','training-progress');

    % --- Train the network ---
    netFund = trainNetwork(XTrain,YTrain,layers,options);

    % --- Save the trained model ---
    if ~exist('dist','dir')
        mkdir('dist');
    end
    save('dist/netFund.mat','netFund');

    disp('Fundamentals network built and saved successfully.');
end
