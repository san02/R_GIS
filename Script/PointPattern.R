#Point pattern densities - estimation of densities using spatstat

tool_exec <- function(in_params, out_params)
{
  if (!requireNamespace("sp", quietly = T))
    install.packages("sp")
  if (!requireNamespace("spatstat",quietly = T))
    install.packages("spatstat")
  if (!requireNamespace("maptools",quietly = T))
    install.packages("maptools")
  if (!requireNamespace("raster",quietly = T))
    install.packages("raster")
  
  require(sp)
  require(spatstat)
  require(maptools)
  require(raster)
  
  ##Declaring the inputs and Output
  input_feature = in_params[[1]]
  output_feature1 = out_params[[1]]
  output_feature2 = out_params[[2]]
  
  ## Reading the input in Arcgis
  d = arc.open(input_feature)
  dat = arc.select(d, names(d@fields))
  dat.2 = arc.data2sp(dat)
  
  ### Converting the class   
  dat.ppp = as.ppp(dat.2)
  print(dat.ppp)
  d1= density.ppp(dat.ppp, sigma = 70)
  print(d1) 
  r = raster(d1)
  
  ## Converting to SP class
  patternDensity = as(r, "SpatialPolygonsDataFrame")
  
  ##Simulating point pattern with the density as reference
  fitDensity = ppm(unmark(dat.ppp),~d1)
  simDensity = simulate(fitDensity)
  print(simDensity)
  
  ##converting to dataframe
  simDensDataF = as.data.frame(simDensity)
  spdfSim = SpatialPointsDataFrame(simDensDataF,simDensDataF) 
  #### Write Output ####
  
  message("...write output...")
  arc.write(output_feature1,patternDensity)
  arc.write(output_feature2,spdfSim, shape_info = d@shapeinfo)
  message("...done...almost...")
  return(out_params)
}