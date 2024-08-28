library(MLASZdaneAdm4)
library(dplyr)
load("../../data/agregat.rda")
load("../../data/rspo.rda")

p4_dummy = dummyP4(agregat, rspo)

# dane_szkoly() -----------------------------------------------------------

dane = p4_dummy %>%
  filter(row_number() %in% c(1:100)) %>%
  mutate(
    across(id_szk, ~c(rep(1234, 50), rep(5678, 50))),
    across(nazwa_szk, ~c(rep("Szkoła numer 1", 50), rep("Szkoła numer 2", 50))),
    across(adres_szk, ~c(rep("ul. Pogodna 21, 45-123 Miasto Pierwsze", 50), rep("ul. Krakowska 37, 90-678 Miasto Drugie", 50))))

test_that("Funkcja `dane_szkoly()` dla nieunikalnych wartości zmiennych z nazwą i adresem zwraca puste wartości tekstowe oraz ostrzeżenie", {
  expect_warning(dane_szkoly(dane), "`nazwa_szk` i `adres_szk` zawierają więcej niż 1 unikalną wartość")
  expect_equal(dane_szkoly(dane), list(nazwa = "", adres = ""))
})

dane2 = dane %>%
  filter(row_number() %in% c(1:20))

test_that("Funkcja `dane_szkoly()` dla unikalnych wartości zmiennych z nazwą i adresem zwraca adres i nazwę", {
  expect_equal(dane_szkoly(dane2), list(nazwa = "Szkoła numer 1", adres = "ul. Pogodna 21, 45-123 Miasto Pierwsze"))
})

rm(dane2)

# l_abs() -----------------------------------------------------------------

test_that("Funkcja `l_abs()` zwraca poprawną liczbę unikalnych absolwentów", {
  expect_equal(l_abs(dane), 100)
})

dane3 = rbind(dane, dane[1,], dane[1,])

test_that("Funkcja `l_abs()` zwraca poprawną liczbę unikalnych absolwentów dla zbioru z potrójnym absolwentem", {
  expect_equal(l_abs(dane3), 100)
})

dane3[c(101),]$rok_abs = 2022
dane3[c(102),]$rok_abs = 2023

test_that("Funkcja `l_abs()` zwraca poprawną liczbę unikalnych absolwentów dla zbioru z potrójnym absolwentem, gdzie dwie jego odsłony mają inną wartość `rok_abs`", {
  expect_equal(l_abs(dane3), 102)
})
