
## **Predicting the attributes of the unsampled locations by kriging utilizing the ‘gstat’ package**

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

###Methods
Kriging, also referred to as Gaussian process regression is an effective geostatistical method for interpolating the values that are modeled by a Gaussian process governed by prior covariance, as opposed to a piecewise–polynomial spline chosen to optimize smoothness of the fitted values.

Ordinary kriging is a method associated with linear unbiased estimation, as the estimations are weighed linear combination of available data. It does not take into account of the covariates – it assumes constant unknown mean and helps in minimizing error variance. It is the most commonly used method of kriging.

Universal kriging is similar but it includes a polynomial trend model, assumes covariates for interpolation (kriging under non-stationary conditions, in the presence of drift).

###Data
The data used here in this example case is Meuse river data.
Meuse dataset comprises the measures of four major heavy metals found in the top soil in a flood plain along the river Meuse, Belgium. This is crucial that the contamination happens just because of the river flow that moves the polluted sediments and deposits close to the river bank. This case makes it explicit for geostatistical analysis of the dataset.

###R-Package
[Package ‘gstat’](https://cran.r-project.org/web/packages/gstat/gstat.pdf) is used here in conjunction with the [package ‘sp’](https://cran.r-project.org/web/packages/sp/sp.pdf). 'gstat’ promotes a range of univariate and multivariate geostatistical modelling, prediction and simulation functions while ‘sp’ helps with class descriptions and methods for importing , exporting and visualizing spatial data.

###How to use
####Ordinary kriging
In order to use this tool, select the ComKriging script tool from the krig_tools.tbx toolbox in the ArcGIS environment. As you proceed, you will find this tool popped up as shown below in Figure:1.

![Figure:1.](https://github.com/san02/Images_GIS/blob/master/ordkrigtool.png)
#####<p align="center">Figure:1.</p>


The description of each of the parameters found in this pop-up tool is as follow.

1. **Input_feature  :** Input point feature containing fields of the dependant variable and all explanatory variables.
2. **Prediction_location  :** Input point feature representing locations where you would like to predict the probable values for the presence of  dependant variable. These point feature must have certain explanatory variables stored as fields.
3. **Dep_variable  :**  Field from the input feature containing the sampled attributes. A particular value gives the strength of the field element at that point.
4. **Using_log  :** Taking logarithmic values for the dependent variable.
5. **Partial_sill  :** (Partial) Sill of the variogram model component.
6. **Model  :** Model type, e.g. "Exp", "Sph", "Gau", "Mat".
7. **Range  :** Range of the variogram model component.
8. **Nugget  :** Nugget component of the variogram. (this basically adds a nugget compontent to the model)
9. **Output_krige  :**  Output krige shapefile that contains the predictions of the values of unsampled locations from the Prediction_location dataset.
10. **Output_var  :**  Output variance provides how far the values are deviated from the other and the mean and exports the output as a pdf file.

#####Steps to use the tool :
* The feature layers of meuse dataset is provided in this same repository within the data folder. Click the input_feature file icon and browse for the meuse feature class from meuse.gdb. 
* Click the Prediction_location file icon and browse for meuse_grid from the same meuse.gdb. 
* Click the drop down icon of dep_variable parameter and select for a variable (zinc in this case) to process prediction. 
* If needed, mark the Using_log icon to use the logarithmic values of the Variable.  
* Give the Values for the arguments (Partial_Sill, Model, Range, Nugget) of the Variogram model.
* Give output files for Output_krige and Output_var (Optional) if you want to change the default file selects. Finally click OK.

Once the inputs are given, the tool runs as shown below in Figure:2 and produces the output krige as a shapefile and variance-variogram plotted and exported as a pdf file as shown in Figure:3.


![Figure:2](https://github.com/san02/Images_GIS/blob/master/ordkrigtoolrun.png)
#####<p align="center">Figure:2.</p>


![figure:3](https://github.com/san02/Images_GIS/blob/master/ordkrigoutput.png)
#####<p align="center">Figure:3.</p>



####Universal kriging
In order to use this tool, select the UnivKrig script tool from the krig_tools.tbx toolbox in the ArcGIS environment. As you proceed, you will find this tool popped up as shown below in Figure:4.


![Figure:4.](https://github.com/san02/Images_GIS/blob/master/univkrigtool.png)
#####<p align="center">Figure:4.</p>


The description of each of the parameters found in this pop-up tool is as follow.

1. **Input_feature  :** Input point feature containing fields of the dependant variable and all explanatory variables.
2. **Prediction_location  :** Input point feature representing locations where you would like to predict the probable values for the presence of  dependant variable. These point feature must have certain explanatory variables stored as fields.
3. **Dep_variable  :** Input string that is a field from the input feature containing the sampled attributes. A particular value gives the strength of the field element at that point.
4. **Using_log  :** Taking logarithmic values for the dependent variable.
5. **Covariate_variable  :** INput string that is a field from the input feature containing independent or explanatory variables.
6. **vgm_model  :** Input for the vgm expression to fit the variogram (default : vgm(1,"Exp",300,1) - for Universal kriging)
7. **Output_krige  :**  Output krige shapefile that contains the predictions of the values of unsampled locations from the Prediction_location dataset.
8. **Output_var  :**  Output variance provides how far the values are deviated from the other and the mean and exports the output as a pdf file.


#####Steps to use the tool :

* This works in the same way as the ordinary krige tool with the same datasets provided in this repository. Click the input_feature file icon and browse for the meuse feature class from meuse.gdb. 
* Click the Prediction_location file icon and browse for meuse_grid from the same meuse.gdb. 
* Click the drop down icon of dep_variable parameter and select any heavy metal variable to process prediction. 
* Click the drop down icon of covariate parameter and select for the ‘dist’ variable to process prediction. 
* If needed, mark the Using_log icon to use the logarithmic values of the Variable.  
* Give the Values for the arguments (Partial_Sill, Model, Range, Nugget) in an expression vgm() to the Variogram model.
* Give output files for Output_krige and Output_var (Optional) if you want to change the default file selects. Finally click OK.

Once the inputs are given, the tool runs as shown below in Figure:5. and produces the output krige as a shapefile as shown in Figure:6. and variance-variogram plotted and exported as a pdf file.


![Figure:5.](https://github.com/san02/Images_GIS/blob/master/univkrigtoolrun.png)
#####<p align="center"> Figure:5.</p>


![Figure:6.](https://github.com/san02/Images_GIS/blob/master/univkrigoutput.png)
#####<p align="center">Figure:6.</p>



###References 
  [1] Pebesma, Edzer J. "Multivariable geostatistics in S: the gstat package."Computers & Geosciences 30.7 (2004): 683-691. 
  [2] Pebesma, Edzer, and Benedikt Gräler. "Spatio-temporal geostatistics using gstat." (2015).
 
