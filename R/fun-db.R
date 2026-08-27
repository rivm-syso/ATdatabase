# miscellaneous database functions


insert_measurements <- function(data, conn) {

    # create tmp table name:
    tmptbl <- basename(tempfile(pattern = "tmp", tmpdir = ""))

    pool::dbWriteTable(conn, tmptbl, data, overwrite = TRUE)
    qry  <- paste("insert into measurements (station, parameter,
    value, aggregation, timestamp) select station,  parameter,
    value, aggregation, timestamp from", tmptbl) 
    pool::dbExecute(conn,qry)      

    qry <- paste("drop table", tmptbl)
    pool::dbExecute(conn,qry)      
}

location_exists <- function(station, lat, lon,  conn) {

    qry <- glue::glue_sql("select {station} from location where station = {station} and lat = {lat} and lon = {lon};", .con = conn)
    res <- pool::dbGetQuery(conn, qry)

   if(nrow(res)>=1) {
       result <- TRUE
   } else {
       result <- FALSE
   }

   return(result)

}


