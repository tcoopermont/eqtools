
library(scales)
library(ggplot2)
library(grid)
library(dplyr)

draw_panel_function <- function(data, panel_scales, coord) {
         #str(data)
         #str(panel_scales)
         # pull out the top n_max by magnitude - for annotation
	 one_max <- data$n_max[1]
         print(max(data$size))
         print(min(data$size))
       
	 if(!is.na(one_max)){
             data <- dplyr::mutate_(data, size = ~ as.numeric(size)) %>%
	      dplyr::arrange_(~ dplyr::desc(size)) %>%
	      dplyr::slice(1:one_max)
	         

	 } 
         #str(data)
         coords <- coord$data
         coords <- coord$transform(data, panel_scales) #%>%
                #mutate(xmin = rescale(xmin, from = panel_scales$x.range),
                #       xmax = rescale(xmax, from = panel_scales$x.range))
         #str(coords) 
                       
         #should the length come in as a parameter?
         connLine = grid::segmentsGrob(coords$x,coords$y,coords$x,coords$y + 0.07)
         labelTxt = grid::textGrob(coords$label,coords$x,coords$y + 0.07,just="left",rot=45)
         #timeLine = segmentsGrob(0.25,0.5,0.8,0.5)
         grid::gTree(children = grid::gList(connLine,labelTxt))
         #timeLine 
}
GeomTimelineLabel <- ggproto("GeomTimelineLabel", Geom,
                         required_aes = c("x","label"),
                         default_aes = aes(shape = 19, lwd = 2,colour = "black",
                                           fill = "black",alpha = 0.9,stroke = 1,n_max = NA),

                         draw_key = draw_key_point,
                         draw_panel = draw_panel_function
                         )

#' geom_timeline_label
#'
#' This function generates annotation to accompany `geom_timeline` plot objects.
#'    The name of the earthquake location is shown above the timeline point and a
#'    line connection the name with the point is drawn.
#' 
#' @inheritParams geom_timeline
#'
#' @details aes parameters act similar to `geom_label`
#'     aes 
#' \itemize{
#' \item{ x: a Date object}
#' \item{ y: single integer or a factor. (points will be grouped by y) example: COUNTRY}
#' \item{n_max: integer max number of labels sorted by size }
#' \item{size: numeric data field to base limiting of number of labels }
#'
#' }
#'
#' @examples
#' \dontrun{
#' ggplot(quakesFiltered,aes(x = DATE, y = COUNTRY,
#'         xmin = as.Date("2000-1-1","%Y-%m-%d"),
#'         xmax = as.Date("2015-12-31","%Y-%m-%d"),
#'         )) +
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
        ggplot2::layer(
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
