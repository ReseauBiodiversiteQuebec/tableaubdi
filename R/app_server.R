#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 

  # Render empty map to show in background
  output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_empty())

  # Small intro to dahsboard
  mod_tuto_modal_server("tuto_modal_ui_1")

  observeEvent(input$next1, {
    mod_tuto_modal2_server("tuto_modal2_ui_1")
  })

  observeEvent(input$next2, {
    mod_tuto_modal3_server("tuto_modal3_ui_1")
  })

  # Choices of scales at which we want to visualize the index
  observeEvent(input$pro_nat, {
    removeModal()
    output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_map())
  })

  observeEvent(input$qc, {
    removeModal()
    output$map <- leaflet::renderLeaflet(mapselector::make_leaflet_sdm(sdm=prob_occ[["all"]]))
  })

  # Sidebar menu choices of scales

}
