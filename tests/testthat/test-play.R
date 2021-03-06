context("test-play")
library(dplyr)

test_that("Pausing and play works with new", {
  set.seed(42)

  df<-data.frame(x=LETTERS,
                 y=runif(26),
                 z=sample(letters,26,replace = TRUE))

  tmpvar2<-df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    mutate(z=as.numeric(as.factor(z))) %>%
    pull(z)

  cor_result <- df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    pull(y) %>%
    cor(tmpvar2)

  cor_test2 <- df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    pull(y) %//%
      df %>%
      filter(x%in%c("A","E","I","O","U","Y")) %>%
      mutate(z=as.numeric(as.factor(z))) %>%
      pull(z) %>>>%
    cor()

  cor_test3 <- df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    pull(y) %//%
      df %>%
      filter(x%in%c("A","E","I","O","U","Y")) %>%
      mutate(z=as.numeric(as.factor(z))) %>%
    pull(z) %>>>%
    cor

  cor_test4 <- df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    pull(y) %//%
    df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    mutate(z=as.numeric(as.factor(z))) %>%
    pull(z) %>>>%
    cor(.x1,.x2)

  cor_test5 <- df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    pull(y) %//%
    df %>%
    filter(x%in%c("A","E","I","O","U","Y")) %>%
    mutate(z=as.numeric(as.factor(z))) %>%
    pull(z) %>>>%
    cor(.x2,.x1)

  testthat::expect_equivalent(cor_test2,cor_result)
  testthat::expect_equivalent(cor_test3,cor_result)
  testthat::expect_equivalent(cor_test4,cor_result)
  testthat::expect_equivalent(cor_test5,cor_result)


})



test_that("Play works with more pipes", {
  set.seed(42)

  df<-data.frame(x=LETTERS,
                 y=runif(26),
                 z=sample(letters,26,replace = TRUE))

  df2<-data.frame(x=LETTERS,
                  w=sample(c(1,2),size = 26,replace = TRUE))

  tmpvar1<-df2 %>%
    filter(w==1)

  left_join_test <- df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %>%
    left_join(tmpvar1,by="x") %>%
    filter(!is.na(w))

  left_join_test2 <- df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
      df2 %>%
      filter(w==1) %>>>%
    left_join(by="x") %>%
    filter(!is.na(w))

  testthat::expect_equivalent(left_join_test2,left_join_test)
})

test_that("Play works with multiple pauses pausing works multiple times", {

  set.seed(42)
  cleardelayedeval()

  df<-data.frame(x=LETTERS,
                 y=runif(26),
                 z=sample(letters,26,replace = TRUE),
                 stringsAsFactors = FALSE)

  df2<-data.frame(x=LETTERS[1:10],
                  y=runif(20),
                  z=sample(letters,10,replace = TRUE),
                  stringsAsFactors = FALSE)

  temp1 <- df %>%
    mutate(vowel = LETTERS %in% c("A", "E", "I", "O", "U", "Y")) %>%
    filter(y > .5)
  temp2 <- temp1 %>%
    filter(y > .75)
  temp3 <- df2 %>%
    filter(y>.5)
  testOutput<-bind_rows(temp1,temp2,temp3)

  output<-df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
    filter(y>.75) %//%
    df2 %>%
    filter(y>.5) %>>>%
    bind_rows()

  output1<-df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
    filter(y>.75) %//%
    df2 %>%
    filter(y>.5) %>>>%
    bind_rows(.x1,.x2,.x3)

  different_output<-df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
    filter(y>.75) %//%
    df2 %>%
    filter(y>.5) %>>>%
    bind_rows(.x1,.x3,.x2)

  testthat::expect_equal(output,testOutput)
  testthat::expect_equal(output1,testOutput)
  testthat::expect_true(all(output==testOutput,na.rm = TRUE))
  testthat::expect_false(all(different_output==testOutput,na.rm = TRUE))
})
