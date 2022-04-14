######################################################################
# test setup
######################################################################



message("executing setup")
fname_db <- tempfile()
db <- RSQLite::dbConnect(RSQLite::SQLite(), fname_db)
RSQLite::dbDisconnect(db)
