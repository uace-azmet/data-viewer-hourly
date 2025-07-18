# Libraries --------------------

library(azmetr)
library(bslib)
library(bsicons)
library(dplyr)
# library(english)
library(htmltools)
library(lubridate)
library(plotly)
library(reactable)
# library(reshape2)
library(shiny)
library(shinyjs)
library(vroom)
library(tibble)


# Files --------------------

# Functions. Loaded automatically at app start if in `R` folder
#source("./R/fxn_functionName.R", local = TRUE)

# Scripts. Loaded automatically at app start if in `R` folder
#source("./R/scr_scriptName.R", local = TRUE)

# azmetStationMetadata <- 
#   vroom::vroom(
#     file = "aux-files/azmet-station-metadata.csv", 
#     delim = ",", 
#     col_names = TRUE, 
#     show_col_types = FALSE
#   )


# Variables --------------------

apiStartDate <- as.Date("2021-01-01")

azmetStationMetadata <- azmetr::station_info |>
  dplyr::mutate(end_date = NA) |> # Placeholder until inactive stations are in API and `azmetr`
  dplyr::mutate(
    end_date = dplyr::if_else(
      status == "active",
      lubridate::today(tzone = "America/Phoenix") - 1,
      end_date
    )
  )

# Identification and date variables
hourlyVarsID <- 
  c(
    "date_datetime", 
    "date_doy",
    "date_hour",
    "date_year", 
    "meta_needs_review", 
    "meta_station_id", 
    "meta_station_name", 
    "meta_version"
  )

# Measured (or derived at station datalogger) variables
hourlyVarsMeasured <- 
  c(
    "meta_bat_volt", 
    "precip_total", 
    "relative_humidity", 
    "sol_rad_total", 
    "temp_airC", 
    "temp_soil_10cmC", 
    "temp_soil_50cmC", 
    "vp_actual", 
    "vp_deficit", 
    "wind_2min_spd_max_mps", 
    "wind_2min_spd_mean_mps", 
    "wind_2min_timestamp", 
    "wind_2min_vector_dir", 
    "wind_spd_max_mps", 
    "wind_spd_mps", 
    "wind_vector_dir", 
    "wind_vector_dir_stand_dev", 
    "wind_vector_magnitude"
  )

# Derived (after data retrievd from station) variables
hourlyVarsDerived <- 
  c(
    "dwpt", 
    "dwptF", 
    "eto_azmet", 
    "eto_azmet_in", 
    "heatstress_cottonC", 
    "heatstress_cottonF", 
    "precip_total_in", 
    "sol_rad_total_ly",
    "temp_airF", 
    "temp_soil_10cmF", 
    "temp_soil_50cmF", 
    "wind_2min_spd_max_mph", 
    "wind_2min_spd_mean_mph", 
    "wind_spd_max_mph", 
    "wind_spd_mph", 
    "wind_vector_magnitude_mph"
  )

# selectedTab <- shiny::reactiveVal(value = "Time Series")

stationGroups <-
  tibble::tibble(
    group1 = c("Ft Mohave CA", "Mohave", "Mohave ETo", "Mohave-2", "Parker", "Parker-2"),
    group2 = c("Roll", "Wellton ETo", "Yuma N.Gila", "Yuma South", "Yuma Valley", "Yuma Valley ETo"),
    group3 = c("Aguila", "Buckeye", "Harquahala", "Paloma", "Salome", NA),
    group4 = c("Chino Valley", "Desert Ridge", "Payson", "Phoenix Encanto", "Phoenix Greenway", NA),
    group5 = c("Coolidge", "Maricopa", "Queen Creek", "Sahuarita", "Test", "Tucson"),
    group6 = c("Bonita", "Bowie", "Elgin", "Safford", "San Simon", "Willcox Bench")
  )
