library(eqtools)
library(readr)

test_that("lat and long are converted to numeric",{
   adf <- read_delim(  system.file("extdata", "signif-july-2017.txt.gz", package = "eqtools"),delim = "\t")
   cdf <- eq_clean_data(adf)
   expect_equal(cdf$LONGITUDE[1],35.5)
   expect_equal(cdf$LATITUDE[1],31.1)
})

test_that("location_name is converted to title case and country is removed",{
   adf <- read_delim(  system.file("extdata", "signif-july-2017.txt.gz", package = "eqtools"),delim = "\t")
   cdf <- eq_clean_location(adf)
   expect_equal(cdf$LOCATION_NAME[1],"Bab-a-Daraa,al-Karak")
})
   
