test_that("insert_measurements", {

              create_database_tables(dbconn)

              db_ex <- system.file("extdata", "ex_data.rds", package = "ATdatabase")
              ex_data <- readRDS(db_ex)[1:10,]
              ex_data <- cbind(ex_data, aggregation = 3600)

              insert_measurements(ex_data, dbconn)

              d_tab <- get_db_tables(dbconn)$measurements

              expect_true(nrow(d_tab) == 10)

              drop_database_tables(dbconn)


})

test_that("location_exists", {


             create_database_tables(dbconn)

             expect_false(location_exists(station = "test1", lat = 51.1, lon = 4.1,
                                          conn = dbconn))

             insert_location_info(station = "test1",
                                 lat =51.1, lon = 4.1,
                                 conn = dbconn)

             expect_true(location_exists(station = "test1", lat = 51.1, lon = 4.1,
                                          conn = dbconn))

             # different coordinates, same name
             expect_false(location_exists(station = "test1", lat = 51.2, lon = 4.1,
                                          conn = dbconn))

             # same coordinates, different name
             expect_false(location_exists(station = "test2", lat = 51.1, lon = 4.1,
                                          conn = dbconn))


             drop_database_tables(dbconn)
})

