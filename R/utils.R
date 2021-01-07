#' @importFrom magrittr %>%
magrittr::`%>%`

# Ceiling and floor for intervals in raster legend
floor_dec <- function(x, level=1) round(x - 5*10^(-level-1), level)
ceiling_dec <- function(x, level=1) round(x + 5*10^(-level-1), level)

# Get number of decimals (level) for floor_dec or ceiling_dec
nbr_dec <- function(x) {
  i=0
  while(abs(x) < 1) {
    i=i+1
    x=x*10
  }
  return(i)
}