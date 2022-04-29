

test_that("inser_sensor_info, input", {

             create_database_tables(dbconn)

             expect_error(insert_station_info(station = 1, 
                                              lat = 51.1, lon = 4.1,
                                              conn = dbconn))


             expect_error(insert_station_info(station = "test1", 
                                              lat = "a", lon = 4.1,
                                              conn = dbconn))


             expect_error(insert_station_info(station = "test1", 
                                              lat = 41.1, lon = "a",
                                              conn = dbconn))

             drop_database_tables(dbconn)
})


test_that("insert_sensor_info, output", {

             create_database_tables(dbconn)

             insert_sensor_info(station = "test1",
                                 lat =51.1, lon = 4.1,
                                 conn = dbconn)


             db <- get_db_tables(dbconn)
             t1  <- db$sensor
             expect_true(nrow(t1) == 1)
             expect_true(t1$station[1] == "test1")

             drop_database_tables(dbconn)
})

