
tool_exec <- function(in_params, out_params)
  {
   if (!requireNamespace("sp", quietly = T))
    install.packages("sp")
  if (!requireNamespace("gstat",quietly = T))
    install.packages("gstat")
  
  require(sp)
  require(gstat)
 
  input_feature = in_params[[1]]
  predict_location = in_params[[2]]
  dep_variable = in_params[[3]]
  output_feature1 = out_params[[1]]
  output_feature2 = out_params[[2]]
  d = arc.open(input_feature)
  dat = arc.select(d, dep_variable)
  dat.xy = data.frame(x=arc.shape(dat)$x,y=arc.shape(dat)$y,input_feature)
  dat.1 = arc.select(d,names(d@fields[d@fields == "OID"]))
  dat.2 = cbind(dat.1,dat.xy,dat)
  coordinates(dat.2)=~x+y
  
  message("loading...",class(dat.xy))
  
  message("Creating model formula")
  model_kr = paste(dep_variable,"~1")
  model_kr.f = as.formula(model_kr)
  
  message(paste0("formula = ", model_kr))
  
  message("creating variogram...")
  out_varianc = variogram(model_kr.f,dat.2)
  vario.fit = fit.variogram(out_varianc, vgm(1, "Sph", 900, 1))
  
  message("Predicting...")
  d.loc = arc.open(predict_location)
  oid_field_0 = d.loc@fields
  oid_field = names(oid_field_0[oid_field_0 == 'OID'])[[1]]
  data.loc = arc.select(d.loc,oid_field)
  data_shp = arc.shape(data.loc)
  
  data.loc_xy <- data.frame(
    x = arc.shape(data.loc)$x,
    y = arc.shape(data.loc)$y,
    data.loc)
  data.loc.1  = cbind(data.loc_xy,oid_field_0)
  coordinates(data.loc.1)=~x+y
  gridded(data.loc.1)=T
  
  #### Write Output ####
  
  message(".........krigging on the go....")
  out_krig = krige(model_kr.f,dat.2, data.loc.1, vario.fit)
  gridded(out_krig)=T
  out_krig1 = out_krig[1]
  out_krig2 = out_krig[2]
  
  message("...write output...")
  arc.write(output_feature1,out_krig1)
  arc.write(output_feature2,out_krig2)
  message("...done...almost...")
  return(out_params)
}