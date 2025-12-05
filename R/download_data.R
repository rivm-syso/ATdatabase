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
#' measurements are downloaded.
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
#' The seperate download handler function must have the following
#' arguments:
#' - x: a vector of length two with start and end of time range
#' - station: station id
#' - conn: database connection object
#'
#' The download handler function must return either NULL (if no data
#' is available) or a data.frame with the following columns:
#' - station: station id
#' - timestamp: POSIXct timestamp of measurement
#' - parameter: parameter name
#' - value: value of measurement
#' - aggregation: aggregation time in seconds
#'
#' The download handler function must take care that the data.frame
#' has the correct format. If no data is available for the requested
#' time range, the function must return NULL.
#'
#' If an error occurs during the download process, the download_data
#' function returns NULL and a warning is issued. The time range is
#' not added to the database in this case.
#'
#' TODO: complete this, but first explain working in vignette, add
#' summary here
#'
#' @export
#'
#'


download_data <- function(station, Tstart, Tend, fun, conn) {

    s_id  <- station
    ranges <- get_download_ranges(station = s_id, Tstart = Tstart, Tend = Tend,
                                   conn = conn)

    if(nrow(ranges) > 0) {

        result <- try(
                      v1 <- apply(ranges, 1, eval(fun), station = station, 
                                  conn = conn),
                      silent = TRUE
                      )
        if(inherits(result, "try-error")) {
            warning(paste("Error in download handler for station", 
                          station, Tstart, Tend))
            return(NULL)
        }

        if(!is.null(v1)) {
            v2 <- do.call("rbind", v1)
            if(!is.data.frame(v2)) {
                stop("download handler must return either NULL or adata.frame")
            }
            if(nrow(v2) > 0) {
            insert_measurements(data = v2, conn)
            insert_downloaded_ranges(station, ranges, conn)
            } else {
                insert_downloaded_ranges(station, ranges, conn)
            }
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
#' @param x time range
#' @param station station id
#' @param conn database connection object
#'
#' @export
download_data_fun <- function(x, station, conn) {
    # conn is ingored

                  
    res_empty <- data.frame(station = NULL,
                            timestamp = NULL,
                            parameter = NULL,
                            value = NULL,
                            aggregation = NULL)

    db_ex <- system.file("extdata", "ex_data.rds", package = "ATdatabase")
    d <- readRDS(db_ex)

    s_id  <-  station
    res <- d %>%
        dplyr::filter(station == s_id) %>%
        dplyr::filter(timestamp > x[1] & timestamp <= x[2]) %>%
        dplyr::select(-lat, lon) %>%
        dplyr::mutate(aggregation = 3600) %>%
        dplyr::bind_rows(res_empty)


}


