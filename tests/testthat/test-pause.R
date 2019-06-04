context("test-pause")
library(dplyr)

test_that("test pausing writes the evaluation to the temp env", {
  set.seed(42)

  cleardelayedeval()

  df<-data.frame(x=LETTERS,
                 y=runif(26),
                 z=sample(letters,26,replace = TRUE))

  df2<-data.frame(x=LETTERS,
                  w=sample(c(1,2),size = 26,replace = TRUE))

  df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
    df2


  testthat::expect_equal(
    as.character(getdelayedeval()),
    "df %>% mutate(vowel = LETTERS %in% c(\"A\", \"E\", \"I\", \"O\", \"U\", \"Y\")) %>% filter(y > 0.5)")
})

test_that("test pausing works with functions", {
  set.seed(42)

  cleardelayedeval()

  df<-data.frame(x=LETTERS,
                 y=runif(26),
                 z=sample(letters,26,replace = TRUE))

  actual_value <- df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %>%
    filter(y>.75)

  pause_output <- df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
    filter(y>.75)


  testthat::expect_equal(
    as.character(getdelayedeval()),
    "df %>% mutate(vowel = LETTERS %in% c(\"A\", \"E\", \"I\", \"O\", \"U\", \"Y\")) %>% filter(y > 0.5)")
  testthat::expect_equal(actual_value,pause_output)

})
test_that("test pausing works multiple times", {

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

  df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %//%
    filter(y>.75) %//%
    df2

  testthat::expect_equal(
    as.character(getdelayedeval()),
    c("df %>% mutate(vowel = LETTERS %in% c(\"A\", \"E\", \"I\", \"O\", \"U\", \"Y\")) %>% filter(y > 0.5)",
      "df %>% mutate(vowel = LETTERS %in% c(\"A\", \"E\", \"I\", \"O\", \"U\", \"Y\")) %>% filter(y > 0.5) %>% filter(y > 0.75)"))

})
