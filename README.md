# R_GIS
Bridging R with ArcGIS.

Using R as a scripting tool to generate geostatistical tools for ArcGIS to work with.

This Repository has three tools as of now.
There are two kriging tools - One is for Ordinary kriging while the other is Universal kriging tool.

The Ordinary kriging tool simply interpolates the values.
The Universal kriging tool uses a covariate [sqrt(dist)] to interpolate the values.
There is point pattern densities tool for the estimation of densities. 
