#' Create new set of database tables
#'
#' This function creates the database tables for this package. It uses
#' a pool object with the database connection
#'
#' @param conn connection object with database connection
#'
#' @export
#'
#'
#'
#'



create_database_tables <- function(conn) {

    qry = "
    CREATE TABLE measurements (
                               id  INTEGER PRIMARY KEY AUTOINCREMENT,
                               station TEXT NOT NULL,
                               parameter TEXT NOT NULL, 
                               value REAL,
                               aggregation REAL,
                               timestamp INTEGER
    )
    "
    pool::dbExecute(conn,qry)


    qry = "
    CREATE TABLE location (
                         id  INTEGER PRIMARY KEY AUTOINCREMENT,
                         station TEXT NOT NULL,
                         lat REAL,
                         lon REAL,
                         timestamp INTEGER
    )
    "
    pool::dbExecute(conn,qry)

    qry = "
    CREATE TABLE cache (
                        id  INTEGER PRIMARY KEY AUTOINCREMENT,
                        station TEXT NOT NULL,
                        start INTEGER,
                        end INTEGER
    )
    "
    pool::dbExecute(conn,qry)

    qry = "
    CREATE TABLE meta (
                        id  INTEGER PRIMARY KEY AUTOINCREMENT,
                        type TEXT NOT NULL,
                        ref TEXT NOT NULL,
                        doc TEXT NOT NULL
    )
    "
    pool::dbExecute(conn, qry)

    qry <- "CREATE INDEX idx_measurements ON measurements (station, timestamp)"
    pool::dbExecute(conn, qry)

    qry <- "CREATE INDEX idx_location ON location (station)"
    pool::dbExecute(conn, qry)

    qry <- "CREATE INDEX idx_meta ON meta (type,ref)"
    pool::dbExecute(conn, qry)


}

