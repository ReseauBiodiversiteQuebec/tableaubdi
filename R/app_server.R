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
    spchoice <- reactive({toString(input$species)})
    output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_sdm(sdm=prob_occ[[spchoice()]]))
    mod_bdi_time_series_server("bdi_time_series_ui_1", spchoice)
  })


  # Sidebar menu choices of scales
  observeEvent(input$sel_scale, {
    updateSelectInput(session, "species",
      selected = "all")
    if(input$sel_scale == "all") {
      spchoice <- reactive({toString(input$species)}) # reactive change after map is rendered...
      output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_sdm(sdm=prob_occ[[spchoice()]]))
    } else {
      output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_map())
    }
  }, ignoreInit = TRUE)


  # Sidebar menu choices of species
  observeEvent(input$species, {
    spchoice <- reactive({toString(input$species)})
    mod_bdi_time_series_server("bdi_time_series_ui_1", spchoice)
  })


  # Show plot in modal
  observeEvent(input$show_index, {
    showModal(
      modalDialog(
        mod_bdi_time_series_ui("bdi_time_series_ui_1"),
        title = "Indice Distribution de Biodiversité"
      )
    )
  })

}
