
## **Predicting the attributes of the unsampled locations using kriging with the ‘gstat’ package**

##Term descriptions

1. shankar
2. lingam
3. shan
4. san

###Methods
Kriging, also referred to as Gaussian process regression is an effective geostatistical method for interpolating the values that are modeled by a Gaussian process governed by prior covariance, as opposed to a piecewise–polynomial spline chosen to optimize smoothness of the fitted values.

Ordinary kriging is a method associated with linear unbiased estimation, as the estimations are weighed linear combination of available data. It does not take into account of the covariates – it assumes constant unknown mean and helps in minimizing error variance. It is the most commonly used method of kriging.

Universal kriging is similar but it includes a polynomial trend model, assumes covariates for interpolation (kriging under non-stationary conditions, in the presence of drift).

###Data
The data used here in this example case is Meuse river data.
Meuse dataset comprises the measures of four major heavy metals found in the top soil in a flood plain along the river Meuse, Belgium. This is crucial that the contamination happens just because of the river flow that moves the polluted sediments and deposits close to the river bank. This case makes it explicit for geostatistical analysis of the dataset.

###R-Package
Package ‘gstat’ is used here in conjunction with the package ‘sp’. 'gstat’ promotes a range of univariate and multivariate geostatistical modelling, prediction and simulation functions while ‘sp’ helps with class descriptions and methods for importing , exporting and visualizing spatial data.

###How to use
####Ordinary kriging
In order to use this tool, select the Ordkrig scriot tool from the krig_tools.tbx toolbox in the ArcGIS environment. As you proceed, you will find this tool popped up as shown below in Figure .a.

The description of each of the parameters found in this pop-up tool is as follow.
1. **Input_feature  :**  Input point feature containing fields of the dependent variable and all explanatory variables.
2. **Prediction_location  :**  Input point feature representing locations where you would like to predict the probable values for the presence of dependent variable. These point feature must have certain explanatory variables stored as fields.
3. **Dep_variable  :**  Field from the input feature containing the sampled attributes. A particular value gives the strength of the field element at that point.
4. **Output_krige  :**  Output krige shapefile that contains the predictions of the values of unsampled locations from the Prediction_location dataset.
5. **Output_var  :**  Output variance provides how far the values are deviated from the other and the mean.

The feature layers of meuse dataset is provided in this same repository within the data folder. Click the input_feature file icon and browse for the meuse feature class from meuse.gdb. Click the Prediction_location file icon and browse for meuse_grid from the same meuse.gdb. Click the drop down icon of dep_variable parameter and select for a variable to process prediction. Give output files for Output_krige and Output_var if you want to change the default file selects. Finally click OK.
Once the inputs are given, the tool runs as shown below in Figure .b and produces the output krige and variance shape files as shown in Figure .c and .d.

####Universal kriging
In order to use this tool, select the UnivKrig scriot tool from the krig_tools.tbx toolbox in the ArcGIS environment. As you proceed, you will find this tool popped up as shown below in Figure .e.

The description of each of the parameters found in this pop-up tool is as follow.
1. **Input_feature** : Input point feature containing fields of the dependent variable and all explanatory variables.
2. **Prediction_location** : Input point feature representing locations where you would like to predict the probable values for the presence of dependent variable. These point feature must have certain explanatory variables stored as fields.
3. **Dep_variable** : Field from the input feature containing the attributes of sampled points. A particular value gives the strength of the field element at that point.
4. **Covariate** : Field from the input feature containing independent or explanatory variables.
5. **Output_krige** : Output krige shapefile that contains the predictions of the values of unsampled locations from the Prediction_location dataset.
6. **Output_var** : Output variance provides how far the values are deviated from the other and the mean.

This works in the same way as the ordinary krige tool with the same datasets provided in this repository. Click the input_feature file icon and browse for the meuse feature class from meuse.gdb. Click the Prediction_location file icon and browse for meuse_grid from the same meuse.gdb. Click the drop down icon of dep_variable parameter and select any heavy metal variable to process prediction. Then, Click the drop down icon of covariate parameter and select for the ‘dist’ variable to process prediction. Give the output file for Output_krige if you want to change the default file selects. Give the output file for Output_var if needed since it is optional. Finally click OK.
Once the inputs are given, the tool runs as shown below Figure .f and produces the output krige and variance shape files (Figure .g).

###References 
- [1] Pebesma, Edzer J. "Multivariable geostatistics in S: the gstat package."Computers & Geosciences 30.7 (2004): 683-691. 
- [2] Pebesma, Edzer, and Benedikt Gräler. "Spatio-temporal geostatistics using gstat." (2015).
 
