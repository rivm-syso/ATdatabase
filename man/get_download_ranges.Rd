% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_download_ranges.R
\name{get_download_ranges}
\alias{get_download_ranges}
\title{Determine wich time ranges are missing}
\usage{
get_download_ranges(station, Tstart, Tend, conn)
}
\arguments{
\item{station}{station identifier}

\item{Tstart}{start of requested time range}

\item{Tend}{end of requested time range}

\item{conn}{database connection object}
}
\value{
a matrix with time ranges (in seconds) which can be used to
download the misisng data
}
\description{
This function determines which time ranges are missng in the
database. These time ranges must be downloaded using a
downloadhandler
}
