% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/remove_doc.R
\name{remove_doc}
\alias{remove_doc}
\title{Removes a meta document}
\usage{
remove_doc(type, ref, conn)
}
\arguments{
\item{type}{character string with type}

\item{ref}{character string with reference}

\item{conn}{database connection object}
}
\value{
nothing

This function removes a meta document from the meta table based on
the given type and ref. This function does not return anything. It
doesn't matter if the document to remove does not exists.
}
\description{
Removes a meta document from the meta table based on the type and
ref
}
