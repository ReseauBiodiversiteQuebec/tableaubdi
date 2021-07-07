#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    mapselector::tableau_de_bord(
      mapselector::dash_title(title = "Indice Distribution de Biodiversité"), 
      mapselector::dash_sidebar(
        br(),
        selectInput("sel_scale",
          "Choisir l'échelle spatiale",
            choices = list(
              "Tout le Québec" = "all",
                "Provinces Naturelles" = "pro_nat")
        ),
        selectInput("species", 
          "Chioisir l'espèces", 
            setNames(species$taxa, species$sp_fr),
              selected = "all"),
        actionButton("show_index", "Afficher l'indice"),
        htmlOutput("show_region"),
        actionButton("return_to_sf", "Précédent"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO"),
        h1("GO HABS GO")
      ),
      mapselector::dash_tabs(
        mapselector::tab_map(title = "Carte")
      )
    ) 
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'tableaubdi'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

