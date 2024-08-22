library(MLASZdaneAdm4)
data("agregat.rda")
data("rspo.rda")

p4_dummy = dummyP4(agregat, rspo)

test_that("Funkcja `dummyP4()` zwraca ramkę danych o odpowiedniej klasie i niezerowej liczbie wierszy", {
  expect_true(nrow(p4_dummy) > 0)
  expect_true(any(class(p4_dummy) %in% c("tbl_df", "tbl", "data.frame")))
})

test_that("Funkcja `dummyP4()` zwraca ramkę danych zawierającą wymagane nazwy kolumn", {
  expect_equal(
    sort(names(p4_dummy)),
    sort(c(
      "id_abs", "rok_abs", "rok_ur", "plec", "id_szk", "typ_szk",
      "teryt_woj", "woj_nazwa", "teryt_pow", "nazwa_pow_szk", "podregion",
      "kod_zaw", "nazwa_zaw", "branza",
      "abs_w_cke", "abs_w_sio", "abs_w_polon", "abs_w_zus",
      "adres_szk", "nazwa_szk", "powiat_sr_wynagrodzenie"))
  )
})

p3_dummy = dummyP3(indyw = p4_dummy)

test_that("Funkcja `dummyP3()` zwraca ramkę danych o odpowiedniej klasie i niezerowej liczbie wierszy", {
  expect_true(nrow(p3_dummy) > 0)
  expect_true(any(class(p3_dummy) %in% c("tbl_df", "tbl", "data.frame")))
})

test_that("Funkcja `dummyP3()` zwraca ramkę danych zawierającą wymagane nazwy kolumn", {
  expect_equal(
    sort(names(p3_dummy)),
    sort(c("id_abs", "rok_abs", "id_szk", "typ_szk", "teryt_woj", "teryt_pow", "plec","branza", "nazwa_zaw", "podregion", "okres", "praca", "mlodociany", "bezrobocie", "wynagrodzenie", "wynagrodzenie_uop", "powiat_sr_wynagrodzenie", "status_nieustalony", "nauka", "nauka2", "nauka_szk_abs", "nauka_bs2st", "nauka_lodd", "nauka_spolic", "nauka_studia", "nauka_kkz", "nauka_kuz", "kont_mlodoc_prac")))
})

p2_dummy = dummyP2(osobomies = p3_dummy)

test_that("Funkcja `dummyP2()` zwraca ramkę danych o odpowiedniej klasie i niezerowej liczbie wierszy", {
  expect_true(nrow(p2_dummy) > 0)
  expect_true(any(class(p2_dummy) %in% c("tbl_df", "tbl", "data.frame")))
})

test_that("Funkcja `dummyP2()` zwraca ramkę danych zawierającą wymagane nazwy kolumn", {
  expect_equal(
    sort(names(p2_dummy)),
    sort(c("id_abs", "rok_abs", "id_szk", "typ_szk", "teryt_woj", "teryt_pow", "branza", "podregion", "plec", "branza_kont", "dyscyplina_wiodaca_kont", "dziedzina_kont")))
})

rm(list = c("p4_dummy", "p3_dummy", "p2_dummy"))
