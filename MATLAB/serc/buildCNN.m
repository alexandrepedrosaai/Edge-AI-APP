function buildCNN
    % BuildCNN - Convolutional Neural Network for image classification
    
    % Load sample image dataset
    % Specify common image extensions to avoid errors with non-standard files
    imds = imageDatastore('dataset','IncludeSubfolders',true,'LabelSource','foldernames', ...
        'FileExtensions', {'.jpg', '.jpeg', '.png', '.bmp', '.tif', '.tiff'});
    augimds = augmentedImageDatastore([64 64],imds);
    
    % Define CNN layers
    layers = [
        imageInputLayer([64 64 3])
        convolution2dLayer(3,16,'Padding','same')
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2,'Stride',2)
        fullyConnectedLayer(numel(categories(imds.Labels)))
        softmaxLayer
        classificationLayer];
    
    % Training options
    options = trainingOptions('adam', ...
        'MaxEpochs',5, ...
        'MiniBatchSize',64, ...
        'Verbose',false, ...
        'Plots','training-progress');
    
    % Train network
    netCNN = trainNetwork(augimds,layers,options);
    
    % Save model
    save('dist/netCNN.mat','netCNN');
end
