function processedData = preprocessData(data, varnames, tout)
% Process Data
% Fill the missing values with the last measured value
% This reduces the effect of sudden steps in the data (such as the case of 
% setting missing values to zero) and the introduction of high frequency
% components in the data
missingValuesFilled = fillmissing(data, 'previous');

%% Remove start-up and shut-down states
% this will be dealt with more elegantly in the model maintenance portion
% of the workshop

idx = tout>=4 & tout <=8;
missingValuesFilled(idx,:) = [];

%% Detect and remove outliers
% it is important to complete this step before filtering noise, otherwise
% outliers will be preserved in the denoised signal
outliersRemoved = filloutliers(missingValuesFilled, 'linear', 'movmedian',60*2);

%% filter noise
% Design a moving average filter to reduce the effect of the white noise
windowSize = 30*2; % using a 1/2hr smoothing window
coefficients = ones(1, windowSize)/windowSize;

denoisedData = table;
for i=1:width(outliersRemoved)
    denoisedData{:,i} = filter(coefficients, 1, outliersRemoved{:,i});  
end

denoisedData.Properties.VariableNames = varnames;

processedData = denoisedData;
end
