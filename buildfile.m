function plan = buildfile
% BUILDFILE
% buildfile for Project education. Workflow: edit .mlx, test, Clear All
% Output, run buildtool.
% 
% Somewhat experimental as this is first time I have used this 
% functionality. Not really needed for so few files!
%
% Clear output in LiveScripts.
% Run from education Project top level folder
%
% Tasks:
%   exportmPDF
%   MDriveNonData  (Default). Has exportmPDF as dependency
%   MDriveData  This will copy ALL fi;es and folders below data.
%
% Example
% buildtool  
% buildtool exportmPDF
% buildtool MDriveData
% 
%
% David Atkinson, University College London
%

import matlab.buildtool.io.FileCollection

% Could probably be tidied up. 
% Check for extra files in MDrive that should be deleted?
% Needs folders to exist on MDrive

% Create a plan from task functions
plan = buildplan(localfunctions);

% Make the "MDriveSource" task the default task in the plan
plan.DefaultTasks = "MDriveNonData";

% Make the "MDriveNonData" task dependent on the "exportmPDF" task
plan("MDriveNonData").Dependencies = "exportmPDF" ;

% FileCollection of LiveScripts to be deployed (along with their .m and
% .pdf exports)
fc = files(plan, {'source/samplingandse.mlx', ...
                  'source/rocClassifier.mlx', ...
                  'source/A1_getting_started.mlx', ...
                  'source/figures_overview.mlx', ...
                  'source/odds_plot.mlx', ...
                  'source/dicomHandling.mlx', ...
                  'source/KaplanMeierPlot.mlx'} ) ;

MDriveGuidesFolder = fullfile(getenv('HOME'), '/MATLAB-Drive/Teaching/Guides') ;

plan("exportmPDF").Inputs = fc ;

plan("MDriveNonData").Inputs = fc ;
plan("MDriveNonData").Outputs = MDriveGuidesFolder  ;

% Data (relative paths) See LiveScripts for data sources
% % rdataMIT = 'data/MITOCW/IntroCompThinkingandDataScienceLecture8/temperatures.csv' ;
% % rdataOdds = 'data/MenniNatMed/41591_2020_916_MOESM3_ESM.xlsx' ;
% % rdataKaplan = 'data/Cox/gehan.txt' ;
% % 
% % fcdatain = files(plan, { rdataMIT, rdataOdds, rdataKaplan }) ;
% % 
% % fcdataout = files(plan, {fullfile( MDriveGuidesFolder, rdataMIT), ...
% %                          fullfile( MDriveGuidesFolder, rdataOdds), ...
% %                          fullfile( MDriveGuidesFolder, rdataKaplan) }) ;

% This will copy ALL data below the data folder
fc_data_rin = FileCollection.fromPaths("data/**/*" ) ;
fcdataout  =  FileCollection.fromPaths(fullfile( MDriveGuidesFolder)) ;

plan("MDriveData").Inputs =  fc_data_rin ;
plan("MDriveData").Outputs = fcdataout ;

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
fileInPaths  = context.Task.Inputs.paths' ; % expect list of folders and files
fileOutPaths = context.Task.Outputs.paths ; % single root folder for data

if length( fileOutPaths) ~= 1
    error("Expecting one root folder for data output")
end

% Check inputs start with 'data' 
in1char = char(fileInPaths(1)) ;
if ~strcmp(in1char(1:4),'data')
    error("Expecting input names to start with data")
end

for ipath = 1: length( fileInPaths )
    outpath_this = fullfile(fileOutPaths, fileInPaths(ipath)) ;

    if isfolder( fileInPaths(ipath) )
        % folder so make folder
        [status, msg] = mkdir(outpath_this) ;
        if status == 0
            warning("Problem with mkdir for: "+outpath_this+"  "+msg)
        end
    elseif isfile(fileInPaths(ipath) )
        % file so copy
        [status, messg] = copyfile( fileInPaths(ipath), outpath_this ) ;
        if status == 1
            disp("Copied "+ fileInPaths(ipath) + " to " + outpath_this )
        else
            disp("Copy failed: " + messg)
        end

    else
        error("Neither folder nor file for: "+fileInPaths(ipath))
    end
end


end