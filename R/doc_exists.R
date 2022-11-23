#' Checks if a meta-document exists
#'
#' This functions checks if a meta document allready exists. A
#' document must have an unique type and ref combination and
#' duplicated combinations are not allowed
#'
#' @param type character string with type 
#' @param ref character string with reference 
#' @param conn database connection object
#'
#' @return TRUE if document exists, FALSE otherwise
#'
#' A meta document is identified by a unique type and ref combination.
#' This function can be used to check if a document with given type
#' and ref already exists in the meta table. 
#'
#' @export
#'

doc_exists <- function(type, ref, conn) {


    if(!is.character(type)) {
        stop("ERROR add_doc: type is not character")
    }

    if(!is.character(ref)) {
        stop("ERROR add_doc: type is not character")
    }

    qry <- glue::glue_sql("SELECT type, ref FROM meta WHERE 
                    type={type} and ref={ref};", .con = conn)

                    
   res <- dbGetQuery(conn, qry)
   if(nrow(res) == 0) {
       doc <- FALSE
   } else {
       doc <- TRUE
   }
}

