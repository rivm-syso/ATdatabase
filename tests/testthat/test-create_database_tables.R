test_that("create_database_tables", {

cat("connect\n")
pool <- pool::dbPool(drv = SQLite::SQLite(), dbname = fname_db)

cat("create\n")
create_database_tables(pool)
    
lst <- pool::dbListTables(pool)
tables <- c("cache", "measurements", "meta", "sensor")
expect_true(length(setdiff(tables,lst)) == 0)

cat("drop\n")
drop_database_tables(pool)

cat("clsing\n")
# pool::poolClose(pool)
#RSQLite::dbDisconnect(pool)





})
