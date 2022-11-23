

test_that("insert_location_info, input", {

             create_database_tables(dbconn)

             expect_error(insert_location_info(station = 1, 
                                              lat = 51.1, lon = 4.1,
                                              conn = dbconn))


             expect_error(insert_location_info(station = "test1", 
                                              lat = "a", lon = 4.1,
                                              conn = dbconn))


             expect_error(insert_location_info(station = "test1", 
                                              lat = 41.1, lon = "a",
                                              conn = dbconn))

             drop_database_tables(dbconn)
})


test_that("insert_location_info, output", {

             create_database_tables(dbconn)

             insert_location_info(station = "test1",
                                 lat =51.1, lon = 4.1,
                                 conn = dbconn)


             db <- get_db_tables(dbconn)
             t1  <- db$location
             expect_true(nrow(t1) == 1)
             expect_true(t1$station[1] == "test1")

             drop_database_tables(dbconn)
})


test_that("insert_location_info, duplicates", {

             create_database_tables(dbconn)

             insert_location_info(station = "test1",
                                 lat =51.1, lon = 4.1,
                                 conn = dbconn)


             insert_location_info(station = "test1",
                                 lat =51.1, lon = 4.1,
                                 conn = dbconn)

             db <- get_db_tables(dbconn)
             t1  <- db$location
             expect_true(nrow(t1) == 1)

             # other location
             insert_location_info(station = "test1",
                                 lat =51.2, lon = 4.1,
                                 conn = dbconn)

             db <- get_db_tables(dbconn)
             t1  <- db$location
             expect_true(nrow(t1) == 2)

             drop_database_tables(dbconn)
})

