# Universial kriging of the meuse zinc data, using sqrt(dist) as covariate.
# Initializing binding tool function
tool_exec <- function(in_params, out_params)
{
  # loading packages  
  if (!requireNamespace("sp", quietly = T))
    install.packages("sp")
  if (!requireNamespace("gstat",quietly = T))
    install.packages("gstat")
  if (!requireNamespace("raster",quietly = T))
    install.packages("raster")
  
  require(sp)
  require(gstat)
  require(raster)
  
  message("initializing")
  # defining variables
  input_feature = in_params[[1]]
  predict_location = in_params[[2]]
  dep_variable = in_params[[3]]
  covariate_var = in_params[[5]]
  log_var = in_params[[4]]
  vgm_mod = in_params[[6]]
  
  output_feature1 = out_params[[1]]
  output_feature2 = out_params[[2]]
  
  #exporting datasets
  d = arc.open(input_feature)
  dat = arc.select(d,c(dep_variable,covariate_var))
  dat['x'] = arc.shape(dat)$x
  dat['y'] = arc.shape(dat)$y
  dat.1 = arc.select(d,names(d@fields[d@fields == "OID"]))
  dat.2 = cbind(dat.1,dat)
  coordinates(dat.2)=~x+y
  
  message("Creating model formula")
  if (log_var == FALSE)
  {
    model_kr = paste(dep_variable, "~sqrt(",covariate_var,")")
    
  }
  else
  {
    model_kr = paste(paste ("log(",dep_variable,")"),paste("~sqrt(",covariate_var,")"))
  }
  
  model_kr.f = as.formula(model_kr)
  
  message(paste0("formula =",model_kr ))
  message("Input vgm_model = ",vgm_mod)
  
  message("creating variogram...")
  out_varianc = variogram(model_kr.f,dat.2)
  vario.fit = fit.variogram(out_varianc,eval(parse(text= vgm_mod)))
  
  print(vario.fit)
  
  
  message("Predicting...")
  d.loc <- arc.open(predict_location)
  oid_field0 <- d.loc@fields
  oid_field <- names(oid_field0[oid_field0 == 'OID'])[[1]]
  data.loc = arc.select(d.loc, c(oid_field, covariate_var))
  data.loc.1 <- data.frame(
    x = arc.shape(data.loc)$x,
    y = arc.shape(data.loc)$y,
    data.loc)
  coordinates(data.loc.1)=~x+y
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
  arc.write(output_feature1,out_krig1)
  
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