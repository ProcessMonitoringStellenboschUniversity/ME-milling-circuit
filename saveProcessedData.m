function saveProcessedData(filename)
% SAVEPROCESSEDDATA     Extracts the system input and output variables,
% preprocesses the sensor data and saves the processed data to file
% SAVEPROCESSEDDATA(FILENAME)   Takes in a matfile containng the raw model sensor data

load(filename)
% extract timestamp
tout = dict.t;

% extract input variables
CFF = dict.CFF;
MFS = dict.MFS;
SFW = dict.SFW;
MIW = dict.MIW;

% extract output variables
SVOL = dict.SVOL;
JT = dict.JT;
Pmill = dict.Pmill;
CFD = dict.CFD;
PSE = dict.PSE;

%% Merge the input variables and fill missing values

InputTable = table(CFF, MFS, SFW, MIW);
varnamesIn = {'CFF', 'MFS', 'SFW', 'MIW'};

OutputTable = table(SVOL, JT, Pmill, CFD);
varnamesOut = {'SVOL', 'JT', 'Pmill', 'CFD'};

processedInputs = preprocessData(InputTable,varnamesIn);
processedOutputs = preprocessData(OutputTable,varnamesOut);

%% Save processed data to file

CFFprocessed = processedInputs.CFF;
MFSprocessed = processedInputs.MFS;
SFWprocessed = processedInputs.SFW;
MIWprocessed = processedInputs.MIW;

SVOLprocessed = processedOutputs.SVOL;
JTprocessed = processedOutputs.JT;
Pmillprocessed = processedOutputs.Pmill;
CFDprocessed = processedOutputs.CFD;

save processedInputs.mat CFFprocessed MFSprocessed SFWprocessed MIWprocessed
save processedOutputs.mat SVOLprocessed JTprocessed Pmillprocessed CFDprocessed


end