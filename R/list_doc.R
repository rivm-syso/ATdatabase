#' Lists all references for a meta-document type
#'
#' This function lists the references (ref) of all meta-data documents
#' in the database for a given type.
#'
#' @param type character string with type
#' @param conn database connection object
#'
#' @return character vector of references (ref) for the given type, or
#'   NA if no documents of that type exist
#'
#' A meta-data document is an R object which is stored in the database.
#' Each object has a type and reference (ref) so they are findable.
#' This function returns all references belonging to a certain type.
#'
#' @export
#'


list_doc <- function(type, conn) {

    if(!is.character(type)) {
        stop("ERROR list_doc: type is not character")
    }

    qry <- glue::glue_sql("SELECT ref FROM meta WHERE type={type};",
                          .con = conn)

    res <- pool::dbGetQuery(conn, qry)
    if(length(res$ref) == 0) {
        ref <- NA
    } else {
        ref <- res$ref
    }
    return(ref)
}
