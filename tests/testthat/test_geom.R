
library(eqtools)
library(readr)
library(leaflet)
library(ggplot2)
library(dplyr)


test_that("geom_timeline returns a object with class ggplot",{
   minYear <- 2000		  
   maxYear <- 2010		  
   adf <- read_delim(  system.file("extdata", "signif-july-2017.txt.gz", package = "eqtools"),
		       delim = "\t")
   cdf <- eq_clean_data(adf) %>%
          dplyr::filter_(~ YEAR >= minYear,~ YEAR <= maxYear, ~ COUNTRY %in% c("USA","MEXICO")) %>%
	  dplyr::mutate_(EQ_PRIMARY = ~ as.numeric(EQ_PRIMARY))
   aplot <- ggplot(cdf,aes(x = YEAR, y = 1,
         xmin = minYear,xmax = maxYear,
         )) +
   geom_timeline(aes(size = EQ_PRIMARY))
   expect_is(aplot,"gg")
   expect_is(aplot,"ggplot")
   #expect_s3_class(aplot,"ggplot")
})

test_that("geom_timeline_label returns a object with class ggplot",{
   minYear <- 2000		  
   maxYear <- 2010		  
   adf <- read_delim(  system.file("extdata", "signif-july-2017.txt.gz", package = "eqtools"),
		       delim = "\t")
   cdf <- eq_clean_data(adf) %>%
          dplyr::filter_( ~ YEAR >= minYear,~ YEAR <= maxYear, ~ COUNTRY %in% c("USA","MEXICO")) %>%
	  dplyr::mutate_(EQ_PRIMARY = ~ as.numeric(EQ_PRIMARY))
   aplot <- ggplot(cdf,aes(x = YEAR, y = 1,
         xmin = minYear,xmax = maxYear,
         )) +
  geom_timeline(aes(size = EQ_PRIMARY)) +
  geom_timeline_label()
  

   expect_is(aplot,"gg")
   expect_is(aplot,"ggplot")
})
