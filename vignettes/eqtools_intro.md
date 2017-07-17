---
title: "Intro to Eartquake Tools"
author: "Tom Cooper"
date: "2017-07-16"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Intro to Eartquake Tools}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

The eqtools package makes it easy for  users to explore the  U.S. National Oceanographic and Atmospheric Administration (NOAA) dataset on significant earthquakes around the world. This dataset contains information about 5,933 earthquakes over an approximately 4,000 year time span.

### Downloading dataset

The datset is available from the [NOAA Website](https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1)
The entire dataset can be download by clicking on the link: "Download entire significant earthquake data file in tab-delimited format."

### What Eqtools includes

- Functions to clean the data to prepare for 
- Geoms to create timeline plots
- Functions to create interactive html maps 

### Data: NOAA significant earthquake data 


```r
     eqdata <- readr::read_delim(  system.file("extdata",
                          "signif-july-2017.txt.gz",
			   package = "eqtools"),delim = "\t")
```

```
## Parsed with column specification:
## cols(
##   .default = col_integer(),
##   FLAG_TSUNAMI = col_character(),
##   SECOND = col_character(),
##   EQ_PRIMARY = col_character(),
##   EQ_MAG_MW = col_character(),
##   EQ_MAG_MS = col_character(),
##   EQ_MAG_MB = col_character(),
##   EQ_MAG_ML = col_double(),
##   EQ_MAG_MFA = col_character(),
##   EQ_MAG_UNK = col_character(),
##   COUNTRY = col_character(),
##   STATE = col_character(),
##   LOCATION_NAME = col_character(),
##   LATITUDE = col_character(),
##   LONGITUDE = col_character(),
##   DEATHS = col_character(),
##   MISSING = col_character(),
##   INJURIES = col_character(),
##   DAMAGE_MILLIONS_DOLLARS = col_character(),
##   TOTAL_DEATHS = col_character(),
##   TOTAL_MISSING = col_character()
##   # ... with 2 more columns
## )
```

```
## See spec(...) for full column specifications.
```

```r
    dim(eqdata)
```

```
## [1] 5952   47
```

### Cleaning tools

eq_clean_data convert LATITUDE and LONGITUDE to numeric


```r
    library(eqtools)
    str(eqdata$LATITUDE)
```

```
##  chr [1:5952] "  31.100" "  38.000" "  35.683" "  36.400" ...
```

```r
    eq_data_clean <- eq_clean_data(eqdata)
    str(eq_data_clean$LATITUDE)
```

```
##  num [1:5952] 31.1 38 35.7 36.4 31.5 ...
```

eq_clean_location removes country from LOCATION_NAME and converts it to title case


```r
    eqdata$LOCATION_NAME[1]
```

```
## [1] "JORDAN:  BAB-A-DARAA,AL-KARAK"
```

```r
    eq_data_ready <- eq_clean_location(eq_data_clean)
    eq_clean$LOCATION_NAME[1]
```

```
## [1] "Bab-a-Daraa,al-Karak"
```

### Plotting Tools

geom_timeline() creates a timeline plot of eathquakes by year


```r
    library(dplyr)
    library(ggplot2)
    library(grid)
    minYear <- 2000		  
    maxYear <- 2010		  
    eq_us_mex_data <- dplyr::mutate(eq_data_ready) %>%
          filter( YEAR >= minYear,YEAR <= maxYear, COUNTRY %in% c("USA","MEXICO")) %>%
	  mutate(EQ_PRIMARY = as.numeric(EQ_PRIMARY))
     ggplot(eq_us_mex_data,aes(x = YEAR, y = 1,
         xmin = minYear,xmax = maxYear,
         )) +
  geom_timeline(aes(size = EQ_PRIMARY))
```

![plot of chunk timeline_plot](figure/timeline_plot-1.png)

geom_timeline_label() adds labels to the geom_timeline plot


```r
     ggplot(eq_us_mex_data,aes(x = YEAR, y = 1,
         xmin = minYear,xmax = maxYear,
         )) +
  geom_timeline(aes(size = EQ_PRIMARY)) +
  geom_timeline_label(aes(label = LOCATION_NAME,n_max = 10))
```

![plot of chunk timeline_plot_annot](figure/timeline_plot_annot-1.png)

### Mapping Tools

eq_map creates a leaflet map

```r
      library(leaflet)
      
      eq_map(eq_us_mex_data,annot_col = "DATE")
```

```
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

```
## Warning in normalizePath(f2): path[1]="./webshot35d64e7fd70.png": No such
## file or directory
```

```
## Warning in file(con, "rb"): cannot open file './webshot35d64e7fd70.png': No
## such file or directory
```

```
## Error in file(con, "rb"): cannot open the connection
```

eq_create_label() formats information to be used in a web popup


```r
  popup_labels <- eq_create_label(adf) 
  paste(popup_labels[1],"\n")
```

```
## [1] "<b>Location</b> JORDAN:  BAB-A-DARAA,AL-KARAK <br /> <b>Magnitude:</b>  7.3 <br /> <b>Total deaths:</b> NA <br /> \n"
```



> "He who gives up [code] safety for [code] speed deserves neither."
([via](https://twitter.com/hadleywickham/status/504368538874703872))
