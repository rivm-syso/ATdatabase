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
