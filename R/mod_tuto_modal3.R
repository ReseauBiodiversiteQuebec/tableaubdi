#' tuto_modal3 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tuto_modal3_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' tuto_modal3 Server Functions
#'
#' @noRd 
mod_tuto_modal3_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    showModal(
      modalDialog(
        includeHTML(
          rmarkdown::render("data-raw/thirdModal.Rmd", output_dir = "data", quiet = TRUE)
        ),
        actionButton("qc", "Tout le Québec"),
        actionButton("pro_nat", "Par provinces naturelles"),
        easyClose=FALSE,
        footer = span(
          actionButton("backTo2", "Précédent"),
          style = "position:relative; float:left;"
        )
      )
    )

  })
}
    
## To be copied in the UI
# mod_tuto_modal3_ui("tuto_modal3_ui_1")
    
## To be copied in the server
# mod_tuto_modal3_server("tuto_modal3_ui_1")
