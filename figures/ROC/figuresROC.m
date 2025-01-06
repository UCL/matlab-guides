function figuresROC(testType)
% figuresROC Figures for ROC presentation
%   Based on rocClassifier Live Script
%
% figuresROC
% figuresROC('ideal') - uses ideal distribution 
%
% Creates animated gif file
%
% Fix random seed so that we always get the same figure
%

if nargin == 0
    testType = 'default' ;
end

% Fix random seed
rngOriginal = rng ;
rng("twister") 

% Set up a simulation of data

% Mean test scores for reference-standard Positive cases and Negative cases
meanTestPositive = 20 ;
meanTestNegative = 10 ;

% Standard deviations of these test scores 
switch testType
    case 'ideal'
        stdTestPositive = 1 ; 
        stdTestNegative = 1 ; 
    otherwise
        stdTestPositive = 8 ; 
        stdTestNegative = 5 ; 
end


% Size of sample
numSubjects = 150 ;

% Prevalence: the percentage of the total in the test set that are positive
prevalencePercent = 20 ;

% Actual number of subjects Positive and Negative (acconting for rounding).
numPositive = round( prevalencePercent/100 * numSubjects ) ;
numNegative = numSubjects - numPositive ;

% Assign Labels for reference-standard Positive and Negative classes
posClassName = "Positive" ; negClassName = "Negative" ;

% Assign colours for Positive and Negative
posCol = [1 0 0] ; negCol = [0 0 1] ;

% Now simulate the test scores. 
% randn draws from a normal distribution with zero mean and std of 1.
% randn([numPositive 1]) returns a column vector with numPositive values
% multiply by required std and add the required mean
scoresOfPositives = ( randn([numPositive 1]) * stdTestPositive ) + meanTestPositive ;
scoresOfNegatives = ( randn([numNegative 1]) * stdTestNegative ) + meanTestNegative ;

% Group the all the positives then all the negatives, then randomly permute
% to simulate no particular order for the data.

p = randperm(numSubjects) ;  % determine a random order of the subjects

% Put rng seed back as we have finished getting random numbers
rng(rngOriginal) ;

scores = cat(1, scoresOfPositives, scoresOfNegatives ) ; % concatenate scores
scores = scores(p) ; % apply the random order determined above

Labels = cat(1, repmat(posClassName,[numPositive 1]), repmat(negClassName, [numNegative 1])) ; 
Labels = Labels(p) ;

refColours = cat(1, repmat(posCol,[numPositive 1]), repmat(negCol,[numNegative 1])) ;
refColours = refColours(p,:) ;

locNegative = (Labels == negClassName) ;
locPositive = (Labels == posClassName) ;

% Visualise Your Data: swarmchart, histogram and boxchart
% Before doing any numerical analysis, it is very useful to visualise your data. A simple thing is to just plot the scores using a scatter plot.

% Plot the values
hfpv = figure(Name="Data Points") ;
set(hfpv, 'DefaultAxesFontSize',18)

scatter(1:numSubjects, scores, [], refColours,"filled")
grid on
xlabel('Subject sequential order'), ylabel('Test Score')
title('Test Scores in Sequential Order')


hfts = figure(Name='Test Scores') ;
set(hfts, 'DefaultAxesFontSize',18)

catLabels = categorical(Labels) ; % The Labels as categorical variable
swarmchart(catLabels, scores, [], refColours, 'filled', ...
    'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5, 'XJitter','density', 'XJitterWidth',0.3)
title('Test Scores Grouped by Reference Class')
ylabel('Test score'), xlabel('Class label from reference standard')
grid on

% Calcuate ROC points
[X,Y,T,AUC,OPTROCPT] = perfcurve(Labels, scores, posClassName);


% Figure for PowerPoint - 
hf1 = figure(Name="Swarmchart PPT",Visible="on", Units="pixels", Position=[100 100 500 400]) ;
set(hf1, 'DefaultAxesFontSize',18)
hf1.MenuBar = 'figure' ;
s = swarmchart(catLabels, scores, [], refColours, 'filled', ...
    'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5, 'XJitter','density', 'XJitterWidth',0.3) ;
ylabel('Test score')
xlabel('Class label from reference standard')
grid on
ylim([-6 50]) 

hf2 = figure(Name="Swarmchart PPT2",Visible="on", Units="pixels", Position=[100 100 500 400]) ;
set(hf2, 'DefaultAxesFontSize',18)
hf2.MenuBar = 'figure' ;
s = swarmchart(catLabels, scores, [], refColours, 'filled', ...
    'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5, 'XJitter','density', 'XJitterWidth',0.3) ;
ylabel('Test score')
xlabel('Class label from reference standard')
grid on
ylim([-6 50]) 

switch testType
    case 'ideal'
        thresh_plot = 15 ;
    otherwise
        thresh_plot = 11 ;
end


hyl = yline(thresh_plot,'--','Threshold') ;
hyl.LineWidth = 2 ;
hyl.FontSize = 15 ;
hold on

axyl = ylim ;

rectangle('Position',[0.6 thresh_plot 1.6 axyl(2)-thresh_plot],'EdgeColor','none','FaceColor','red', 'FaceAlpha', 0.2)
rectangle('Position',[0.6 axyl(1) 1.6 thresh_plot-axyl(1)],'EdgeColor','none','FaceColor','blue', 'FaceAlpha', 0.2)

t = text(2.4,-5.5,'Test Negative','Rotation',90,'FontSize',15) ;
t = text(2.4,20,'Test Positive','Rotation',90,'FontSize',15) ;


% Animation
hfa = figure(Name="animation",Position=[150 150 800 400],Units="pixels");
set(hfa, 'DefaultAxesFontSize',18)

tiledlayout("horizontal","TileSpacing","loose")
axSwarm = nexttile;

swarmchart(axSwarm, catLabels, scores, [], refColours, 'filled', ...
    'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5, 'XJitter','density', 'XJitterWidth',0.3)

yl = yline(axSwarm,T(1),'LineWidth',2) ; 
grid on
ylabel('Test Score')
ylim([-6 50]) 

axROC = nexttile ;
plot(X, Y,'LineWidth',2)
hold(axROC,"on"), grid(axROC,"on") 
plot([0 1],[0 1],'k--','LineWidth',2)
hp = plot(X(1),Y(1),'bo','MarkerSize',10,'MarkerFaceColor','b') ;
title({'ROC Curve', ['AUC: ',num2str(AUC,2)]})
xlabel('False Positive Rate')
ylabel('True Positive Rate')
xlim([-0.02 1.02])
ylim([-0.02 1.02])



Tanim = cat(1,T,T(end:-1:1)) ;
Xanim = cat(1,X, X(end:-1:1)) ;
Yanim = cat(1,Y, Y(end:-1:1)) ;

clear im
for ithresh = 1:length(Tanim)
    yl.Value = Tanim(ithresh) ;
    hp.XData = Xanim(ithresh) ;
    hp.YData = Yanim(ithresh) ;
    drawnow
    frame = getframe(hfa);
    im{ithresh} = frame2im(frame);
end

% Park at optimum for another screen grab
switch testType
    case 'ideal'
        locOpt = find(X==0 & Y==1) ;
    otherwise
        yPreset = 0.9 ;
        [~,itpr] = min(abs(Y - yPreset)) ; % itpr is index into Y, the true positive rate
        locOpt = itpr(1) ; % In case there is more than one point equi-distant from yPreset
end

yl.Value = T(locOpt) ;
hp.XData = X(locOpt) ;
hp.YData = Y(locOpt) ;

gifFile = ['threshold_animation_', testType,'.gif'] ;
for idx = 1:length(Tanim)
    [A, map] = rgb2ind(im{idx},256) ;
    if idx == 1
        imwrite(A,map,gifFile,"gif",LoopCount=60000, ...
                DelayTime=0.075)
    else
        imwrite(A,map,gifFile,"gif",WriteMode="append", ...
                DelayTime=0.075)
    end
end
disp(['Written file: ',gifFile])

% Confidence Interval

hfc = figure(Name="Confidence Interval");
set(hfc,'DefaultAxesFontSize',18)
axc = gca ;
% Use Bootstrapping in perfcurve. Note Xb,Yb and AUCb outputs have 3 columns -
% the value, its lower limit and its upper limit.
[Xb,Yb,Tb,AUCb] = perfcurve(Labels,scores,posClassName,'NBoot', 1000);

plot(Xb(:,1), Yb(:,1),'LineWidth',3)
hold(axc,"on"), grid(axc,"on") 
plot([0 1],[0 1],'k--','LineWidth',2)
xlabel('False Positive Rate')
ylabel('True Positive Rate')
xlim([-0.02 1.02])
ylim([-0.02 1.02])

title({"ROC Curve", ['AUC = ', num2str(AUCb(1),2), ' (', ...
    num2str(AUCb(2),2), ', ', num2str(AUCb(3),2), ')']})

% At a pre-determined Sensitivity (y value) of 90%
yPreset = 0.9 ;
[~,itpr] = min(abs( Yb(:,1) - yPreset)) ; % itpr is index into Yb, the true positive rate

ind = itpr(1) ; % In case there is more than one point equi-distant from yPreset

% text(0.3,0.2,"For a Sensitivity of "+Yb(ind,1)*100 +"%, threshold is "+Tb(ind))

% errorbar(x,y,yneg,ypos,xneg,xpos)
eb = errorbar(Xb(ind,1), Yb(ind,1), Yb(ind,1)-Yb(ind,2), Yb(ind,3)-Yb(ind,1), ...
                                    Xb(ind,1)-Xb(ind,2), Xb(ind,3)-Xb(ind,1) ) ;

eb.LineWidth = 2 ; eb.Color = [1 0 0] ;