
# dane_szkoly() ----------------------------------------------------------------

dane = p4_dummy %>%
  filter(row_number() %in% c(1:100)) %>%
  mutate(
    across(id_szk, ~c(rep(1234, 50), rep(5678, 50))),
    across(nazwa_szk, ~c(rep("Szkoła numer 1", 50), rep("Szkoła numer 2", 50))),
    across(adres_szk, ~c(rep("ul. Pogodna 21, 45-123 Miasto Pierwsze", 50), rep("ul. Krakowska 37, 90-678 Miasto Drugie", 50))))

test_that("Funkcja `dane_szkoly()` dla nieunikalnych wartości zmiennych z nazwą i adresem zwraca puste wartości tekstowe oraz ostrzeżenie", {
  expect_warning(dane_szkoly(dane), "`nazwa_szk` i `adres_szk` zawierają więcej niż 1 unikalną wartość")
  suppressWarnings(expect_equal(dane_szkoly(dane), list(nazwa = "", adres = "")))
})

dane2 = dane %>%
  filter(row_number() %in% c(1:20))

test_that("Funkcja `dane_szkoly()` dla unikalnych wartości zmiennych z nazwą i adresem zwraca adres i nazwę", {
  expect_equal(dane_szkoly(dane2), list(nazwa = "Szkoła numer 1", adres = "ul. Pogodna 21, 45-123 Miasto Pierwsze"))
})

rm(dane2)

# l_abs() ----------------------------------------------------------------------

test_that("Funkcja `l_abs()` zwraca poprawną liczbę unikalnych absolwentów", {
  expect_equal(l_abs(dane), 100)
})

dane3 = rbind(dane, dane[1,], dane[1,])

test_that("Funkcja `l_abs()` zwraca poprawną liczbę unikalnych absolwentów dla zbioru z potrójnym absolwentem", {
  expect_warning(l_abs(dane3), "`id_abs` i `rok_abs` w liczbie:")
  suppressWarnings(expect_equal(l_abs(dane3), 100))
})

# dane3[c(101),]$rok_abs = 2022
# dane3[c(102),]$rok_abs = 2023
#
# test_that("Funkcja `l_abs()` zwraca poprawną liczbę unikalnych absolwentów dla zbioru z potrójnym absolwentem, gdzie dwie jego odsłony mają inną wartość `rok_abs`", {
#   expect_equal(l_abs(dane3), 102)
# })

# status_S3_mies() -------------------------------------------------------------

statusy = status_S3_mies(p3_dummy, 2023, 12, 2023, 12)
nazwy = c("n", "tylko_ucz", "ucz_prac", "tylko_prac", "bezrob", "neet")

test_that("Funkcja `status_S3_mies()` zwraca niepustą listę o wymaganej strukturze", {
  expect_type(statusy, "list")
  expect_gt(statusy$n, 0)
  expect_named(statusy, nazwy)
})

test_that("Funkcja `status_S3_mies()` zwraca listę, której elementy (z wyłączeniem `n`) sumują się do 1", {
  expect_equal(sum(sapply(statusy[-1], function(x) x[[1]])), 1)
})

# Z8_formy_prac_mies() ---------------------------------------------------------

formy_ucz = Z8_formy_prac_mies(p3_dummy, 2023, 12, TRUE)
formy_nie_ucz = Z8_formy_prac_mies(p3_dummy, 2023, 12, FALSE)

nazwy_ucz = c("n", "ucz_uop", "ucz_samoz", "ucz_inna", "ucz_wiecej")
nazwy_nie_ucz = c("n", "nieucz_uop", "nieucz_samoz", "nieucz_inna", "nieucz_wiecej")

test_that("Funkcja `Z8_formy_prac_mies()` dla uczących się zwraca niepustą listę o wymaganej strukturze", {
  expect_type(formy_ucz, "list")
  expect_gt(formy_ucz$n, 0)
  expect_named(formy_ucz, nazwy_ucz)
})

test_that("Funkcja `Z8_formy_prac_mies()` dla NIEuczących się zwraca niepustą listę o wymaganej strukturze", {
  expect_type(formy_nie_ucz, "list")
  expect_gt(formy_nie_ucz$n, 0)
  expect_named(formy_nie_ucz, nazwy_nie_ucz)
})

test_that("Funkcja `Z8_formy_prac_mies()` dla uczących się zwraca listę, której elementy (z wyłączeniem `n`) sumują się do 1", {
  expect_equal(sum(sapply(formy_ucz[-1], function(x) x[[1]])), 1)
})

test_that("Funkcja `Z8_formy_prac_mies()` dla NIEuczących się zwraca listę, której elementy (z wyłączeniem `n`) sumują się do 1", {
  expect_equal(sum(sapply(formy_nie_ucz[-1], function(x) x[[1]])), 1)
})

# W3_sr_doch_uop() -------------------------------------------------------------

doch_ucz = W3_sr_doch_uop(p3_dummy, 2023, 9, 2023, 12, TRUE)
doch_nie_ucz = W3_sr_doch_uop(p3_dummy, 2023, 9, 2023, 12, FALSE)

nazwy = c("n", "sred", "q5", "q25", "med", "q75", "q95")

test_that("Funkcja `W3_sr_doch_uop()` dla uczących się zwraca niepustą listę o wymaganej strukturze", {
  expect_type(doch_ucz, "list")
  expect_gt(doch_ucz$n, 0)
  expect_named(doch_ucz, nazwy)
})

test_that("Funkcja `W3_sr_doch_uop()` dla NIEuczących się zwraca niepustą listę o wymaganej strukturze", {
  expect_type(doch_nie_ucz, "list")
  expect_gt(doch_nie_ucz$n, 0)
  expect_named(doch_nie_ucz, nazwy)
})
