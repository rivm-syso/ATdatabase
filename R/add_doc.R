#' Add meta document to database
#'
#' Adds a meta-data document to the database. This meta-data document
#' is an R object (e.g. list or data.frame) which is stored in the
#' database. Meta_documents are findable using their type and
#' reference.
#'
#' @param type character string with type, freely definable.
#' @param ref character string with reference, freely definable.
#' @param doc R object to store
#' @param overwrite when TRUE overwrite doc if it exists 
#' @param conn database connection object
#'
#' It is up to the user to organise the meta-data in the database.
#' Meta-data objects are ordinary R objects like character strings,
#' lists or data.frames. These objects can be organised using the type
#' and ref fields. For example, a data.frame with specifications of a
#' certain sensor at a stations, can be stored using 'sensor' as type
#' and the station id as ref (reference).
#'
#' If a meta document allready exists, this function returns an error,
#' unless overwrite = TRUE. 
#'
#' @export
#'

add_doc <- function(type, ref, doc, conn, overwrite = FALSE) {

    if(!is.character(type)) {
        stop("ERROR add_doc: type is not character")
    }

    if(!is.character(ref)) {
        stop("ERROR add_doc: ref is not character")
    }

    if(!is.logical(overwrite)) {
        stop("ERROR add_doc: overwrite is not logical")
    }


    if(doc_exists(type, ref, conn)) {
        if(overwrite) {
            remove_doc(type, ref, conn)
        } else {
            stop("Error add_doc: doc exists and overwrite is FALSE")
        }
    }

    # !! as constraint, combination of type and ref must be unique
    # if doc allready exists, then overwrite
    jsondoc <- doc %>%
        jsonlite::toJSON() %>%
        as.character()


    qry <- glue::glue_sql("INSERT INTO meta (type, ref, doc) values ({type},
                    {ref}, {jsondoc})", .con = conn)
    dbExecute(conn, qry)

}

