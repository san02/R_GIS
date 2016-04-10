#' Developing a script that enables a tool to run the point pattern analysis - estimating density and simulating point pattern.
#'
#' This script function converts the input point feature into a point pattern dataset and estimates the density of the converted point pattern
#' and simulates a point pattern based on the estimated density upon being run with the corresponding ArcGIS script tool.
#'
#' @param in_params - input parameter containing the point feature.
#' @param out_params - output parameter containing the outputs for the estimated density and the simulated point pattern as the shapefiles.
#'
#' @note The in_params parameter includes the \emph{input point feature, input boundary, and the band width for the density}
#' @note The out_params parameter includes the return values of \emph{output_feature1}, which is the density and \emph{output_feature2}, which is the simulated point pattern.
#' @import sp
#' @importFrom raster raster
#' @import maptools
#' @import arcgisbinding
#' @import spatstat
#'
#' @return output_feature1 - \code{\link[spatstat]{density.ppp}} Output krige shapefile that contains the predictions of the values of unsampled locations from the Prediction_location dataset.
#' @return output_feature2 - \code{\link[spatstat]{simulate.ppm}} Output variance provides how far the values are deviated from the other and the mean and exports the output as a pdf file.
#' @author Edzer Pebesma, Shankarlingam Sundaresan
#' @details This script function estimated the density of the point pattern using the kernel density estimation methodology using the kernel smoothed intensity function and simulates another point pattern by fitting a point pattern model.
#' @export
#' @seealso \code{\link{spatstat}} , \code{\link{arcgisbinding}}
#'


#Point pattern densities - estimation of densities and simulation of point pattern using spatstat

tool_exec <- function(in_params, out_params)
{
  as.ppp = NULL
  density.ppp = NULL
  ppm = NULL
  unmark = NULL
  arc.open = NULL
  arc.select =NULL
  arc.data2sp = NULL
  raster = NULL
  SpatialPointsDataFrame = NULL
  arc.write = NULL
  rm(list=ls())

  if (!requireNamespace("sp", quietly = T))
    install.packages("sp")
  if (!requireNamespace("spatstat",quietly = T))
    install.packages("spatstat")
  if (!requireNamespace("maptools",quietly = T))
    install.packages("maptools")
  if (!requireNamespace("raster",quietly = T))
    install.packages("raster")

  ##Declaring the inputs and Output
  input_feature = in_params[[1]]
  input_boundary = in_params[[2]]
  BWidth = in_params[[3]]
  output_feature1 = out_params[[1]]
  output_feature2 = out_params[[2]]

  ## Reading the input in Arcgis
  d = arc.open(input_feature)
  dat = arc.select(d, names(d@fields))
  dat.2 = arc.data2sp(dat)

  #reading boudary input
  b = arc.open(input_boundary)
  b1 = arc.select(b,names(b@fields))
  b2 = arc.data2sp(b1)

  ##converting boundary into owin object
  b.win = as.owin(b2)

  ### Converting the class
  if(!is.null(input_boundary))
  {
    pts = coordinates(dat.2)
    dat.ppp = ppp(pts[,1],pts[,2],window = b.win)
  }
  else
  {
    dat.ppp = as.ppp(dat.2)
  }

  print(dat.ppp)

  # Estimating Density
  d1= density.ppp(dat.ppp, sigma = BWidth)
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
