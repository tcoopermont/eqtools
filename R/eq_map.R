#' eq_map
#' 
#' This function generates a leaflet map, give NOAA earthquake data.

#' @param adf A dataframe containing NOAA earthquake data
#' @param annot_col A text string which is the name of the column in adf that 
#'    contains the "pop up" text for the data points.
#'    This "pop text" can be generated using the function eq_create_label.
#' 
#' @return This function returns a  leaflet map object
#' 
#' @examples
#' \dontrun{
#' eq_map(mydata,"popup_text")
#' }
#' 
#' @importFrom leaflet addTiles addCircleMarkers
#' @importFrom magrittr %>%
#' 
#' @export
eq_map <- function(adf,annot_col){

leaflet::leaflet() %>% leaflet::addTiles( urlTemplate = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png") %>% 
  leaflet::addCircleMarkers(data = adf,
                 radius = ~ EQ_PRIMARY,
                 weight = 1,
                 lng = ~ LONGITUDE,
                 lat = ~ LATITUDE,popup = ~ as.character(annot_col))

}

#' eq_label
#' 
#' This function generates pop text in html format, give NOAA earthquake data.
#'
#' @param adf A dataframe containing NOAA earthquake data
#' 
#' @return This function returns character text  formatted in html.
#' 
#' @examples
#' \dontrun{
#' eq_label(mydata)
#' }
#' 
#' @export
eq_create_label <- function(adf) {
  paste("<b>Location</b>",adf$LOCATION_NAME,"<br />",
        "<b>Magnitude:</b>",adf$EQ_PRIMARY,"<br />",
        "<b>Total deaths:</b>",adf$TOTAL_DEATHS,"<br />")

 
}


