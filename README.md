# R_GIS
> ## [Bridging R with ArcGIS](https://r-arcgis.github.io/) - _Examples_

Requirements
------------

 - [ArcGIS R bridge](https://github.com/R-ArcGIS/r-bridge-install)
 - [R Statistical Computing Software](http://www.r-project.org)

### Using R as a scripting tool to generate geostatistical tools for ArcGIS to work with.

- This Repository has two tools as of now meant for kriging - One is for Ordinary kriging while the other is Universal kriging tool.
- The Ordinary kriging tool simply interpolates the values.
- The Universal kriging tool uses a covariate [sqrt(dist)] to interpolate the values.


## **Predicting the attributes of the unsampled locations using kriging with the ‘gstat’ package**

## Credits

Ordinary and Universal kriging use the [gstat package](http://www.gstat.org/gstat.pdf) for R:

> `gstat`: Spatial and Spatio-Temporal Geostatistical Modelling, Prediction and Simulation
> By Edzer Pebesma [aut, cre], Benedikt Graeler [aut]
> Licensed under the 	GPL-2 | GPL-3 [expanded from: GPL (≥ 2.0)]

All tools depend on the R Statistical Computing Software:

> Copyright (C) 2015 The R Foundation for Statistical Computing
> R is free software and comes with ABSOLUTELY NO WARRANTY.

