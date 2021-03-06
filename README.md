# pause

The goal of pause is to fascilitate the processing of your data while maintaining the 'tidy' pipeing structure. By using the "pause" pipe, `%//%`, you stop the evaluation of a pipe and can start performing the next pipe. This keeps you from having to either create a temporary variable, or pipe-within-a-pipe. You then "fastforward" into a function that would have been taking the temporary variable with `%>>>%`. This keeps everying inline with your pipe.

[![Travis build status](https://travis-ci.org/thebioengineer/pause.svg?branch=master)](https://travis-ci.org/thebioengineer/pause)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/thebioengineer/pause?branch=master&svg=true)](https://ci.appveyor.com/project/thebioengineer/pause)
[![Coverage status](https://codecov.io/gh/thebioengineer/pause/branch/master/graph/badge.svg)](https://codecov.io/github/thebioengineer/pause?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

## Installation

You can install the developmental version of pause from [github](https://github.com/thebioengineer/pause) with remotes:

``` r
remotes::install_github("thebioengineer/pause")
```

## Example

So this example is for showing a pause pipe (`%//%`) and then fastforward pipe(`%>>>%`) that shows the use cases that I ran across most often. 

``` r
set.seed(42)

df<-data.frame(x=LETTERS,y=runif(26),z=sample(letters,26,replace = TRUE))
df2<-data.frame(x=LETTERS,w=sample(c(1,2),size = 26,replace = TRUE))

df %>%
  mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
  filter(y>.5) %//%
df2 %>%
  filter(w==1) %>>>%
  left_join(by="x") %>%
  filter(!is.na(w))

```
This is exactly the same result if you were to do the following in standard pipe operations.

``` r

tempdf2<-df2 %>% 
  filter(w==1)

df %>%
  mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
  filter(y>.5) %>% 
  left_join(tempdf2,by="x") %>%
  filter(!is.na(w))
  
```

This also allows you to pipe together multiple pauses, and each is considered a separate pause. The only time this is not true is when a pause starts with a function, in which case it is assumed the output of the prior pause is fed into this function as if it were a standard pipe.

``` r

# this pause:

df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
    filter(y>.75) %//%
    df2 %>%
    filter(y>.5) %>>>%
    bind_rows(.x1,.x2,.x3)
    
# is equivalent to:


temp1 <- df %>%
    mutate(vowel = LETTERS %in% c("A", "E", "I", "O", "U", "Y")) %>%
    filter(y > .5)
temp2 <- temp1 %>%
    filter(y > .75)
temp3 <- df2 %>%
    filter(y>.5)
    
testOutput<-bind_rows(temp1,temp2,temp3)
```

Please note that the 'pause' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
