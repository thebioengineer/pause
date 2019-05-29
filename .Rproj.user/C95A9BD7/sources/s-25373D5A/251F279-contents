pausedEnv <- new.env(parent = emptyenv())
pausedEnv$delayedeval<-list()

getdelayedeval<-function(){
  delay<-pausedEnv$delayedeval
  cleardelayedeval()
  return(delay)
}

assigndelayedeval<-function(x){
  paused<-length(pausedEnv$delayedeval)
  pausedEnv$delayedeval[[paused+1]]<-x
}

cleardelayedeval<-function(){
  pausedEnv$delayedeval<-list()
}
