#' `fxn_hourlyData.R` Download AZMet hourly data from API-based database
#' 
#' @param azmetStation - AZMet station name
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `hourlyData` - Table of downloaded, transformed hourly data


fxn_hourlyData <- function(azmetStation, startDate, endDate) {
  startDateTime = paste(startDate, "01", sep = " ")
  
  if (endDate == lubridate::today(tzone = "America/Phoenix")) {
    endDateTime = NULL
  } else {
    endDateTime = paste(endDate, "24", sep = " ")
  }
  
  hourlyData <- azmetr::az_hourly(
    station_id = azmetStation,
    start_date_time = startDateTime, 
    end_date_time = endDateTime
  ) %>% 
    dplyr::select(all_of(c(hourlyVarsID, hourlyVarsMeasured, hourlyVarsDerived))) %>%
    
    dplyr::mutate(
      temp_soil_10cmC = dplyr::if_else(
        meta_station_name == "Test",
        NA_real_,
        temp_soil_10cmC
      ),
      temp_soil_50cmC = dplyr::if_else(
        meta_station_name == "Test",
        NA_real_,
        temp_soil_50cmC
      ),
      temp_soil_10cmF = dplyr::if_else(
        meta_station_name == "Test",
        NA_real_,
        temp_soil_10cmF
      ),
      temp_soil_50cmF = dplyr::if_else(
        meta_station_name == "Test",
        NA_real_,
        temp_soil_50cmF
      )
    ) |>
    
    dplyr::mutate(
      dplyr::across("wind_2min_timestamp", as.character)
    ) %>% 
    
    dplyr::mutate(
      meta_station_group = dplyr::if_else(
        meta_station_name %in% c("Ft Mohave CA", "Mohave", "Mohave ETo", "Mohave-2", "Parker", "Parker-2"),
        "Group 1",
        dplyr::if_else(
          meta_station_name %in% c("Roll", "Wellton ETo", "Yuma N.Gila", "Yuma South", "Yuma Valley", "Yuma Valley ETo"),
          "Group 2",
          dplyr::if_else(
            meta_station_name %in% c("Aguila", "Buckeye", "Harquahala", "Paloma", "Salome"),
            "Group 3",
            dplyr::if_else(
              meta_station_name %in% c("Chino Valley", "Desert Ridge", "Payson", "Phoenix Encanto", "Phoenix Greenway"),
              "Group 4",
              dplyr::if_else(
                meta_station_name %in% c("Coolidge", "Maricopa", "Queen Creek", "Sahuarita", "Test", "Tucson"),
                "Group 5",
                "Group 6"
              )
            )
          )
        )
      )
    )
  
  return(hourlyData)
}
