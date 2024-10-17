
# ind_status_S3() --------------------------------------------------------------

dane = p3_dummy %>%
  mutate(status = ind_status_S3(.),
         status_label = ind_status_S3(., etykiety = TRUE))

test_that("Funkcja `ind_status_S3()` nie zwraca braków danych", {
  expect_false(any(is.na(dane$status)))
})

test_that("Funkcja `ind_status_S3()` zwraca poprawne nazwy statusów", {
  label_short = c("tylko_ucz", "ucz_prac", "tylko_prac", "bezrob", "neet")
  label_long = c("Tylko nauka", "Nauka i praca", "Tylko praca", "Bezrobocie", "Brak danych o aktywności")

  expect_in(unique(dane$status), label_short)
  expect_in(unique(dane$status_label), label_long)
})

test_that("Funkcja `ind_status_S3()` zwraca rozkład statusów o niezerowych liczebnościach", {
  rozklad = dane %>%
    count(status)

  expect_gt(sum(rozklad$n), 10)
})

# ind_Z8_formy_prac() ----------------------------------------------------------

dane = p3_dummy %>%
  mutate(formy = ind_Z8_formy_prac(.))

test_that("Funkcja `ind_Z8_formy_prac()` zwraca poprawne nazwy form wykonywania pracy", {
  zmienna_formy = c("uop", "samoz", "inna", "wiecej", NA_character_)

  expect_in(unique(dane$formy), zmienna_formy)
})

test_that("Funkcja `ind_Z8_formy_prac()` zwraca rozkład form wykonywania pracy o niezerowych liczebnościach", {
  rozklad = dane %>%
    count(formy)

  expect_gt(sum(rozklad$n), 10)
})
