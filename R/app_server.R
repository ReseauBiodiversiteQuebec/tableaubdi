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

  observeEvent(input$pass, {
    mod_tuto_modal3_server("tuto_modal3_ui_1")
  })

  # observeEvent(input$next1, {
    mod_tuto_modal2_server("tuto_modal2_ui_1")
  # })

  # observeEvent(input$backTo1, {
  #   mod_tuto_modal_server("tuto_modal_ui_1")
  # })

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
    }}, ignoreInit = TRUE)
  
  
  
  # reactives based on user interactions with map ---------------------------
  
  output$show_region <- renderText(input$map_shape_mouseover$id)
  
  sdm_one_spp <- reactive({
    req(input$map_shape_click$id)
    get_one_sdm(spchoice(), input$map_shape_click$id)})
  
  
  ext <- reactive(raster::extent(mapselector::CERQ[which(mapselector::CERQ$NOM_PROV_N == input$map_shape_click$id),]))
  
  # if they click, update the map
  observe({
    sdm_chosen <- sdm_one_spp()
    
    ext_chosen <- ext()
    
    make_leafletproxy_sdm("map", sdm = sdm_chosen, ext = ext_chosen)})
  
  # Return to shapefile
  observeEvent(input$return_to_sf,
               make_leafletproxy_map_regions("map"),
               ignoreInit = TRUE, ignoreNULL = TRUE)
  
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
