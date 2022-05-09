test_that("create_database_tables", {

create_database_tables(dbconn)

lst <- pool::dbListTables(dbconn)
tables <- c("cache", "measurements", "meta", "location")
expect_true(length(setdiff(tables,lst)) == 0)

drop_database_tables(dbconn)

})
