
test_that("download_data", {

              d_ex <- readRDS(system.file("extdata", "ex_data.rds", 
                                          package = "ATdatabase"))
              res <- d_ex %>%
                  dplyr::filter(station == ex_data_station) %>%
                  dplyr::filter(timestamp > as.numeric(ex_data_ranges$range1$Tstart) & 
                         timestamp <= as.numeric(ex_data_ranges$range1$Tend))
                  nrow_range1 <- nrow(res)

                  res <- d_ex %>%
                      dplyr::filter(station == ex_data_station) %>%
                      dplyr::filter(timestamp > as.numeric(ex_data_ranges$range2$Tstart) & 
                             timestamp <= as.numeric(ex_data_ranges$range2$Tend))
              nrow_range2 <- nrow(res)


              create_database_tables(dbconn)
              v1 <- download_data(station = ex_data_station,
                                  Tstart = ex_data_ranges$range1$Tstart,
                                  Tend = ex_data_ranges$range1$Tend,
                                  fun = "download_data_fun", 
                                  conn = dbconn)



              db <- get_db_tables(dbconn)
              expect_true(nrow(v1) == nrow_range1)
              expect_true(nrow(db$cache) == 1)
              expect_true(nrow(db$measurements) == nrow_range1)


              v2 <- download_data(station = ex_data_station,
                                  Tstart = ex_data_ranges$range2$Tstart,
                                  Tend = ex_data_ranges$range2$Tend,
                                  fun = "download_data_fun", 
                                  conn = dbconn)
              db <- get_db_tables(dbconn)
              expect_true(nrow(v2) == nrow_range2)
              expect_true(nrow(db$cache) == 2)
              expect_true(nrow(db$measurements) == (nrow_range1 + nrow_range2))


                      drop_database_tables(dbconn)

})
