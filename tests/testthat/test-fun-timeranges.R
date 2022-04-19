test_that("insert_time_ranges input", {

              create_database_tables(dbconn)
              expect_error(insert_time_range(ex_ranges, "test", conn = dbconn))
              drop_database_tables(dbconn)

})

test_that("insert_time_ranges output", {

              create_database_tables(dbconn)

              range <- ex_ranges[1,]
              insert_time_range(range, "test", conn = dbconn)
              res <- get_db_tables(dbconn)$cache
              expect_equal(res$start, ex_ranges[1,1])
              expect_equal(res$end, ex_ranges[1,2])
              expect_equal(res$station, "test")

              drop_database_tables(dbconn)

})


test_that("get_available_time_ranges output", {

              create_database_tables(dbconn)

              range <- ex_ranges[1,]
              insert_time_range(range, "test-1", conn = dbconn)
              range <- ex_ranges[2,]
              insert_time_range(range, "test-2", conn = dbconn)
              range <- ex_ranges[3,]
              insert_time_range(range, "test-2", conn = dbconn)

              res <- get_available_time_ranges("test-1", dbconn)
              expect_true(res[1,1] == ex_ranges[1,1])
              expect_true(res[1,2] == ex_ranges[1,2])
                  
              res <- get_available_time_ranges("test-2", dbconn)
              expect_true(nrow(res) == 2) 
              expect_true(res[1,1] == ex_ranges[2,1])

              res <- get_available_time_ranges("nonexisting", dbconn)
              expect_true(nrow(res) == 0) 

              drop_database_tables(dbconn)


})



test_that("get_missing_time_ranges output", {

              create_database_tables(dbconn)

              range <- ex_ranges[1,]
              insert_time_range(range, "test-1", conn = dbconn)
              range <- ex_ranges[2,]
              insert_time_range(range, "test-1", conn = dbconn)
              range <- ex_ranges[3,]
              insert_time_range(range, "test-1", conn = dbconn)

              range <- get_available_time_ranges("test-1", dbconn)
              res <- get_missing_time_ranges(range,
                                             Tstart = req_range1$Tstart,
                                             Tend = req_range1$Tend)
              expect_true(res[1,2] == as.numeric(req_range1$missing_Tend))

              res <- get_missing_time_ranges(range,
                                             Tstart = req_range2$Tstart,
                                             Tend = req_range2$Tend)

              expect_true(res[1,1] == as.numeric(req_range2$missing_Tstart_1))
              expect_true(res[1,2] == as.numeric(req_range2$missing_Tend_1))
              expect_true(res[2,1] == as.numeric(req_range2$missing_Tstart_2))
              expect_true(res[2,2] == as.numeric(req_range2$missing_Tend_2))

              drop_database_tables(dbconn)
})



test_that("insert_downloaded_ranges output", {
              create_database_tables(dbconn)

              
              insert_downloaded_ranges("test", ex_ranges, dbconn)
              res <- get_db_tables(dbconn)$cache
              expect_equal(ex_ranges[1,1], res$start[1])
              expect_equal(ex_ranges[1,2], res$end[1])
              expect_equal(ex_ranges[3,1], res$start[3])
              expect_equal(ex_ranges[3,2], res$end[3])

               drop_database_tables(dbconn)

})
