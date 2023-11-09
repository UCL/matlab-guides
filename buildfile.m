function plan = buildfile
% BUILDFILE
%
% Example
% buildtool MDriveSource
% buildtool MDriveData
% 

% Could probably be tidied up to one Task for source, data and the
% getting_started file.

% Create a plan from task functions
plan = buildplan(localfunctions);

% Make the "MDriveSource" task the default task in the plan
plan.DefaultTasks = "MDriveSource";

% FileCollection
fc = files(plan, {'source/samplingandse.mlx', 'source/rocClassifier.mlx'} ) ;

plan("MDriveSource").Inputs = fc ;
plan("MDriveSource").Outputs = fullfile(getenv('HOME'), '/MATLAB-Drive/Teaching/Guides/source') ;

% Data
dataMIT = 'data/MITOCW/IntroCompThinkingandDataScienceLecture8/temperatures.csv'
plan("MDriveData").Inputs =  dataMIT ;
plan("MDriveData").Outputs = fullfile(getenv('HOME'), '/MATLAB-Drive/Teaching/Guides', dataMIT ) ;

end

function MDriveSourceTask(context)
% Put copy in MATLAB Drive
filePaths = context.Task.Inputs.paths ;
for ifile = 1: length(filePaths)
    [status, messg] = copyfile( filePaths{ifile}, context.Task.Outputs.paths ) ;
    if status == 1
        disp("Copied "+ filePaths{ifile} + " to " + context.Task.Outputs.paths )
    else
        disp("Copy failed: " + messg)
    end
end

end


function MDriveDataTask(context)
% Put copy in MATLAB Drive
filePaths = context.Task.Inputs.paths ;
for ifile = 1: length(filePaths)
    [status, messg] = copyfile( filePaths{ifile}, context.Task.Outputs.paths ) ;
    if status == 1
        disp("Copied "+ filePaths{ifile} + " to " + context.Task.Outputs.paths )
    else
        disp("Copy failed: " + messg)
    end
end

end