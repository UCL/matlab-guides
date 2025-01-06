# matlab-guides
MATLAB code for educational / research guides.

This is the Git repo used to develop guides for education and research. The guides are in MATLAB LiveScript (notebooks) format. Some are under development and those completed are exported as PDF and `.m` files. There is also a `.m` file for creating the PowerPoint figures used in a Receiver Operating Characterisitc talk.
All are available from the folders in this GitHub repo, and the completed examples are also copied to [MATLAB Drive](https://drive.matlab.com) and can be run by users locally, or, in [MATLAB Online](https://matlab.mathworks.com) without needing to install MATLAB. They are available in MATLAB Drive using the sharing link (though there is a limit to the number of times the link can be used): 
https://drive.matlab.com/sharing/cd63980b-b7e2-4cfb-9a99-c3e060322513 

The folder structure is:

Guides  

    source/  - the LiveScript .mlx files. Run these locally, or in MATLAB Online  
    data/    - data required  
    mfile/   - the LiveScripts converted to .m files  
    PDF/     - the LiveScripts, with figure outputs, as PDF files (MATLAB not required to view).  
    figures/ROC - the `figuresROC.m` file used to create figures for a PowerPoint presentation

The current completed examples are:

    A1_getting_started  - A few basic points
    
    figures_overview    - Hints for plotting figures and data visualisation. 
    KaplanMeierPlot     - A Kaplan Meier survival plot using Cox's data.
    odds_plot           - Odds ratio plot using early Covid data
    
    samplingandse       - Sampling and Standard Error. Demonstrates picking random samples, histograms, plotting.  
    rocClassifier       - Receiver Operator Characteristic (ROC) curve plotting. Also scatter, swarmchart, box chart and histogram plots, confidence intervals from bootstrapping.  
    
    dicomHandling       - Introduction to handling DICOM files.

    reproducibility     - Tips for improving reproducibility of code and outputs.
    
    gitcontrol          - Using Git source code control

    MATLAB              - Some notes on MATLAB

    path_handling       -Notes on filepaths and file handling
    


The deployment process uses `buildtool` and a buildfile is included in this repository - this file might also be a useful example for those interested. I have limited experience with this so there may be better implementations. Nevertheless, it is proving to be a powerful way to update the mfile and PDF folders and copy data and code to MATLAB Drive.

