

#shapefile <- sf::st_transform(mapselector::CERQ, sf::st_crs(prob_occ[[1]]))
#
#ras_reg <- lapply(prob_occ, function(x) {
#  lapply(1:nrow(shapefile), function(y) {
#    r1 <- raster::crop(x, raster::extent(shapefile[y,]))
#    r2 <- raster::mask(r1, shapefile[y,])
#    return(r2)
#  })
#})
#
#for(i in 1:length(ras_reg)) {
#  names(ras_reg[[i]]) <- as.character(as.data.frame(shapefile)[,3])
#}
#
#test <- lapply(1:length(prob_occ), function(x) {
#  c(prob_occ[[x]], ras_reg[[x]])
#})
#
#for(i in 1:length(test)) {
#  names(test[[i]])[1] <- "toutes"
#}
#
#names(test) <- names(prob_occ)
#
#backup <- prob_occ
#prob_occ <- test
#
#usethis::use_data(backup)
#usethis::use_data(prob_occ, overwrite = T)