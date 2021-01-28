#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import ggplot2
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 

  # Render empty map to show in background
  output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_empty())

  # Set reactive values
  spchoice <- reactive({toString(input$species)})
  selscale <- reactive({toString(input$sel_scale)})

  # Small intro to dashboard
  mod_tuto_modal_server("tuto_modal_ui_1")

  observeEvent(input$pass, {
    mod_tuto_modal3_server("tuto_modal3_ui_1")
  })

  observeEvent(input$next1, {
    mod_tuto_modal2_server("tuto_modal2_ui_1")
  })

  observeEvent(input$backTo1, {
    mod_tuto_modal_server("tuto_modal_ui_1")
  })

  observeEvent(input$next2, {
    mod_tuto_modal3_server("tuto_modal3_ui_1")
  })

  observeEvent(input$backTo2, {
    mod_tuto_modal2_server("tuto_modal2_ui_1")
  })


  # Choices of scales at which we want to visualize the index
  observeEvent(input$pro_nat, {
    removeModal()
    updateSelectInput(session, "sel_scale",
      selected = "pro_nat")
  })

  observeEvent(input$qc, {
    removeModal()
    output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_sdm(sdm=prob_occ[[spchoice()]]$toutes))
    mod_bdi_time_series_server("bdi_time_series_ui_1", spchoice)
  })


  # Sidebar menu choices of scales
  observeEvent(input$sel_scale, {
    updateSelectInput(session, "species",
      selected = "all")
    if(selscale() == "all") {
      output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_sdm(sdm=prob_occ[[spchoice()]]$toutes))
    } else {
      # "Provinces naturelles" shapefile
      output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_map())
      
      hover <- reactiveValues(coord_map = NULL, hovered_region = NULL, last_hover = NULL)
      clic <- reactiveValues(p = NULL, selected_region = NULL, data_region = NULL)

      # Record and show hover event
      listenHover <- reactive({
        list(input$map_shape_mouseover, input$map_shape_mouseout)
      })

      observeEvent(listenHover(),{
      
        if(length(hover$last_hover) > 0) {
          
          if(!all(listenHover()[[1]] %in% hover$last_hover[[1]])) {  
            
            # Record hovered coordinates
            hover$coord_map <- sf::st_set_crs(sf::st_sfc(sf::st_point(c(listenHover()[[1]]$lng, listenHover()[[1]]$lat))), sf::st_crs(mapselector::CERQ)$proj4string)

            # Record hovered region
            hover$hovered_region <-  as.character(as.data.frame(mapselector::CERQ)[which(rgeos::gContains(as(mapselector::CERQ, "Spatial"), as(hover$coord_map, "Spatial"), byid = TRUE) == TRUE), 3])

            # Record listenHover()
            hover$last_hover <- listenHover()

          } else {
            hover$hovered_region = NULL
          }

        } else {
          
          # Record hovered coordinates
          hover$coord_map <- sf::st_set_crs(sf::st_sfc(sf::st_point(c(listenHover()[[1]]$lng, listenHover()[[1]]$lat))), sf::st_crs(mapselector::CERQ)$proj4string)

          # Record hovered region
          hover$hovered_region <-  as.character(as.data.frame(mapselector::CERQ)[which(rgeos::gContains(as(mapselector::CERQ, "Spatial"), as(hover$coord_map, "Spatial"), byid = TRUE) == TRUE), 3])

          # Record listenHover()
          hover$last_hover <- listenHover()

        }

        output$show_region <- 
          renderUI({HTML(paste("<h4 id = 'hovered_region' >",
            ifelse(length(hover$hovered_region) > 0, 
              ifelse(!is.na(hover$hovered_region),
                hover$hovered_region, ""), ""),"</h4>"))})  

      }, ignoreInit = TRUE, ignoreNULL = TRUE)
      

      # Record clic event
      observeEvent({input$map_shape_click}, {

        # save click coordinates
        clic$coord_map <- sf::st_set_crs(sf::st_sfc(sf::st_point(c(input$map_shape_click$lng, input$map_shape_click$lat))), sf::st_crs(mapselector::CERQ)$proj4string)
        
        # save clicked region's shapefile
        clic$selected_region <- as.character(as.data.frame(mapselector::CERQ)[which(rgeos::gContains(as(mapselector::CERQ, "Spatial"), as(clic$coord_map, "Spatial"), byid = TRUE) == TRUE), 3])

        if(length(clic$selected_region) == 0) { # prevent to bug when clic just outside of the shapefile
          return()
        } else {
          
          # Reset values and update region's name
          hover$coord_map <- NULL
          hover$hovered_region <- NULL
          output$show_region <- renderUI({HTML(paste("<h4 id = 'clicked_region' >",clic$selected_region,"</h4>"))})

          # Prepare color palette for raster map
          sdm <- prob_occ[[spchoice()]][[clic$selected_region]]

          max_int <- max(sdm[,,], na.rm=T)
          max_int <- ceiling_dec(max_int, level=nbr_dec(max_int))
          min_int <- min(sdm[,,], na.rm=T)
          min_int <- floor_dec(min_int, level=nbr_dec(min_int))

          pal <- leaflet::colorNumeric(palette = viridis::viridis(100), domain = c(NA, min_int, max_int), na.color = "transparent")
          pal_legend <- leaflet::colorNumeric(palette = viridis::viridis(100), domain = c(NA, min_int, max_int), na.color = "transparent", reverse = TRUE) # reverse so it works with legends with value from 1 to 0

          # Set extent
          ext <- raster::extent(mapselector::CERQ[as.data.frame(mapselector::CERQ)[,3] == clic$selected_region,])

          # Change map to show chosen region's sdm
          leaflet::leafletProxy("map") %>%
            leaflet::clearShapes() %>%
            leaflet::addRasterImage(sdm, color = pal, project=FALSE, opacity = 0.7) %>%
            leaflet::addLegend(pal = pal_legend, values = seq(max_int,min_int, -1*(max_int-min_int)/100), title = "Ratio de probabilité d'occurrence",
              labFormat = leaflet::labelFormat(transform = function(x) sort(x, decreasing = TRUE)), group = "Distribution", layerId = "distr_legend", opacity=1) %>%
            leaflet::flyToBounds(ext[1], ext[3], ext[2], ext[4])

        }
      }, ignoreInit = TRUE, ignoreNULL = TRUE)    


      # Return to shapefile
      observeEvent({input$return_to_sf}, {

        # Reset values of clic and hover events
        clic$coord_map <- NULL
        clic$selected_region <- NULL
        hover$coord_map <- NULL
        hover$hovered_region <- NULL

        # Reset show_region output
        #output$show_region <- NULL

        # Set extent
        ext <- raster::extent(mapselector::CERQ)

        # Set colors for shapefile
        interp_pal <- leaflet::colorFactor(rcartocolor::carto_pal(12,"Prism"), domain = mapselector::CERQ$NOM_PROV_N)

        # Map shapefile
        leaflet::leafletProxy("map") %>%
          leaflet::clearImages() %>%
          leaflet::clearControls() %>%
          leaflet::addPolygons(data = mapselector::CERQ, color = "darkblue", weight = 1, smoothFactor = 0.5, layerId = ~ NOM_PROV_N, fillColor = ~ interp_pal(NOM_PROV_N),
            fillOpacity = 0.7, highlightOptions = leaflet::highlightOptions(color = "white",
                                                   weight = 4,
                                                   # fillOpacity = 0.,
                                                   bringToFront = TRUE)) %>%
          leaflet::flyToBounds(ext[1], ext[3], ext[2], ext[4])

      }, ignoreInit = TRUE, ignoreNULL = TRUE)

    }

  }, ignoreInit = TRUE)


  # Sidebar menu choices of species
  observeEvent(input$species, {
    mod_bdi_time_series_server("bdi_time_series_ui_1", spchoice)
  })


  # Show plot in modal
  observeEvent(input$show_index, {
    showModal(
      modalDialog(
        mod_bdi_time_series_ui("bdi_time_series_ui_1"),
        title = "Indice Distribution de Biodiversité",
        size = "l"
      )
    )
  })

}
