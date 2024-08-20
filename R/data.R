#' Mapowanie kodów teryt i nazw jednostek samorządu terytorialnego
#'
#' Zbiór zawiera mapowanie kodów teryt i nazw jednostek samorządu terytorialnego
#' od województw, przez podregiony (tylko nazwy) do powiatów. Dane te zostały
#' wyciągnięte ze zbioru zagregowanych wskaźników z monitoringu absolwentów stąd
#' brak jednego powiatu. Dane te służą do generowania losowych danych o
#' strukturze tabeli pośredniej `P4` na potrzeby testowania pakietu jako
#' pierwszy argument funkcji \link{\code{dummyP4}}.
#'
#' @format ## `agregat`
#' Ramka danych (`data.frame`) zawierająca 379 wierszy i 5 kolumn:
#' \describe{
#'   \item{teryt_woj}{Dwucyfrowy numer teryt województwa}
#'   \item{woj_nazwa}{Nazwa województwa}
#'   \item{nazwa_pow_szk}{Nazwa powiatu}
#'   \item{teryt_pow}{Sześciocyfrowy numer teryt powiatu}
#'   \item{podregion}{Nazwa podregionu NUTS3}
#' }
"agregat"
#' Próbka nazw i adresów szkół z rejestru RSPO
#'
#' Wycinek ogólnodostępnego zbioru Rejestru Szkół i Placówek Oświatowych (RSPO).
#' Zbiór danych zawiera wyslosowane 100 szkół. Dane te służą do generowania
#' losowych danych o strukturze tabeli pośredniej `P4` na potrzeby testowania
#' pakietu jako drugi argument funkcji \link{\code{dummyP4}}.
#'
#' @format ## `rspo`
#' Ramka danych (`data.frame`) zawierająca 100 wierszy i 3 kolumny:
#' \describe{
#'   \item{id_szk}{Numer RSPO szkoły}
#'   \item{nazwa_szk}{Nazwa szkoły z rejestru RSPO}
#'   \item{adres_szk}{Adres szkoły z rejestru RSPO}
#' }
#' @source <https://rspo.gov.pl/>
"rspo"
