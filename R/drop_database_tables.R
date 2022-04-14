



drop_database_tables <- function(conn) {

    lst <- dbListTables(conn)
    for (i in lst) {
        if(grepl("_sequence",i)) {
            next
        }
        qry <- paste("drop table", i, ";")
        dbExecute(conn, qry)
    }
}

