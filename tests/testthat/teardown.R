######################################################################
# test teardown
######################################################################

message("executing teardown")
pool::poolClose(dbconn)
unlink(fname_db)
