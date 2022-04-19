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

              drop_database_tables(dbconn)

})


