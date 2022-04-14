#' Drop data base tables
#'
#' This function drops (removes) all database tables. Use with
#' caution.
#'
#' @param conn pool connection object
#'
#' This function drops all tables from the connected database. Please
#' use this with caution, because this operation can not be undone
#'
#' @export



drop_database_tables <- function(conn) {

    lst <- pool::dbListTables(conn)
    for (i in lst) {
        if(grepl("_sequence",i)) {
            next
        }
        qry <- glue::glue_sql("drop table {i};", .con = conn)
        pool::dbExecute(conn, qry)
    }
}

