# Ordinary kriging
# Initializing binding tool
tool_exec <- function(in_params, out_params)
  {
# loading packages  
   if (!requireNamespace("sp", quietly = T))
    install.packages("sp")
  if (!requireNamespace("gstat",quietly = T))
    install.packages("gstat")
 
  require(sp)
  require(gstat)
  
  # defining variables
  input_feature = in_params[[1]]
  predict_location = in_params[[2]]
  partial_sill = in_params[[4]]
  modl = in_params[[5]]
  rang = in_params[[6]]
  nugt = in_params[[7]]
  dep_variable = in_params[[3]]
  output_feature1 = out_params[[1]]
  output_feature2 = out_params[[2]]
  
  #exporting datasets
  d = arc.open(input_feature)
  dat = arc.select(d, dep_variable)
  dat.xy = data.frame(x=arc.shape(dat)$x,y=arc.shape(dat)$y,input_feature)
  dat.1 = arc.select(d,names(d@fields[d@fields == "OID"]))
  dat.2 = cbind(dat.1,dat.xy,dat)
  coordinates(dat.2)=~x+y
  
  message(partial_sill, modl, rang, nugt)
  message("loading...",class(dat.xy))
  
  #creating model formula
  message("Creating model formula")
  model_kr = paste(dep_variable,"~1")
  model_kr.f = as.formula(model_kr)
  
  message(paste0("formula = ", model_kr))
  
  #creating variogram
  message("creating variogram...")
  out_varianc = variogram(model_kr.f,dat.2)
  message(class(out_varianc))

  #fitting the model
  vario.fit = fit.variogram(out_varianc, vgm(partial_sill, modl, rang, nugt))
  
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
  
  message("....kriging now....")
  out_krig = krige(model_kr.f,dat.2, data.loc.1, vario.fit)
  gridded(out_krig)=F
  out_krig1 = out_krig[1]
  out_krig2 = out_krig[2]
  varDF = as.data.frame(as.list(out_varianc))
  attach(varDF)
  
  message("...write output...")
  arc.write(output_feature1,out_krig1)
  
  if (!is.null(output_feature2))
  {
        pdf(output_feature2)
        color <- out_krig2@data$var1.var
        q = quantile(range(out_krig2$var1.var))
        color <- ifelse(color > q[1] & color <= q[2], "green",
                        ifelse(color > q[2] & color <= q[3], "yellow",
                          ifelse(color > q[3] & color <= q[4], "orange",
                                ifelse(color > q[4], "red", NA))))  
        plot(out_krig2, col=color, pch=15, main = "*** Variance ***", cex.main = 2)
        plot(dist,gamma,xlab = "distance",ylab = "semivariance", main = "Variogram",cex.main = 1.25 , col = "blue" )
        lines(dist,gamma,col=8)
        dev.off()
  }
  message("...done...almost...")
  return(out_params)
}
