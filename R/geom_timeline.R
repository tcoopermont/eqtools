
library(scales)
library(ggplot2)
library(grid)
#draw_panel_function_bak <- function(data, panel_scales, coord) {
#        coords <- coord$transform(data, panel_scales) %>%
#                mutate(lower = rescale(lower, from = panel_scales$y.range),
#                       upper = rescale(upper, from = panel_scales$y.range),
#                       middle = rescale(middle, from = panel_scales$y.range))
#        med <- pointsGrob(x = coords$x,
#                          y = coords$middle,
#                          pch = coords$shape)
#        lower <- segmentsGrob(x0 = coords$x,
#                              x1 = coords$x,
#                              y0 = coords$ymin,
#                              y1 = coords$lower,
#                              gp = gpar(lwd = coords$size))
#        upper <- segmentsGrob(x0 = coords$x,
#                              x1 = coords$x,
#                              y0 = coords$upper,
#                              y1 = coords$ymax,
#                              gp = gpar(lwd = coords$size))
#        gTree(children = gList(med, lower, upper))
#}
draw_panel_function <- function(data, panel_scales, coord) {
    #str(data)
    #str(panel_scales)
    #getting warning: "Using size for a discrete variable is not advised "
    #coords$data <- dplyr::mutate(coords$data,~ size = as.numeric(size))
    #try and filter the data by min/max year
    coords <- coord$data
    coords <- coord$transform(data, panel_scales) #%>%
           #mutate(xmin = rescale(xmin, from = panel_scales$x.range),
           #       xmax = rescale(xmax, from = panel_scales$x.range))
    #str(coords) 
    
    datePoint = grid::pointsGrob(
	   x = coords$x,
           y = coords$y,
           pch = 19, size = unit(1,"char"),
        #need to change this to defaults
          gp = gpar(col = alpha(coords$colour, coords$alpha), 
   	            fill = alpha(coords$fill, coords$alpha), 
   	            fontsize = coords$size * .pt  , 
                    lwd = coords$lwd)
    )
                  
    #this should only be drawn once - use "first" from pointsGlob                        
    timeLine = grid::segmentsGrob(coords$xmin,
                            coords$y,
                            coords$xmax,
                            coords$y)
    grid::gTree(children = grid::gList(datePoint,timeLine))
    #timeLine 
}
#need to fix stroke
GeomTimeline <- ggproto("GeomTimeline", Geom,
                         required_aes = c("x","y"),
                         default_aes = aes(shape = 19, lwd = 2,colour = "black",
                                           fill = "black",alpha = 0.5,stroke = 1),

                         draw_key = draw_key_point,
                         #draw_key = function(data, params, size) 
#{
#    #browser()
#    pointsGrob(0.5, 0.5, pch = data$shape, gp = gpar(col = alpha("blue", 
#        0.9), fill = alpha("blue",0.9), fontsize = data$size * 
#        .pt, lwd = 2))
#},
                         draw_panel = draw_panel_function
                         )
#' geom_timeline
#'
#' This function generates a timeline plot with years as y axis and individual earthquake 
#'    dates as points on the x axis.
#' 
#' @param mapping Set of aesthetic mappings created by ‘aes’. Can be inherited from 
#'      upper levels of the plot.
#'
#' @param data The data to be displayed in this layer. Can be NULL, data.frame or function
#' 
#' @param stat The statistical transformation to use on the data for this layer
#' 
#' @param position Position adjustment, either as a string, or the result of a
#'          call to a position adjustment function.
#'
#' @param  na.rm If ‘FALSE’, the default, missing values are removed with a
#'          warning. If ‘TRUE’, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends?
#'
#' @param inherit.aes If ‘FALSE’, overrides the default aesthetics, rather than
#'          combining with them. 
#' @param ... other arguments passed on to ‘layer’.
#'
#' @details: aes parameters act similar to `geom_point`
#'
#'
#' @examples
#' \dontrun{
#' ggplot(quakesFiltered,aes(x = YEAR, y = 1,
#'         xmin = minYear,xmax = maxYear,
#'         )) +
#'  geom_timeline(aes(size = EQ_PRIMARY))
#' }
#'
# ??@importFrom grid pointsGrob segmentsGrob
#'
#' @export
geom_timeline<- function(mapping = NULL, data = NULL, stat = "identity", 
                           position = "identity", show.legend = NA, 
                           na.rm = FALSE, inherit.aes = TRUE, ...) {
        ggplot2::layer(
                data = data, 
                mapping = mapping,
                stat = stat,
                geom = GeomTimeline,
                position = position,
                show.legend = show.legend,
                inherit.aes = inherit.aes,
                params = list(na.rm = na.rm, ...)
        )
}
