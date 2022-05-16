#' Helper function to converts datetime strings into matrix
#'
#' The download handler functions require a date-time range as input.
#' This is a matrix with timestamps in seconds. This function converts
#' an ordinary time range, as string, into such matrix.
#'
#' @param Tstart Start time
#' @param Tend end time
#'
#' @return A single row matrix suitable for the download handler
#'
#' The start and end time in this function must be given in a string
#' which can be interpreted by lubridate's `as_datetime` function.
#' These strings are converted into timestamps in seconds (POSIXct
#' timestamp) and returned as matrix. The first column is the start
#' time, the second column is the end time.
#'
#'
#' @export



datetime_to_matrix <- function(Tstart, Tend) {

    suppressWarnings(ts <- lubridate::as_datetime(Tstart))
    suppressWarnings(te <- lubridate::as_datetime(Tend))

    if(te < ts) {
        stop("ERROR datetime_to_matrix: end time before start time")
    }

    if(any(is.na(ts), is.na(te))) {
        stop("ERROR datetime_to_matrix: timestamps failed to parse")
    }

    time_stamp <- matrix(c(as.numeric(ts), as.numeric(te)), ncol = 2)
    return(time_stamp)

}

