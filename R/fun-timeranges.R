# internal functions to assist with time ranges. These time ranges are
# used in the caching table




insert_time_range <- function(x, station, conn)  {

    if(length(x) >2) {
        stop("ERROR insert_time_range: length range >2")
    }

    start <- x[1]
    end <- x[2]

    qry <- glue::glue_sql('INSERT INTO cache (station, start, end) VALUES ({station}, {start}, {end});',
                .con = conn)

    pool::dbExecute(conn, qry)
}




get_available_time_ranges <- function(station, conn){

    ranges <- dplyr::tbl(conn, "cache") %>%
        dplyr::filter(station == {{station}}) %>%
        dplyr::select(start,end) %>%
        dplyr::collect() %>%
        as.matrix()

    return(ranges)
}

get_missing_time_ranges <- function(ranges, Tstart, Tend) {

    requested <- matrix(c(Tstart, Tend), ncol = 2)
    diffs <- IntervalSurgeon::setdiffs(requested, IntervalSurgeon::flatten(ranges))
    return(diffs)
}



insert_downloaded_ranges <- function(station, ranges, conn) {
    if(nrow(ranges) > 0 ) {
    apply(ranges, 1, FUN = insert_time_range, station = station, 
          conn = conn)
    }
}


