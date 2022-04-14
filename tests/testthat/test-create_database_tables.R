test_that("create_database_tables", {

pool <- pool::dbPool(drv = RSQLite::SQLite(), dbname = fname_db)

create_database_tables(pool)
    
lst <- pool::dbListTables(pool)
tables <- c("cache", "measurements", "meta", "sensor")
expect_true(length(setdiff(tables,lst)) == 0)

drop_database_tables(pool)

pool::poolClose(pool)

})
