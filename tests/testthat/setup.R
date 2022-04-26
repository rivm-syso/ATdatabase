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

# just a set of ranges


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


# ranges for example data
ex_data_ranges <- list(range1 = list(
                               Tstart = lubridate::as_datetime("2022-02-01"),
                               Tend = lubridate::as_datetime("2022-02-02 10:00:00")
                               ),
                       range2 = list(
                               Tstart = lubridate::as_datetime("2022-02-04 8:00:00"),
                               Tend = lubridate::as_datetime("2022-02-05 10:00:00")
                               ),
                       range3 = list(
                               Tstart = lubridate::as_datetime("2022-02-03"),
                               Tend = lubridate::as_datetime("2022-02-05 10:00:00")
                               )
                       )

ex_data_station <- "SSK_LH003"


######################################################################
# database setup
######################################################################

fname_db <- tempfile()
dbconn <- pool::dbPool(drv = RSQLite::SQLite(), dbname = fname_db)

fname_db_example <- system.file("extdata","database.db", package = "ATdatabase")
dbconn_ex <- pool::dbPool(drv = RSQLite::SQLite(), dbname = fname_db_example)


