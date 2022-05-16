#' Downloads data using download handler
#'
#' This function downloads measurements for a specific time range and
#' adds these to the database. Depending on the source (e.g. an API)
#' of the data, a download handler is needed. This download handler is
#' a function wich get's the data for the time range and returns a
#' data.frame with using a specific format.
#'
#' @param station station id
#' @param Tstart start of time range
#' @param Tend end of time range
#' @param fun name of function to use as downloadhandler
#' @param conn database connection object
#'
#' @return a data.frame with the downloaded measurements or NULL if no
#' measurements are downloaded
#'
#' This function does three things. It first determines which (parts
#' of the) time ranges are missing from the database. Next, it will
#' download the missing data. Third, it adds the data to the database
#' and updates the table wich the available time ranges
#'
#' This function uses a seperate function as download handler.
#' Depending on the source (file, database or API) a specific function
#' must be available
#'
#' TODO: complete this, but first explain working in vignette, add
#' summery here
#'
#' @export
#'
#'


download_data <- function(station, Tstart, Tend, fun, conn) {

    s_id  <- station
    ranges <- get_download_ranges(station = s_id, Tstart = Tstart, Tend = Tend,
                                   conn = conn)

    if(nrow(ranges) > 0) {

        v1 <- apply(ranges, 1, eval(fun), station = station)
        if(!is.null(v1)) {
            v2 <- do.call("rbind", v1)
            insert_measurements(data = v2, conn)
            insert_downloaded_ranges(station, ranges, conn)
        } else {
            v2 <- NULL
        }

    } else {
        v2 <- NULL
    }

    return(v2)
}


#' Example download handler function
#'
#' This is an example of a download function. We need to explain this
#' further.
#'
#' @export
download_data_fun <- function(x, station, conn) {
    # conn is ingored

    db_ex <- system.file("extdata", "ex_data.rds", package = "ATdatabase")
    d <- readRDS(db_ex)

    s_id  <-  station
    res <- d %>%
        dplyr::filter(station == s_id) %>%
        dplyr::filter(timestamp > x[1] & timestamp <= x[2]) %>%
        dplyr::select(-lat, lon) %>%
        dplyr::mutate(aggregation = 3600)

}


