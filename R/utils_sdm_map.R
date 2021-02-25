


make_leafletproxy_sdm <- function(map_id, sdm=NULL, ext) {
  
  # Prepare color palette for raster map
  max_int <- max(sdm[,,], na.rm=T)
  max_int <- ceiling_dec(max_int, level=nbr_dec(max_int))
  min_int <- min(sdm[,,], na.rm=T)
  min_int <- floor_dec(min_int, level=nbr_dec(min_int))
  
  pal <- leaflet::colorNumeric(palette = viridis::viridis(100), domain = c(NA, min_int, max_int), na.color = "transparent")
  pal_legend <- leaflet::colorNumeric(palette = viridis::viridis(100), domain = c(NA, min_int, max_int), na.color = "transparent", reverse = TRUE) # reverse so it works with legends with value from 1 to 0
  
  # Render map for all species
  # Change map to show chosen region's sdm
  leaflet::leafletProxy(map_id) %>%
    leaflet::clearShapes() %>%
    leaflet::addRasterImage(sdm, color = pal, project=FALSE, opacity = 0.7) %>%
    leaflet::addLegend(pal = pal_legend, values = seq(max_int,min_int, -1*(max_int-min_int)/100), title = "Ratio de probabilité d'occurrence",
                       labFormat = leaflet::labelFormat(transform = function(x) sort(x, decreasing = TRUE)), group = "Distribution", layerId = "distr_legend", opacity=1) %>%
    leaflet::flyToBounds(ext[1], ext[3], ext[2], ext[4])
}

# from mapselector


# Ceiling and floor for intervals in raster legend
floor_dec <- function(x, level=1) round(x - 5*10^(-level-1), level)
ceiling_dec <- function(x, level=1) round(x + 5*10^(-level-1), level)

# Get number of decimals (level) for floor_dec or ceiling_dec
nbr_dec <- function(x) {
  i=0
  while(abs(x) < 1) {
    i=i+1
    x=x*10
  }
  return(i)
}


# get one sdm
get_one_sdm <- function(spp_chosen, region_chosen){
  stopifnot(is.character(region_chosen))
  stopifnot(is.character(spp_chosen))
  
  tableaubdi::prob_occ[[spp_chosen]][[region_chosen]]
  
}


make_leafletproxy_map_regions <- function(map_id){
  # Set extent
  ext <- raster::extent(mapselector::CERQ)
  
  # Map shapefile
  leaflet::leafletProxy(map_id) %>%
    leaflet::clearImages() %>%
    leaflet::clearControls() %>%
    leaflet::addPolygons(data = mapselector::CERQ,
                         color = "darkblue", weight = 1,
                         smoothFactor = 0.5, layerId = ~ NOM_PROV_N,
                         fillColor = "#2571BB",
                         fillOpacity = 0.4, highlightOptions = leaflet::highlightOptions(color = "white",
                                                                                         weight = 3,
                                                                                         opacity = 1,
                                                                                         fillOpacity = 1,
                                                                                         bringToFront = TRUE)) %>%
    leaflet::flyToBounds(ext[1], ext[3], ext[2], ext[4])
}