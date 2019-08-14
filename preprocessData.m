function processedData = preprocessData(data, varnames)
% Process Data
% Fill the missing values with the last measured value
% This reduces the effect of sudden steps in the data (such as the case of 
% setting missing values to zero) and the introduction of high frequency
% components in the data
missingValuesFilled = fillmissing(data, 'previous');

%% Detect and remove outliers
% it is important to complete this step before filtering noise, otherwise
% outliers will be preserved in the denoised signal
outliersRemoved = filloutliers(missingValuesFilled, 'linear', 'movmedian',60*2);

%% filter noise

% Design a moving average filter to reduce the effect of the white noise
samplesPerHour = 60*2; % using a 1hr smoothing window
coefficients = ones(1, samplesPerHour)/samplesPerHour;

denoisedData = table;
for i=1:width(outliersRemoved)
    denoisedData{:,i} = filter(coefficients, 1, outliersRemoved{:,i});  
end

denoisedData.Properties.VariableNames = varnames;

processedData = denoisedData;
end
