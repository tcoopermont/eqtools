
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
         # pull out the top n_max by magnitude - for annotation
	 one_max <- data$n_max[1]
	 if(!is.na(one_max)){
             data <- mutate(data, size = as.numeric(size)) %>%
	      arrange(size) %>%
	      slice(1:one_max)
	         

	 } 
         coords <- coord$data
         coords <- coord$transform(data, panel_scales) #%>%
                #mutate(xmin = rescale(xmin, from = panel_scales$x.range),
                #       xmax = rescale(xmax, from = panel_scales$x.range))
         #str(coords) 
                       
         #should the length come in as a parameter?
         connLine = segmentsGrob(coords$x,coords$y,coords$x,coords$y + 0.07)
         labelTxt = textGrob(coords$label,coords$x,coords$y + 0.07,just="left",rot=45)
         #timeLine = segmentsGrob(0.25,0.5,0.8,0.5)
         gTree(children = gList(connLine,labelTxt))
         #timeLine 
}
#need to fix stroke
GeomTimelineLabel <- ggproto("GeomTimelineLabel", Geom,
                         required_aes = c("x","label"),
                         default_aes = aes(shape = 19, lwd = 2,colour = "black",
                                           fill = "black",alpha = 0.9,stroke = 1,n_max = NA),

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

#' geom_timeline_label
#'
#' This function generates annotation to accompany `geom_timeline` plot objects.
#'    The name of the earthquake location is shown above the timeline point and a
#'    line connection the name with the point is drawn.
#' 
#' @param mapping Set of aesthetic mappings created by ‘aes’. Can be inherited from 
#'      upper levels of the plot.
#'
#' @param data The data to be displayed in this layer. Can be NULL, data.frame or function
#' 
#' @details aes parameters act similar to `geom_label`
#'     aes n_max max number of labels sorted by size 
#'
#' @aesthetics
#' * length
#'
#' @examples
#' \dontrun{
#' ggplot(quakesFiltered,aes(x = YEAR, y = 1,
#'         xmin = minYear,xmax = maxYear)) +
#'  geom_timeline(aes(size = EQ_PRIMARY)) +
#'  geom_timeline_label(aes(size = EQ_PRIMARY)) +
#' }
#'
# ??@importFrom grid textGrob segmentsGrob
#'
#' @export
geom_timeline_label<- function(mapping = NULL, data = NULL, stat = "identity", 
                           position = "identity", show.legend = NA, 
                           na.rm = FALSE, inherit.aes = TRUE, ...) {
        layer(
                data = data, 
                mapping = mapping,
                stat = stat,
                geom = GeomTimelineLabel,
                position = position,
                show.legend = show.legend,
                inherit.aes = inherit.aes,
                params = list(na.rm = na.rm, ...)
        )
}
