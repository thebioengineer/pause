
#' Play pipe
#'
#' Pipe a function - or call expression and runs the priorly paused evaluation
#'
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics. the output order of the delayed expression can be identified using the .x# notation.
#'
#' @details The pause pipe works like \code{\link[magrittr]{\%>\%}}, except the
#' return value is `rhs` as the second argument of the priorly paused evaluation
#' #'
#' @seealso \code{\link{\%//\%}}
#'
#' @rdname play
#' @export
`%>>>%` <- function(lhs, rhs) {
  parent <- parent.frame()
  env <- new.env(parent = parent)
  chain_parts <- match.call()
  fastforward <-as.call(call("fforward", chain_parts$lhs, chain_parts$rhs, envir = parent))
  return(eval(fastforward, parent, parent))
}

fforward <- function(lhs, rhs, envir) {
  parent <- envir
  parent$vals <- eval(lhs, parent, parent)
  delayedEvals <- c(getdelayedeval(), quote(vals))
  names(delayedEvals) <- paste0(".x", seq(1, length(delayedEvals)))

  parsed_func <- parse_function(substitute(rhs), delayedEvals)
  delayedexpr <- as.call(c(parsed_func[["function"]], parsed_func[["args"]]))
  eval(delayedexpr, parent, parent)
}

parse_function <- function(expression, evals) {
  func <- ifelse(is.symbol(expression), expression, expression[[1]])
  if (length(expression) > 1) {
    arglist <- as.list(expression)[-1]
    if (any(names(evals) %in% arglist)) {
      arglist <- lapply(arglist, function(x) {
        if (as.character(x) %in% names(evals)) {
          x <- evals[[as.character(x)]]
        }
        x
      })
    } else{
      arglist <- c(unname(evals), arglist)
    }
  } else{
    arglist <- unname(evals)
  }

  return(list("function" = func, "args" = arglist))
}
