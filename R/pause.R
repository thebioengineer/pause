#' Pause pipe
#'
#' Pipe a function - or call expression and pauses the evaluation until it is
#' "played" by either the `play` function or the `play pipe` (%>>>%). This is useful when an expression has
#' multiple dataset inputs but you would like to stop the evaluation temporarily so you can manipulate
#' the second dataset(or the same one more)
#'
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#'
#' @details The pause pipe works like\code{\link[magrittr]{\%>\%}}, except the
#' return value is `rhs` itself, and not the result of `lhs` function/expression.
#'
#' @seealso \code{\link{\%>>>\%}}
#'
#' @rdname pause
#' @export

`%//%` <- function (lhs, rhs) {
  parent <- parent.frame()
  env <- new.env(parent = parent)
  chain_parts <- match.call()

  tmp_lhs <- chain_parts$lhs
  tmp_rhs <- chain_parts$rhs

  assigndelayedeval(tmp_lhs,parent)

  if (is_function(tmp_rhs)) {
    tmp_rhs <- as.call(c(quote(`%>%`), tmp_lhs, tmp_rhs))
  }
  return(eval(tmp_rhs, parent, parent))
  # return(chain_parts)
}

