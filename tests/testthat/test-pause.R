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

  left_join_test2 <- df %>%
    mutate(vowel=LETTERS%in%c("A","E","I","O","U","Y")) %>%
    filter(y>.5) %||%
    df2


  testthat::expect_equal(
    as.character(getdelayedeval()),
    "df %>% mutate(vowel = LETTERS %in% c(\"A\", \"E\", \"I\", \"O\", \"U\", \"Y\")) %>% filter(y > 0.5)")
})
