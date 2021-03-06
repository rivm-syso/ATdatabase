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
#' @param database conection object
#'
#' It is up to the user to organise the meta-data in the database.
#' Meta-data objects are ordinary R objects like character strings,
#' lists or data.frames. These objects can be organised using the type
#' and ref fields. For example, a data.frame with specifications of a
#' certain sensor at a stations, can be stored using 'sensor' as type
#' and the station id as ref (reference).
#'
#' @export
#'

add_doc <- function(type, ref, doc, conn) {

    if(!is.character(type)) {
        stop("ERROR add_doc: type is not character")
    }

    if(!is.character(ref)) {
        stop("ERROR add_doc: type is not character")
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

