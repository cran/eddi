## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  fig.width = 8, 
  fig.height = 5
)

NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(purl = NOT_CRAN, eval = NOT_CRAN)

## ----load-roi-shapefile--------------------------------------------------
library(sf)
library(raster)
library(eddi)

roi <- st_read(system.file("shape/nc.shp", package="sf"))

## ----print-roi-shapefile-------------------------------------------------
roi

## ------------------------------------------------------------------------
roi <- st_union(roi)
roi

## ----get-eddi-data-------------------------------------------------------
eddi_raster <- get_eddi(date = "2018-07-01", timescale = "1 week")

## ----inspect-eddi--------------------------------------------------------
eddi_raster

## ----plot-eddi-conus-----------------------------------------------------
color_pal <- colorRampPalette(c("blue", "lightblue", "white", "pink", "red"))
plot(eddi_raster, col = color_pal(255))

## ----reproject-to-same-crs-----------------------------------------------
roi_reprojected <- st_transform(roi, crs = projection(eddi_raster))

## ----plot-eddi-with-shp--------------------------------------------------
plot(eddi_raster, col = color_pal(255))
plot(roi_reprojected, add = TRUE)

## ----mask-eddi-----------------------------------------------------------
roi_sp <- as(roi_reprojected, 'Spatial')
cropped_eddi <- crop(eddi_raster, roi_sp)
masked_eddi <- mask(cropped_eddi, roi_sp)

## ------------------------------------------------------------------------
plot(masked_eddi, col = color_pal(255))
plot(roi_sp, add = TRUE)

## ----write-tif, eval = FALSE---------------------------------------------
#  output_directory <- tempdir()
#  output_file <- file.path(output_directory, 'eddi-over-roi.tif')
#  writeRaster(masked_eddi, output_file)

