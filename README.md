![Alt Text](DeBiasLogo.PNG?raw=true "DeBias")
-------------
February 1st, 2017

### This repository includes DeBias' Matlab source code and test data
- DeBias decouples global bias from direct interactions in co-orientation and co-localization data. 
- Webserver: https://debias.biohpc.swmed.edu/
- Contact: Assaf Zaritsky - assafzar@gmail.com.


### Apply DeBias:
------------
1. Calculate GI and LI with DeBias for a set of observations x, y, output plots to `outDname`.
   The only required parameters are `x`,`y`,`isCoOrientation`, see documentation in the code regarding default values
    * `[GI,LI] = executeDebias(x,y,isCoOrientation,outDname,name,k,nSimulations)`

2. Execute DeBias on all files in a directory. 
   Supports input file formats `.xls`, `.txt` (two columns with the matched x,y observations) and `.mat` (variables x,y with the matched observations).   
    * `executeDebiasDirectory(dname,isCoOrientation,k)`

### Simulations:
-----------
- Generate `X`,`Y` values through simulations and use executeDebias 
    1. Co-orientation simulation (see Figure 1B):
        * `[X,Y] = generateCoOrientSimulationData(muX,sX,muY,sY,alpha,N);`
    2. Colocalization simulation (see Appendix 3 - figure 1A):
        * `[X,Y] = generateColocSimulationData(sX,sZ,N,fracColoc)`

### Example data:
------------
- Avaialble at the [testData](https://github.com/DanuserLab/DeBias/tree/master/testData) folder. Three experimental instances for co-orientation, one for co-localization and a simulated orientation dataset that include 4 instances from 2 different scenarios (Fig. 1C; data11-14: 𝜎X = 𝜎Y = 21, α = 0.2; data21-24: 𝜎X = 𝜎Y = 29, α = 0.4).

- The most recommended way to start working with the source code is to generate simulated data and try DeBias on it. For example:
    * `[X,Y] = generateCoOrientSimulationData(0,30,0,30,0.3,1000);`
    * `[GI,LI] = executeDebias(X,Y,true);`

### DeBias Analyst:
--------------
- Compares multiple GI,LI values derived from two different experimental conditions. 
- Outputs (GI,LI) plots (such as in Fig. 3D in the manuscript) and statistical significance of the GI and LI values across these conditions.
- See documentation in the code for details
    - `[GIpval,LIpval] = DeBiasAnalyst(GIs1,LIs1,GIs2,LIs2,str1,str2,outdir);`


### Automatic estimation of K:
-------------------------
- Estimate `K` (number of histogram bins for EMD calculations) using the Freedman Diaconis rule.
- DeBias' ability to discriminate between different experiemtnal conditions are not sensitive to the choice of `K` 
- (In the manuscript: Figure 3 - figure supplement 1D-E, Figure 6 - figure supplement 1I-J, Appendix 2 - figure 2, Appendix 3 - figure 1F).
- This function is provided for the curious user ;-)
- `data` - is the alignment data
    * `K = DeBiasGetK(data,isCoOrientation)`

------------------
#### Citation
- A webserver implementing this code is available at https://debias.biohpc.swmed.edu/, a comprehensive user manual is available at the web-site. 
    - Source code of the database and for setting the webserver are also available upon request.   

- Please cite the following manuscript when using the DeBias software:
   - [**Decoupling global biases and local interactions between cell biological variables**](http://dx.doi.org/10.7554/eLife.22323), *eLife*, 2017, 6:e22323, written by 
Assaf ZaritskyUri ObolskiZhuo GanCarlos R ReisZuzana KadlecovaYi DuSandra L Schmid, [Gaudenz Danuser](https://www.danuserlab-utsw.org/).

-----------------

Please contact Assaf Zaritsky, assafzar@gmail.com, for any questions / suggestions.

-----------------
For more work from the [Danuser Lab](https://www.danuserlab-utsw.org/)

(and [Software](https://github.com/DanuserLab/))
