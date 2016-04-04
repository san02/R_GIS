
## **Estimating the density of a point pattern and thereby simulating a point pattern with reference to the obtained density utilizing the ‘spatstat’ package**

Before proceeding to the example, you must have the following installed on your computer:
####Prerequisites
#####[ArcGIS 10.3.1](http://desktop.arcgis.com/en/arcmap/) or [ArcGIS Pro 1.1](http://pro.arcgis.com/en/pro-app/) ([don't have it? try a 60 day trial](http://www.esri.com/software/arcgis/arcgis-for-desktop/free-trial))
1. [R Statistical Computing Software, 3.1.0 or later](http://cran.cnr.berkeley.edu/bin/windows/base/)
 - 32-bit version required for ArcMap, 64-bit version required for ArcGIS Pro (Note: the installer installs both by default).
 - 64-bit version can be used with ArcMap by installing [Background Geoprocessing](http://desktop.arcgis.com/en/arcmap/10.3/analyze/executing-tools/64bit-background.htm) and configuring scripts to [run in the background](http://desktop.arcgis.com/en/arcmap/10.3/analyze/executing-tools/foreground-and-background-processing.htm).
2. [R ArcGIS Bridge](https://github.com/R-ArcGIS/r-bridge-install)

#####Setup Instructions

#####ArcGIS 10.3.1
 - In the Catalog window, navigate to the folder containing the Python Toolbox, R Integration.pyt. Note: You may have to first add a folder connection to the location that you extracted the files or downloaded via GitHub.
 - Open the toolbox, which should look like this:

![figurea](https://github.com/san02/Images_GIS/blob/master/new1.png)
  

 - Run the Install R bindings script. You can then test that the bridge is able to see your R installation by running the Print R Version and R Installation Details tools.

#####ArcGIS Pro 1.1
 - In the Project pane, either navigate to a folder connection containing the Python toolbox, or right click on Toolboxes > Add Toolbox and navigate to the location of the Python toolbox.
 - Open the toolbox, which should look like this:

 ![figureb](https://github.com/san02/Images_GIS/blob/master/new.png)

 -Run the Install R bindings script. You can then test that the bridge is able to see your R installation by running the Print R Version and R Installation Details tools.
 
##Term descriptions

###Method
Point pattern analysis (PPA) is the study of the spatial arrangements of points in (usually 2-dimensional) space. A point pattern is a datatype that is converted from a input point feature that can then be utilised for several analyses.  The foremost part of point pattern is its density estimation. 

kernel density estimation (KDE) is a non-parametric way to estimate the probability density function of a random variable. Kernel density estimation is a fundamental data smoothing problem where inferences about the population are made, based on a finite data sample. The kernel smoothed intensity function can be used to estimated kernel density in R.

The  'ppm' (point pattern model) is a function that fits the model for the point pattern with the estimated density and helps in simulating another point pattern according to the generated density using the function 'simulate'.  

###Data
The data used here in this example case is Meuse river data.
Meuse dataset comprises the measures of four major heavy metals found in the top soil in a flood plain along the river Meuse, Belgium. This is crucial that the contamination happens just because of the river flow that moves the polluted sediments and deposits close to the river bank. This case makes it explicit for geostatistical analysis of the dataset.

###R-Package
[Package ‘spatstat’](https://cran.r-project.org/web/packages/spatstat/spatstat.pdf) is used here in conjunction with the [package ‘sp’](https://cran.r-project.org/web/packages/sp/sp.pdf). 'spatstat’ promotes a range of statistical analyses of spatial data and mainly focuses on the analysis of spatial patterns of points in two-dimensional space. The points my carry auxiliart data and the spatial region in which the points were recorded may have arbitrary shape. It is designed to support a complete statistical analysis of spatial data. The ‘sp’ helps with class descriptions and methods for importing , exporting and visualizing spatial data.

###How to use
####Point pattern analysis
In order to use this tool, select the PointPat script tool from the Interp_simul_tools.tbx toolbox in the ArcGIS environment. As you proceed, you will find this tool popped up as shown below in Figure:1.

![Figure:1.](https://github.com/san02/Images_GIS/blob/master/PointPatTool.png)
#####<p align="center">Figure:1.</p>


The description of each of the parameters found in this pop-up tool is as follow.

1. **Input feature  :** Input point feature containing few or several fields on a specific theme.
2. **Output density  :** The estimated density of the point pattern obtained from the given input feature dataset.
3. **Output simulation  :** The simulated point pattern with reference to the generated density from the given input feature dataset.

#####Steps to use the tool :

* The feature layers of meuse dataset is provided in this same repository within the data folder. 
* Click the input_feature file icon and browse for the meuse feature class from meuse.gdb. 
* Give output files for Output density and Output simulation if you want to change the default file selects. Finally click OK.

Once the input is given, the tool runs point pattern estimation of density and simulation as shown below in Figure:2 and produces the output density and simulation of points as a shapefile as shown in Figure:3. 


![Figure:2](https://github.com/san02/Images_GIS/blob/master/PointPatToolrun.png)
#####<p align="center">Figure:2.</p>


![figure:3](https://github.com/san02/Images_GIS/blob/master/PointPatoutput.png)
#####<p align="center">Figure:3.</p>



###References 
  [1] Baddeley, Adrian, et al. "Package ‘spatstat’." (2015).
  
  [2] [Kernel smoothed internsity](http://www.inside-r.org/packages/cran/spatstat/docs/density.ppp)  function - Density estimation using spatstat.
  
  [3] [Fitting the Point pattern model](http://www.inside-r.org/packages/cran/spatstat/docs/ppm)  using spatstat.
