#' Developing a script that enables a tool to run the ordinary and universal kriging, in case with square root of distance as the covariate
#'
#' This script function builds an interpolated result with the consideration of the covariate in case if the covariate variable is given, particularly sqrt(dist)
#' and provide a kriged plot upon being run with the corresponding ArcGIS script tool.
#'
#' @param in_params - input parameters
#'
#' @note The in_params parameter includes a list of 6 arguments.
#'
#' \strong{input_feature} -  Input point feature containing fields of the dependant variable and all explanatory variables.
#'
#' \strong{predict_location} -  Input point feature representing locations where you would like to predict the probable values for the presence of dependant variable. These point feature must have certain explanatory variables stored as fields.
#'
#' \strong{dep_variable} - Field from the input feature containing the sampled attributes. A particular value gives the strength of the field element at that point.
#'
#' \strong{log_var} - Taking logarithmic values for the dependent variable.
#'
#' \strong{covariate_var} - Field from the input feature containing independent or explanatory variables that would act as a variable to covariate for the interpolation.
#'
#' \strong{vgm_mod} - \code{\link[gstat]{fit.variogram}}Input for the vgm expression to fit the variogram (\emph{default : vgm(1,"Exp",300,1) , which is meant for the \bold{universal kriging}})

#' @param out_params - output parameters
#'
#' @note The out_params parameter includes the return values of \emph{output_feature1} and \emph{output_feature2}
#' @import gstat
#' @import arcgisbinding
#' @import sp
#' @import raster
#' @return output_feature1 - \code{\link[gstat]{krige}} Output krige shapefile that contains the predictions of the values of unsampled locations from the Prediction_location dataset.
#' @return output_feature2 - \code{\link[gstat]{variogram}} Output variance provides how far the values are deviated from the other and the mean and exports the output as a pdf file.
#' @author Edzer Pebesma, Shankarlingam Sundaresan
#' @details This script function interpolates the values that are modeled by a Gaussian process governed by prior covariance, as opposed to a piecewise polynomial spline chosen to optimize smoothness of the fitted values.it is similar to ordinary kriging, yet it includes a polynomial trend model,
#' assumes covariates for interpolation (kriging under non-stationary conditions, in the presence of drift).
#' @export
#' @seealso \code{\link{gstat}} , \code{\link{arcgisbinding}}
#'
# Ordinary kriging of the meuse zinc data with constant ~1
# Universial kriging of the meuse zinc data, using sqrt(dist) as covariate.

# Initializing binding tool function
tool_exec <- function(in_params, out_params)
{
  # loading packages
  arc.open = NULL
  arc.select = NULL
  variogram = NULL
  fit.variogram = NULL
  `gridded<-` = NULL
  krige = NULL
  arc.write = NULL
  spplot = NULL
  raster = NULL
  arc.data2sp = NULL
  rm(list=ls())

  if (!requireNamespace("sp", quietly = T))
    install.packages("sp")
  if (!requireNamespace("gstat",quietly = T))
    install.packages("gstat")
  if (!requireNamespace("raster",quietly = T))
    install.packages("raster")

  requireNamespace(gstat)
  requireNamespace(raster)

  message("initializing")
  # defining variables
  input_feature = in_params[[1]]
  predict_location = in_params[[2]]
  dep_variable = in_params[[3]]
  log_var = in_params[[4]]
  covariate_var = in_params[[5]]
  vgm_mod = in_params[[6]]

  output_feature1 = out_params[[1]]
  output_feature2 = out_params[[2]]

  #exporting datasets
  d = arc.open(input_feature)
  dat = arc.select(d,names(d@fields))
  dat.2 = arc.data2sp(dat)

  message("Creating model formula")
  if (!is.null(covariate_var))
  {
    if (log_var == FALSE)
    {
      model_kr = paste(dep_variable, "~sqrt(",covariate_var,")")

    }
    else
    {
      model_kr = paste(paste ("log(",dep_variable,")"),paste("~sqrt(",covariate_var,")"))
    }
    message(paste0("formula =",model_kr ))
  }
  else
  {
    if (log_var == FALSE)
    {
      model_kr = paste(dep_variable, "~1")
      message("formula =",model_kr)
    }
    else
    {
      model_kr = paste(paste ("log(",dep_variable,")"),paste("~1"))
      message("formula = log(",dep_variable,")~1")
    }
  }

  model_kr.f = as.formula(model_kr)

  message("Input vgm_model = ",vgm_mod)

  message("creating variogram...")
  out_varianc = variogram(model_kr.f,dat.2)
  vario.fit = fit.variogram(out_varianc,eval(parse(text= vgm_mod)))

  print(vario.fit)

  message("Predicting...")
  d.loc <- arc.open(predict_location)
  data.loc = arc.select(d.loc, names(d.loc@fields))
  data.loc.1 = arc.data2sp(data.loc)
  gridded(data.loc.1)=T

  #### Write Output ####


  message("....kriging now....")
  out_krig = krige(model_kr.f,dat.2, data.loc.1, vario.fit)
  message(class(out_krig))
  gridded(out_krig)=T
  out_krig1 = out_krig[1]

  gridded(out_krig)=F
  out_krig2 = out_krig[2]

  message("...write output...")
  arc.write(output_feature1,out_krig1, shape_info = d@shapeinfo)

  if (!is.null(output_feature2))
  {
    pdf(output_feature2)
    print(plot(out_varianc,vario.fit,main = "Variogram with fitted Model",cex.main = 1.25))
    gridded(out_krig)=TRUE
    print(spplot(out_krig))
    gridded(out_krig1)=T
    gridded(out_krig2)=T
    KrigRaster = raster(out_krig1)
    VarRaster = raster(out_krig2)
    plot(KrigRaster,main = "Interpolation Raster Plot",cex.main = 1.5)
    plot(VarRaster,main = "Variance Raster Plot", cex.main =  1.5)
    dev.off()
  }
  message("...done...almost...")
  return(out_params)
}
