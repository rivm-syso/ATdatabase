# internal functions to assist with time ranges. These time ranges are
# used in the caching table


insert_time_range <- function(x, station, conn)  {

    if(length(x) >2) {
        stop("ERROR insert_time_range: length range >2")
    }

    start <- x[1]
    end <- x[2]

    qry <- glue::glue_sql('INSERT INTO cache (station, start, end) VALUES ("{station}", {start}, {end});',
                .con = conn)

    pool::dbExecute(conn, qry)
}

