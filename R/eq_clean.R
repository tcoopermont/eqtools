library(dplyr)
library(tools)
#' eq_clean_data
#' 
#' This is a function the converts the latitude and longitude from NOAA earthquake data from character to numeric.
#' @param adf a dataframe containing NOAA earthquake data
#'
#' @return This function returns a dataframe with latitude and longitude columns as numeric type.
#'
#' @examples
#' eq_clean_data(mydata)
#'
#' @importFrom dplyr mutate
#'
#' @export
eq_clean_data <- function(adf) {
  dplyr::mutate_(adf, LATITUDE =  ~ as.numeric(LATITUDE),
              LONGITUDE = ~ as.numeric(LONGITUDE),
              date = ~ as.Date(paste(YEAR,MONTH,DAY,sep="-"),"%Y-%m-%d") 
        )
}

#' eq_location_clean
#' 
#' This is a function the converts the location_name from NOAA earthquake data from uppercase to title case and remove the country from location_name. (removes everything up to the last colon character.)
#' @param adf a dataframe containing NOAA earthquake data
#'
#' @return This function returns a dataframe with location_name column as formated as title case without the country name. 
#'
#' @examples
#' eq_location_clean(mydata)
#'
#' @importFrom dplyr mutate
#'
#'
#' @importFrom tools toTitleCase
#'
#' @export
eq_location_clean <- function(adf) {
  dplyr::mutate_(adf,LOCATION_NAME = ~ tools::toTitleCase(tolower(
             sub("^.+:\\s+" ,"",LOCATION_NAME,perl = TRUE))))

}


