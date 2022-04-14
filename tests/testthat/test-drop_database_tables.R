test_that("drop_database_tables", {

create_database_tables(dbconn)
    
lst <- pool::dbListTables(dbconn)
tables <- c("cache", "measurements", "meta", "sensor")

drop_database_tables(dbconn)
lst <- pool::dbListTables(dbconn)
expect_true(length(lst) == 1)



})

