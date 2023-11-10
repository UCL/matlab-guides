function plan = buildfile
% BUILDFILE
% buildfile for Project education. Workflow: edit .mlx, test, Clear All
% Output, run buildtool.
% 
% Somewhat experimental as this is first time I have used this 
% functionality. Not really needed for so few files!
%
% Run from education Project top level folder
%
% Tasks:
%   exportmPDF
%   MDriveNonData  (Default). Has exportmPDF as dependency
%   MDriveData
%
% Example
% buildtool  
% buildtool exportmPDF
% buildtool MDriveData
% 
%
% David Atkinson, University College London
%

% Could probably be tidied up. 
% Check for extra files in MDrive that should be deleted?
% Needs folders to exist on MDrive

% Create a plan from task functions
plan = buildplan(localfunctions);

% Make the "MDriveSource" task the default task in the plan
plan.DefaultTasks = "MDriveNonData";

% Make the "MDriveNonData" task dependent on the "exportmPDF" task
plan("MDriveNonData").Dependencies = ["exportmPDF"] ;

% FileCollection of LiveScripts to be deployed (along with their .m and
% .pdf exports)
fc = files(plan, {'source/samplingandse.mlx', ...
                  'source/rocClassifier.mlx', ...
                  'source/01_getting_started.mlx'} ) ;

MDriveGuidesFolder = fullfile(getenv('HOME'), '/MATLAB-Drive/Teaching/Guides') ;

plan("exportmPDF").Inputs = fc ;

plan("MDriveNonData").Inputs = fc ;
plan("MDriveNonData").Outputs = MDriveGuidesFolder  ;

% Data
dataMIT = 'data/MITOCW/IntroCompThinkingandDataScienceLecture8/temperatures.csv' ;
plan("MDriveData").Inputs =  dataMIT ;
plan("MDriveData").Outputs = fullfile(MDriveGuidesFolder, dataMIT ) ;

end

% - - - 
function exportmPDFTask(context)
% Save LiveScripts locally as .m and .pdf files
% Expects LiveScripts to be in a folder called source
filePaths = context.Task.Inputs.paths ;
for ifile = 1: length(filePaths)
    mlxFile = filePaths{ifile} ;
    [path_this, name_this, ext_this] = fileparts(mlxFile) ;
    [path_up, name_up ] = fileparts(path_this) ;
    if ~strcmp(name_up,'source') || ~strcmp(ext_this,'.mlx')
        warning('Unexpected filestructure')
    end
 
    disp("Starting exports for: "+name_this)
    export(mlxFile, fullfile(path_up, 'mfile', name_this) , Format="m" )
    export(mlxFile, fullfile(path_up, 'PDF', name_this), Format="pdf", Run=true)

end

end


% - - - 
function MDriveNonDataTask(context)
% For the specified .mlx LiveScripts, put .mlx, .m, .pdf copies in MATLAB Drive
filePaths = context.Task.Inputs.paths ;
for ifile = 1: length(filePaths)
    mlxFile = filePaths{ifile} ;
    MDriveGuidesFolder = context.Task.Outputs.paths ;

    % Copy .mlx, .m and pdf
    [path_this, name_this, ext_this] = fileparts(mlxFile) ;
    [path_up, name_up ] = fileparts(path_this) ;
    if ~strcmp(name_up,'source') || ~strcmp(ext_this,'.mlx')
        warning('Unexpected filestructure')
    end

    statmlx = copyfile( mlxFile, fullfile(MDriveGuidesFolder, 'source')) ;
    statm   = copyfile( fullfile(path_up, 'mfile', [name_this '.m']), fullfile(MDriveGuidesFolder, 'mfile')) ;
    statpdf = copyfile( fullfile(path_up, 'PDF', [name_this '.pdf']), fullfile(MDriveGuidesFolder, 'PDF')) ;

    if statmlx == 1 && statm == 1 && statpdf == 1
        disp("Copied "+ mlxFile + " , .m and .pdf to " + MDriveGuidesFolder )
    else
        disp("Copy failed for files related to: " + mlxFile)
    end
end

end

% - - - 
function MDriveDataTask(context)
% Put copy of data in MATLAB Drive
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