
#' Play pipe
#'
#' Pipe a function - or call expression and runs the priorly paused evaluation
#'
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#'
#' @details The pause pipe works like \code{\link[magrittr]{\%>\%}}, except the
#' return value is `rhs` as the second argument of the priorly paused evaluation
#' #'
#' @seealso \code{\link{\%>\%}}, \code{\link{\%||\%}}
#'
#' @rdname play
#' @export
`%>>>%`<-function(lhs,rhs){
  parent <- parent.frame()
  env <- new.env(parent = parent)
  chain_parts <- split_chain(match.call(), env = env)

  fastforward<-as.call(call("fforward",chain_parts$lhs$lhs,chain_parts$lhs$rhs,envir=parent))

  return(eval(fastforward, parent, parent))
}

fforward<-function(lhs,rhs,envir){
  parent <- envir
  parent$vals<-eval(lhs,parent,parent)
  delayedEvals<-getdelayedeval()

  func<-as.list(substitute(rhs))

  delayedexpr<-makecall(func,c(delayedEvals,quote(vals)))
  if(length(func)>1){
    delayedexpr<-makecall(func[[1]],c(delayedEvals,quote(vals),func[[-1]]))
  }
  eval(delayedexpr,parent,parent)
}

makecall<-function(func,args){
  as.call(c(func,args))
}

