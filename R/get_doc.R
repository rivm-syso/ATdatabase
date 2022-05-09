#' Gets a meta-document from the database
#'
#' This function gets a meta-data document from the database, using
#' type and reference as search criteria.
#'
#' @param type character string with type 
#' @param ref character string with reference 
#' @param conn database connection object
#'
#' @return The R object or NA if object is not found
#'
#' A meta-data document is an R object which are stored in the
#' database. Each object must have a type and reference (ref) so they
#' are findable
#'
#' This functions gets the specific data object from the database and
#' returns it as an R object (the same object when it was stored). If
#' the object is not found, this function returns NA
#'
#' @export
#'


get_doc <- function(type, ref, conn) {

    # BUG:  als type, ref id meerdere records opleveren, dan gaat het
    # fout
    # constraint op combi type-ref?
    # see
    # https://stackoverflow.com/questions/7407506/unique-combination-of-fields-in-sqlite


    if(!is.character(type)) {
        stop("ERROR add_doc: type is not character")
    }

    if(!is.character(ref)) {
        stop("ERROR add_doc: type is not character")
    }


    qry <- glue::glue_sql("SELECT doc FROM meta WHERE 
                    type={type} and ref={ref};", .con = conn)

                    
   res <- dbGetQuery(conn, qry)
   if(nrow(res) == 0) {
       d <- NA
   } else {
       d <- jsonlite::fromJSON(res$doc)
   }
   return(d)

}



