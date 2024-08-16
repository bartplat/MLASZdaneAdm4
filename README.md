# MLASZdaneAdm4

Pakiet `MLASZdaneAdm4` zawiera zbiór funkcji służących do obliczania wskaźników dla 4. edycji Monitoringu Losów Absolwentów z użyciem danych administracyjnych (rejestry: CIE, ZUS, POLON i CKE). Przy pomocy tego pakietu można tworzyć zbiory wskaźników na zadanym poziomie agregacji oraz tworzyć symulowane zbiory danych jednostkowych z monitoringu, których można użyć do tworzenia agregatów.

# Instalacja / aktualizacja

Pakiet nie jest dostępny na CRAN, więc trzeba instalować go ze źródeł.

Instalację najprościej przeprowadzić wykorzystując pakiet *devtools*:

```r
install.packages('devtools') # potrzebne tylko, gdy nie jest jeszcze zainstalowany
devtools::install_github('bartplat/MLASZdaneAdm4', build_opts = c("--no-resave-data"))
```

Pakiet `MLASZdaneAdm4` jest zależny od pakietu `MLASZdane`, ale nie ma potrzeby go dodatkowo instalować, ponieważ dzieje się to podczas instalacji pakietu `MLASZdaneAdm4`.

Dokładnie w ten sam sposób można przeprowadzić aktualizację pakietu do najnowszej wersji.
