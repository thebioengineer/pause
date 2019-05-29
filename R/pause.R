
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
#' @seealso \code{\link{\%>\%}}, \code{\link{\%>>>\%}}
#'
#'
#' @rdname pause
#' @export

`%||%` <- function (lhs, rhs) {
  parent <- parent.frame()
  env <- new.env(parent = parent)
  chain_parts <- split_chain(match.call(), env = env)

  tmp_lhs<-chain_parts[["lhs"]]$lhs
  tmp_rhs<-chain_parts[["lhs"]]$rhs
  assigndelayedeval(chain_parts[["lhs"]]$lhs)

  return(eval(tmp_rhs,parent,parent))
}

