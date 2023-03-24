# miscellaneous database functions


insert_measurements <- function(data, conn) {

    # create tmp table name:
    tmptbl <- basename(tempfile(pattern = "tmp", tmpdir = ""))

    dbWriteTable(conn, tmptbl, data, overwrite = TRUE)
    qry  <- paste("insert into measurements (station, parameter,
    value, aggregation, timestamp) select station,  parameter,
    value, aggregation, timestamp from", tmptbl) 
    dbExecute(conn,qry)      

    qry <- paste("drop table", tmptbl)
    dbExecute(conn,qry)      
}

location_exists <- function(station, lat, lon,  conn) {

    qry <- glue::glue_sql("select {station} from location where station = {station} and lat = {lat} and lon = {lon};", .con = conn)
    res <- dbGetQuery(conn, qry)

   if(nrow(res)>=1) {
       result <- TRUe
   } else {
       result <- FALSE
   }

   return(result)

}


