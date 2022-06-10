#' Removes a meta document
#'
#' Removes a meta document from the meta table based on the type and
#' ref
#'
#' @param type character string with type 
#' @param ref character string with reference 
#' @param conn database connection object
#'
#' @return nothing
#'
#' This function removes a meta document from the meta table based on
#' the given type and ref. This function does not return anything. It
#' doesn't matter if the document to remove does not exists.
#'
#' @export
#'

remove_doc <- function(type, ref, conn) {


    if(!is.character(type)) {
        stop("ERROR add_doc: type is not character")
    }

    if(!is.character(ref)) {
        stop("ERROR add_doc: type is not character")
    }

    qry <- glue::glue_sql("DELETE FROM meta WHERE 
                    type={type} and ref={ref};", .con = conn)

                    
   res <- dbExecute(conn, qry)

   return(NULL)
}

