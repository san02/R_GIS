# R_GIS
> ## [Bridging R with ArcGIS](https://r-arcgis.github.io/) - _Examples_

Requirements
------------
 - [ArcGIS R bridge](https://github.com/R-ArcGIS/r-bridge-install)
 - [R Statistical Computing Software](http://www.r-project.org)

### Using R as a scripting tool to generate geostatistical tools for ArcGIS to work with.

- This Repository has two tools as of now meant for kriging and Point pattern analysis 
     * The kriging tool is enabled to perform Ordinary kriging and Universal kriging while the other performs the estimation of density of point pattern and simulates point pattern.
- The Ordinary kriging simply interpolates the values.
- The Universal kriging uses a covariate [sqrt(dist)] to interpolate the values.
- The point pattern tool estimates the density and simulates a point pattern with the estimated density.

## Credits

Ordinary and Universal kriging use the [gstat package](http://www.gstat.org/gstat.pdf) for R:

> `gstat`: Spatial and Spatio-Temporal Geostatistical Modelling, Prediction and Simulation
> By Edzer Pebesma [aut, cre], Benedikt Graeler [aut]
> Licensed under the 	GPL-2 | GPL-3 [expanded from: GPL (≥ 2.0)]

Point Pattern analysis uses the [spatstat package](https://cran.r-project.org/web/packages/spatstat/spatstat.pdf) for R:

All tools depend on the R Statistical Computing Software:

> Copyright (C) 2015 The R Foundation for Statistical Computing
> R is free software and comes with ABSOLUTELY NO WARRANTY.

