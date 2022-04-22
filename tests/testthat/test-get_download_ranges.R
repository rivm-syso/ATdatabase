test_that("Get_download_ranges input", {


              create_database_tables(dbconn)

              expect_error(res <- get_download_ranges(station = "test-1",
                                                      Tstart = "a",
                                                      Tend = req_ranges_1$Tend,
                                                      conn = dbconn)
              )


              expect_error(res <- get_download_ranges(station = "test-1",
                                                      Tstart = req_ranges_1$Tend,
                                                      Tend = "a",
                                                      conn = dbconn)
              )

              drop_database_tables(dbconn)

})


test_that("Get_download_ranges output", {
              create_database_tables(dbconn)
              res <- get_download_ranges(station = "test-1",
                                         Tstart = req_range2$Tstart,
                                         Tend = req_range2$Tend,
                                         conn = dbconn)

              expect_true(res[1,1] == as.numeric(req_range2$Tstart))
              expect_true(res[1,2] == as.numeric(req_range2$Tend))
              drop_database_tables(dbconn)
              create_database_tables(dbconn)


              range <- ex_ranges[1,]
              insert_time_range(range, "test-1", conn = dbconn)
              range <- ex_ranges[2,]
              insert_time_range(range, "test-1", conn = dbconn)
              range <- ex_ranges[3,]
              insert_time_range(range, "test-1", conn = dbconn)
              range <- ex_ranges[1,]
              insert_time_range(range, "test-2", conn = dbconn)

              res <- get_download_ranges(station = "test-1",
                                         Tstart = req_range2$Tstart,
                                         Tend = req_range2$Tend,
                                         conn = dbconn)

              expect_true(nrow(res) == 2)
              expect_true(res[1,1] == as.numeric(req_range2$missing_Tstart_1))
              expect_true(res[1,2] == as.numeric(req_range2$missing_Tend_1))
              expect_true(res[2,1] == as.numeric(req_range2$missing_Tstart_2))
              expect_true(res[2,2] == as.numeric(req_range2$missing_Tend_2))

              res <- get_download_ranges(station = "test-2",
                                         Tstart = req_range2$Tstart,
                                         Tend = req_range2$Tend,
                                         conn = dbconn)
              expect_true(nrow(res) == 1)
              expect_true(res[1,1] == as.numeric(req_range2$missing_Tstart_1))
              expect_true(res[1,2] == as.numeric(req_range2$missing_Tend_2))

              drop_database_tables(dbconn)

})

