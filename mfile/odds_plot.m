%% Odds Ratio Plot
% Demonstration of plotting odds ratio data. 
% 
% Data comes from Supplementary Table 1 used in Figure 1 of "_Real-time tracking 
% of self-reported symptoms to predict potential COVID-19_" Menni et al, Nature 
% Medicine (2020). <https://doi.org/10.1038/s41591-020-0916-2 https://doi.org/10.1038/s41591-020-0916-2> 
% 
% Requires the spreadsheet file '|41591_2020_916_MOESM3_ESM|.|xlsx|' to be in 
% the '|data|' folder
% 
% Copyright 2023 University College London, David Atkinson, <mailto:D.Atkinson@ucl.ac.uk 
% D.Atkinson@ucl.ac.uk>

rpathFolder = "data/MenniNatMed" ;  % Correct if this script is run from folder above 'source'. 
rdataFullFilename = fullfile(rpathFolder, "41591_2020_916_MOESM3_ESM.xlsx") ;

if ~exist(rdataFullFilename,"file")
    pathThisScript  = fileparts(matlab.desktop.editor.getActiveFilename) ;
    pathAboveScript = fileparts(pathThisScript) ;
    rdataFullFilename = fullfile(pathAboveScript, rdataFullFilename)  ;
end
%% 
% Read in the spreadsheet data.You can use |uiimport| to start the Import Tool 
% and gain an understanding of the data and how it might be read. With a basic 
% table such as this, the data can be read into a table easily:

TB = readtable(rdataFullFilename) 
%% 
% TB is a table, here with 13 variables (one row for each symptom) and 7 columns.
% 
% The columns can be accessed using dot notation, for example: |uk_lower_odds 
% = TB.l_uk|

nvar = size(TB,1) ; % number of variables (1 here indicates the rows dimension)

hfig = figure('Name','Odds Plot') ; % open new figure and axes, get handles
hax = axes ;

hold on

% Loop over each variable in the table, ploting a marker at the actual odds ratio (o_uk)
% and drawing a line from the lower (l_uk) to upper (u_uk) data for the UK
% only.
% Space each line vertically by 1.

for ivar = 1:nvar
    % plot marker first, then the line so that the line is in front
    plot(TB.o_uk(ivar), ivar, ...
        'MarkerSize',6,'Marker','diamond', 'MarkerFaceColor','red') % plots marker 

    
    xs = [TB.l_uk(ivar) TB.u_uk(ivar)] ; % start and end x coordinates of line
    ys = [ivar          ivar] ;          % start and end y coordinates of line
    plot(xs, ys, 'LineWidth',3,'Color','k') % plots line
end

xline(1,'Linewidth',2) ; % A vertical line to show where odds ratio = 1.

grid on  % helps reader

% Improve plot appearance and labelling 
xlabel('Odds Ratio')
title('UK results')

hax.YTick = [1:nvar] ; 
hax.YTickLabel = TB.var ; % Use the variable (symptom) names for the y axis labels.
hax.TickLabelInterpreter = 'none' ; % Otherwise it treats "_" as a LaTeX character.
hax.FontSize = 16 ; % this has to come AFTER text has been written
hax.YDir = 'reverse' ;
hax.LineWidth = 1 ;
%% 
% Comparison with the figure in the journal shows that the journal figure does 
% not include sore throat or headache.
% 
% 

% If you want a log x-scale, uncomment these lines
% hax.XScale = 'log' ; 
% hax.XTick = [0.5 1 2 4 8] ;
% hax.XLim = [0.4 8.1] ;