#' bdi_time_series UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_bdi_time_series_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("bdi_ts"))
  )
}
    
#' bdi_time_series Server Functions
#'
#' @noRd 
mod_bdi_time_series_server <- function(id, spchoice){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # ggplot theme options
    plot_theme <- theme_classic() +
      theme(axis.text = element_text(size = 13),
        axis.title = element_text(size = 15))

    output$bdi_ts <- renderPlot({
      indexTS(sp = spchoice())
    }, res = 96)
    
  })
}
    
## To be copied in the UI
# mod_bdi_time_series_ui("bdi_time_series_ui_1")
    
## To be copied in the server
# mod_bdi_time_series_server("bdi_time_series_ui_1")
