#
#
#
#

indexTS <- function(sp = NULL) {

  # ggplot theme options
  plot_theme <- theme_classic() +
    theme(axis.text = element_text(size = 13),
      axis.title = element_text(size = 15))

  # filter for subset of values according to user's choice of taxa
  bdi_tmp <- bdi[which(bdi$taxa == sp),]

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
  timeseries <- ggplot(data = bdi_tmp, ggplot2::aes(x = year)) +
    geom_ribbon(aes(ymin = bdi_hi, ymax = bdi_lo), 
                fill = "navyblue", alpha = .6) +
    geom_line(ggplot2::aes(y = bdi_index), col = "white", lwd = .5) +
    geom_hline(yintercept = 1, lty = 2, col = "black") +
    labs(y = "Valeur de l'indice", x = "", 
         title = paste0("Tendance moyenne de L'IDB: ", species[species$taxa == sp, "sp_fr"])) +
    coord_cartesian(ylim = c(min_int, max_int)) +
    plot_theme

  return(timeseries)
}