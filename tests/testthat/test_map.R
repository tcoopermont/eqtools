
library(eqtools)
library(readr)

test_that("eq_map returns a object with class leaflet",{
   adf <- read_delim(  system.file("extdata", "signif-july-2017.txt.gz", package = "eqtools"),delim = "\t")
   cdf <- eq_clean_data(adf)
   #getting a warning about bad lat,long
   amap <- eq_map(cdf,annot_col = "DATE")
   expect_equal(class(amap),c("leaflet","htmlwidget"))
})

test_that("eq_create_label returns correct data",{
   adf <- read_delim(  system.file("extdata", "signif-july-2017.txt.gz", package = "eqtools"),delim = "\t")
   popup_labels <- eq_create_label(adf)
   #haven't run eq_clean_location
   expect_equal(popup_labels[1],"<b>Location</b> JORDAN:  BAB-A-DARAA,AL-KARAK <br /> <b>Magnitude:</b>  7.3 <br /> <b>Total deaths:</b> NA <br />")
})
