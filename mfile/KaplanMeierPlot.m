%% Kaplan-Meier plot
% Copyright 2020-2023, University College London, David Atkinson, <mailto:D.Atkinon@ucl.ac.uk 
% D.Atkinson@ucl.ac.uk>
% 
% Demonstrates the use of |stairs| to produce a Kaplan-Meier survival plot, 
% as well as some other methods to improve the appearance of a figure.
% 
% Data has been input manually from the file gehan.txt available in the |data/Cox| 
% folder. The file gehan.txt was adapted from that used by German Rodriguez of 
% Princeton University:  <https://grodri.github.io/survival/gehan https://grodri.github.io/survival/gehan> 

% Manually entered data from gehan.txt file.
% In future, will look at reading into a Table and processing.
treated_weeks =     [6 6 6 6 7 9 10 10 11 13 16 17 19 20 22 23 25 32 32 34 35] ;
treated_censoring = [0 0 0 1 0 1  0  1  1  0  0  1  1  1  0  0  1  1  1  1  1];

control_weeks =     [1 1 2 2 3 4 4 5 5 8 8 8 8 11 11 12 12 15 17 22 23 ] ;
control_censoring = [0 0 0 0 0 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0  0 ] ;

% ecdf is MATLAB's Empirical Cumulative Distribution Function
[fc, xc] = ecdf(control_weeks, 'Function','survivor', 'Censoring', control_censoring) ;
[ft, xt] = ecdf(treated_weeks, 'Function','survivor', 'Censoring', treated_censoring) ;

stairs(xc, fc)  % control plotted using stairs function
hold on
%%
% For the treated, here we add a 'fake' point at the beginning.
% This corresponds to a survivor function of 1 at week 0.

ft = [1 ; ft] ;  % first survivor function point is now 1
xt = [0 ; xt ] ; % first time point is now 0

stairs(xt,ft)
hold off, grid on

legend('control','treated')
xlabel('Weeks')
ylabel('Survivor function')
ylim([0 1.1])  % adjust the y-axis limits for clarity
set(gca,'FontSize', 14)

% To control the LineWidth, you can find the Stair objects and then set both the
% LineWidths using set
% (You cannot just do hstairs.LineWidth = 2 because there is more than one
% stair plot and hstairs is an array. However, set will work.
hstairs = findobj('Type','Stair') ;
set(hstairs, 'LineWidth',2) 
%% 
% 
% 
% _David Atkinson, December 2023_