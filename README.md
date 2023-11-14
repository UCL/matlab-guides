# matlab-guides
MATLAB code for educational / research guides.

This is the Git repo used to develop the guides for education and research. The guides are MATLAB LiveScripts with copies of the completed scripts exported as `.m` files and PDF documents. 
All are available from the folders in this GitHub repo, and the completed examples are copied to [MATLAB Drive](https://drive.matlab.com) and can be run by users locally, or, in [MATLAB Online](https://matlab.mathworks.com) without needing to install MATLAB. They are available in MATLAB Drive using the sharing link: 
https://drive.matlab.com/sharing/cd63980b-b7e2-4cfb-9a99-c3e060322513 

The folder structure is:

Guides  


    source/  - the LiveScript .mlx files. Run locally or in MATLAB Online  
    data/    - data required  
    mfile/   - the LiveScripts converted to .m files  
    PDF/     - the LiveScripts as PDF files, including the figure outputs.  

The current examples are:

    A1_getting_started  - A few basic points
    figures_overview    - Hints for plotting figures and data visualisation. 
    samplingandse       - Sampling and Standard Error. Demonstrates picking random samples, histograms, plotting.  
    rocClassifier       - Receiver Operator Characteristic (ROC) curve plotting. Also scatter and swarmchart plots, confidence intervals from bootstrapping.  
    dicomHandling       - Introduction to handling DICOM files.
    KaplanMeierPlot     - A Kaplan Meier survival plot using Cox's data.
    odds_plot           - Odds ratio plot using early Covid data



The deployment from this repo locally uses `buildtool` and a buildfile is included here - this might be a useful example for those interested,  although I have limited experience so there may be better implementations.

