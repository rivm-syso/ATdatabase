######################################################################
# test setup
######################################################################

message("executing setup")
fname_db <- tempfile()

dbconn <- pool::dbPool(drv = RSQLite::SQLite(), dbname = fname_db)
