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

    # filter for subset of values according to user's choice of taxa
    bdi_tmp <- bdi[which(bdi$taxa == spchoice()),]

    # Set y interval
    max_int <- max(bdi_tmp$bdi_index)
    max_int <- if(max_int != 0) {
      ceiling_dec(max_int, level=nbr_dec(max_int))
    } else {1}
    min_int <- min(bdi_tmp$bdi_index)
    min_int <- if(min_int != 0) {
      floor_dec(min_int, level=nbr_dec(min_int))
    } else {-1}

    # plot the BDI trend
    ggplot(data = bdi_tmp, ggplot2::aes(x = year)) +
      #geom_ribbon(aes(ymin = lpi_cilo, ymax = lpi_cihi), 
                  #fill = "navyblue", alpha = .6) +
      geom_line(ggplot2::aes(y = bdi_index), col = "black", lwd = .5) +
      geom_hline(yintercept = 1, lty = 2, col = "black") +
      labs(y = "Indice Distribution Biodiversité (IDB)", x = "", 
           title = "Tendance moyenne de L'IDB") +
      coord_cartesian(ylim = c(min_int, max_int)) +
      plot_theme
    }, res = 96)
  })
}
    
## To be copied in the UI
# mod_bdi_time_series_ui("bdi_time_series_ui_1")
    
## To be copied in the server
# mod_bdi_time_series_server("bdi_time_series_ui_1")
