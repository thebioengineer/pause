pausedEnv <- new.env(parent = emptyenv())
pausedEnv$delayedeval<-list()

getdelayedeval<-function(){
  delay <- pausedEnv$delayedeval
  cleardelayedeval()
  return(delay)
}

assigndelayedeval<-function(x,envir=parent.frame()){
  tmpx<-x
  if(is_pause(x)){
    x[[1]]<-quote(`%>%`)
  }
  pausedEnv$delayedeval <- c(x,pausedEnv$delayedeval)
  eval(tmpx,envir,envir)
}

cleardelayedeval<-function(){
  pausedEnv$delayedeval <- list()
}

is_function <- function(expression) {
  if (length(expression) > 1 & !is.symbol(expression)) {
    eval(call("class", expression[[1]])) == "function"
  } else{
    FALSE
  }
}

is_pause <- function(expression){
    as.character(expression[[1]]) == "%//%"
}
