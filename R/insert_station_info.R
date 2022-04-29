#' Insert sensor information
#'
#' Insert sensor information (station identifier and lat / lon
#' coordinates) into the database. 
#'
#' @param station station identifier
#' @param lat latitude coordinate
#' @param lon longitude coordinate
#' @param timestamp timestamp, default to current time
#' @param conn database connection object
#'
#' This function insers station information into the database 'sensor'
#' table. Each record contains a station identifier, lat/lon
#' coordinates and a timestamp. The timestamp can be used to track
#' mobile sensors. If no timestamp is given, the current date and time
#' is added.
#'
#' @export



insert_sensor_info <- function(station, lat, lon, conn, timestamp = lubridate::now()) {
    datetime <- as.numeric(timestamp)

    if(!is.character(station)) {
        stop("ERROR: insert_station_info: station is not character")
    }

    if(!is.numeric(lat)||!is.numeric(lon)) {
        stop("ERROR: insert_station_info: lat or lon is not numeric")
    }

    qry <- glue::glue_sql('insert into sensor (station, lat, lon, timestamp) values({station}, {lat}, {lon}, {datetime});',
                          .con = conn)

    dbExecute(conn, qry)


}


