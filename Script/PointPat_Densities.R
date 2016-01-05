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
  
  input_feature = in_params[[1]]
  dep_variable = in_params[[2]]
  output_feature = out_params[[1]]
  d = arc.open(input_feature)
  dat = arc.select(d, dep_variable)
  dat.xy = data.frame(x=arc.shape(dat)$x,y=arc.shape(dat)$y,input_feature)
  dat.1 = arc.select(d,names(d@fields[d@fields == "OID"]))
  dat.2 = cbind(dat.1,dat.xy,dat)
  coordinates(dat.2)=~x+y
  
  message("loading...",class(dat.xy))
  
  dat.ppp = as.ppp(dat.2)
  d= density.ppp(dat.ppp, sigma = 70)
  r = raster(d)
  patternDensity = as(r, "SpatialPolygonsDataFrame")
  
  #### Write Output ####
  message("...write output...")
  arc.write(output_feature,patternDensity)
  message("...done...almost...")
  return(out_params)
}
