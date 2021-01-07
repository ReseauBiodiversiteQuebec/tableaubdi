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
 
  )
}
    
#' tuto_modal2 Server Functions
#'
#' @noRd 
mod_tuto_modal2_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    showModal(
      modalDialog(
        div("Voici un exemple de l'indice..."),
        easyClose=FALSE,
        footer = tagList(
          span(
            actionButton("backTo1", "Précédent"),
            style = "position:relative; float:left;"
          ),
          actionButton("next2", "Suivant"),
        ),
        title = "Exemple"
      )
    )

  })
}
    
## To be copied in the UI
# mod_tuto_modal2_ui("tuto_modal2_ui_1")
    
## To be copied in the server
# mod_tuto_modal2_server("tuto_modal2_ui_1")
