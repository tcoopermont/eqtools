
library(scales)
library(ggplot2)
library(grid)

draw_panel_function <- function(data, panel_scales, coord) {
    str(data)
    str(panel_scales)
    #getting warning: "Using size for a discrete variable is not advised "
    #coords$data <- dplyr::mutate(coords$data,~ size = as.numeric(size))
    #try and filter the data by min/max year
    #coords <- data
    coords <- coord$transform(data, panel_scales) # %>%
           #mutate(size = rescale(size, from = panel_scales$y.range))
           #mutate(size = rescale(size, from = c(min(size),max(size))))
           #       xmax = rescale(xmax, from = panel_scales$x.range))
    str(coords) 
    
    datePoint = grid::pointsGrob(
	   x = coords$x,
           y = coords$y,
           pch = 19, 
           #size = unit(coords$size,"char") ,
        #need to change this to defaults
          gp = gpar(col = alpha(coords$colour, coords$alpha), 
   	            fill = alpha(coords$fill, coords$alpha), 
   	            fontsize  = coords$size * .pt + coords$stroke * .stroke/2   , 
                    #fontsize = 20,
                    lwd = coords$stroke * .stroke/2)
    )
    first <- coords[1,]
    miny <- (min(coords$y))
    maxy <- (max(coords$y))

    print(first)
    print(paste("miny: ",miny))
    ys <- unique(coords$y)
    start <- data.frame(x =first$xmin, y = ys, id = 1:NROW(ys))
    end <- data.frame(x =first$xmax,y = ys, id = 1:NROW(ys))
    path <- rbind(start,end)
    print(path)
    #this should only be drawn once - use "first" from pointsGlob                        
    #timeLine = grid::segmentsGrob(first$xmin,
    #                        miny,
    #                        first$xmax,
    #                        miny)
    timeLine <- grid::polylineGrob(x = path$x,y = path$y,id = path$id,default.units = "native")
    grid::gTree(children = grid::gList(datePoint,timeLine))
    #timeLine 
}
#need to fix stroke
GeomTimeline <- ggproto("GeomTimeline", Geom,
                         required_aes = c("x","y"),
                         non_missing_aes = c("size", "shape", "colour"),
                         default_aes = aes(shape = 19, size = 1.5,lwd = 2,colour = "black",
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
