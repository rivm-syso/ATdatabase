######################################################################
# test setup
######################################################################


message("executing setup")

######################################################################
# helper functions
######################################################################
get_db_tables <- function(conn) {
    dbtbls <- list(measurements = dplyr::tbl(conn,"measurements") %>% dplyr::collect() ,
                   sensor = dplyr::tbl(conn, "sensor") %>% dplyr::collect(),
                   meta = dplyr::tbl(conn, "meta") %>% dplyr::collect(),
                   cache = dplyr::tbl(conn, "cache") %>% dplyr::collect()
    )

    return(dbtbls)

}

######################################################################
# example data
######################################################################

ex_ranges <- c(lubridate::as_datetime("2020-01-01 00:00:00"), lubridate::as_datetime("2020-01-02 12:00:00"),
            lubridate::as_datetime("2020-01-04 00:00:00"), lubridate::as_datetime("2020-01-04 12:00:00"),
            lubridate::as_datetime("2020-01-10 08:00:00"), lubridate::as_datetime("2020-01-11 12:00:00")) |>
            matrix(ncol = 2, byrow = TRUE)

req_range1 <- list(Tstart = lubridate::as_datetime("2020-01-01 00:00:00"),
                Tend = lubridate::as_datetime("2020-01-02 18:00:00"),
                missing_Tstart = lubridate::as_datetime("2020-01-01 12:00:00"),
                missing_Tend = lubridate::as_datetime("2020-01-02 18:00:00"))

req_range2 <- list(Tstart = lubridate::as_datetime("2020-01-01 00:00:00"),
                Tend = lubridate::as_datetime("2020-01-05 00:00:00"),
                missing_Tstart_1 = lubridate::as_datetime("2020-01-02 12:00:00"),
                missing_Tend_1 = lubridate::as_datetime("2020-01-04 00:00:00"),
                missing_Tstart_2 = lubridate::as_datetime("2020-01-04 12:00:00"),
                missing_Tend_2 = lubridate::as_datetime("2020-01-05 00:00:00"))

######################################################################
# database setup
######################################################################

fname_db <- tempfile()
dbconn <- pool::dbPool(drv = RSQLite::SQLite(), dbname = fname_db)


