#' tuto_modal2 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tuto_modal2_ui <- function(id){
  ns <- NS(id)
  tagList(
    htmlOutput(ns("secondModal"))
  )
}
    
#' tuto_modal2 Server Functions
#'
#' @noRd 
mod_tuto_modal2_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    rmarkdown::render("data-raw/secondModal.Rmd",
                      output_dir = "inst/app/www", 
                      quiet = TRUE)
    
    output$secondModal <- renderUI(includeHTML("inst/app/www/secondModal.html"))
        
  })
}
    
## To be copied in the UI
# mod_tuto_modal2_ui("tuto_modal2_ui_1")
    
## To be copied in the server
# mod_tuto_modal2_server("tuto_modal2_ui_1")
