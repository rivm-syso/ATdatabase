#' Determine wich time ranges are missing
#'
#' This function determines which time ranges are missng in the
#' database. These time ranges must be downloaded using a
#' downloadhandler
#'
#' @param station station identifier
#' @param Tstart start of requested time range
#' @param Tend end of requested time range
#'
#' @return a matrix with time ranges (in seconds) which can be used to
#' download the misisng data
#'
#' @export



get_download_ranges <- function(station, Tstart, Tend, conn) {

    if(!"POSIXct" %in% class(Tstart)) {
        stop("ERROR get_download_ranges: Tstart is not a datetime (POSIXct) class")
    }
    if(!"POSIXct" %in% class(Tend)) {
        stop("ERROR get_download_ranges: Tend not a datetime (POSIXct) class")
    }


    ts <- as.numeric(Tstart)
    te <- as.numeric(Tend)

    req_matrix <- matrix(c(ts, te), ncol = 2)
    ranges <- get_available_time_ranges(station, conn)
    if(nrow(ranges) == 0) { #first request of kitid
        missing <- req_matrix

    } else { # allready some ranges exist
        missing <- get_missing_time_ranges(ranges, ts, te)
    }
    return(missing)

}


