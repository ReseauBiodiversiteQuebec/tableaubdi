#' tuto_modal UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tuto_modal_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' tuto_modal Server Functions
#'
#' @noRd 
mod_tuto_modal_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    showModal(
      modalDialog(
        div("L'indice de distribution de biodiversité est un indicateur qui permet de suivre les changements de biodiversité à l'échelle du Québec en utilisant les changements d'aire de répartition des espèces."),
        easyClose = FALSE,
        footer = tagList(
          span(
            actionButton("pass", "Passer l'introduction"),
            style = "position:relative; float:left;"
          ),
          actionButton("next1", "Suivant")
        ),
        title = "Indice Distribution de Biodiversité"
      )
    )
  })
}
    
## To be copied in the UI
# mod_tuto_modal_ui("tuto_modal_ui_1")
    
## To be copied in the server
# mod_tuto_modal_server("tuto_modal_ui_1")
