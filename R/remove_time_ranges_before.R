#' Remove time ranges downloaded before a given date
#'
#' Remove measurements from the database based on the moment they were
#' downloaded. Every time a time range is stored in the caching table,
#' the download time is recorded in the `time_dl` field. This function
#' removes all cached time ranges that were downloaded before the given
#' date, together with the measurements that belong to those ranges.
#'
#' For each cached time range that was downloaded before `date`, the
#' function removes the measurements of the station between the start
#' and end time of that range, including the measurements exactly at
#' the start and end time. If, after removing these measurements, no
#' other measurements for that station remain, the station is also
#' removed from the location table. The processed record is removed
#' from the caching table.
#'
#' @param date a datetime (POSIXct) object. All cached time ranges with
#'   a download time before this date are removed.
#' @param conn database connection object
#'
#' @return a named list with one element per removed time range. Each
#'   element is named after the station and is itself a list with the
#'   `start` and `end` time of the removed range (as POSIXct) and a
#'   boolean `removed` indicating whether the station was removed from
#'   the location table.
#'
#' @export

remove_time_ranges_before <- function(date, conn) {

    if(!"POSIXct" %in% class(date)) {
        stop("ERROR remove_time_ranges_before: date is not a datetime (POSIXct) class")
    }

    cutoff <- as.numeric(date)

    qry <- glue::glue_sql("SELECT id FROM cache WHERE time_dl < {cutoff};",
                          .con = conn)
    ids <- pool::dbGetQuery(conn, qry)$id

    result <- list()

    for(id in ids) {

        qry <- glue::glue_sql("SELECT station, start, end FROM cache WHERE id = {id};",
                              .con = conn)
        record <- pool::dbGetQuery(conn, qry)

        station <- record$station
        start <- record$start
        end <- record$end

        qry <- glue::glue_sql("DELETE FROM measurements WHERE station = {station} AND timestamp >= {start} AND timestamp <= {end};",
                              .con = conn)
        pool::dbExecute(conn, qry)

        qry <- glue::glue_sql("SELECT count(*) AS n FROM measurements WHERE station = {station};",
                              .con = conn)
        remaining <- pool::dbGetQuery(conn, qry)$n

        removed <- FALSE
        if(remaining == 0) {
            qry <- glue::glue_sql("DELETE FROM location WHERE station = {station};",
                                  .con = conn)
            pool::dbExecute(conn, qry)
            removed <- TRUE
        }

        qry <- glue::glue_sql("DELETE FROM cache WHERE id = {id};",
                              .con = conn)
        pool::dbExecute(conn, qry)

        result[[station]] <- list(start = lubridate::as_datetime(start),
                                  end = lubridate::as_datetime(end),
                                  removed = removed)
    }

    return(result)
}
