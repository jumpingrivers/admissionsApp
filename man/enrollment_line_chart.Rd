% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_line_chart.R
\name{enrollment_line_chart}
\alias{enrollment_line_chart}
\title{Create tab 1 line chart}
\usage{
enrollment_line_chart(df, group, custom_colors, pct_change, input_year)
}
\arguments{
\item{df}{Tibble containing enrollment by college data}

\item{group}{What to group line chart by}

\item{custom_colors}{Named character vector containing custom colors}

\item{pct_change}{Show pct_change or not?}

\item{input_year}{Currently selected year (only used if pct_change is TRUE)}
}
\description{
Line chart showing enrollment counts
over days before start of classes
}
