######################################################################
# test helper functions
######################################################################

# insert a cache record with an explicit download time
seed_cache <- function(station, start, end, time_dl, conn) {
    qry <- glue::glue_sql(
        "INSERT INTO cache (station, start, end, time_dl) VALUES ({station}, {start}, {end}, {time_dl});",
        .con = conn)
    pool::dbExecute(conn, qry)
}

# insert a single measurement
seed_measurement <- function(station, timestamp, conn) {
    qry <- glue::glue_sql(
        "INSERT INTO measurements (station, parameter, value, aggregation, timestamp) VALUES ({station}, 'pm25', 1.0, 3600, {timestamp});",
        .con = conn)
    pool::dbExecute(conn, qry)
}

# insert a location record
seed_location <- function(station, conn) {
    qry <- glue::glue_sql(
        "INSERT INTO location (station, lat, lon, timestamp) VALUES ({station}, 52.0, 5.0, 0);",
        .con = conn)
    pool::dbExecute(conn, qry)
}
