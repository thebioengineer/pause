% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pause.R
\name{\%//\%}
\alias{\%//\%}
\title{Pause pipe}
\usage{
lhs \%//\% rhs
}
\arguments{
\item{lhs}{A value or the magrittr placeholder.}

\item{rhs}{A function call using the magrittr semantics.}
}
\description{
Pipe a function - or call expression and pauses the evaluation until it is
"played" by either the `play` function or the `play pipe` (%>>>%). This is useful when an expression has
multiple dataset inputs but you would like to stop the evaluation temporarily so you can manipulate
the second dataset(or the same one more)
}
\details{
The pause pipe works like\code{\link[magrittr]{\%>\%}}, except the
return value is `rhs` itself, and not the result of `lhs` function/expression.
}
\seealso{
\code{\link{\%>>>\%}}
}
