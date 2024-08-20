# MLASZdaneAdm4

Pakiet `MLASZdaneAdm4` zawiera zbiór funkcji służących do obliczania wskaźników dla 4. edycji Monitoringu Losów Absolwentów z użyciem danych administracyjnych (rejestry: CIE, ZUS, POLON i CKE). Przy pomocy tego pakietu można tworzyć zbiory wskaźników na zadanym poziomie agregacji oraz tworzyć symulowane zbiory danych jednostkowych z monitoringu, których można użyć do tworzenia agregatów.

# Instalacja / aktualizacja

Pakiet nie jest dostępny na CRAN, więc trzeba instalować go ze źródeł.

Instalację najprościej przeprowadzić wykorzystując pakiet *devtools*:

```r
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
devtools::install_github('bartplat/MLASZdaneAdm4', build_opts = c("--no-resave-data"))
```

Pakiet `MLASZdaneAdm4` jest zależny od pakietu `MLASZdane`, ale nie ma potrzeby go dodatkowo instalować, ponieważ dzieje się to podczas instalacji pakietu `MLASZdaneAdm4`.

Dokładnie w ten sam sposób można przeprowadzić aktualizację pakietu do najnowszej wersji.

# Generowanie przykładowych danych

Pakiet `MLASZdaneAdm4` zawiera zestaw funkcji tworzących losowe zbiory danych odpowiadające strukturą tabelom pośrednim, na podstawie których liczone są wskaźniki zagregowane. Takie zbiory tworzone są za każdym razem kiedy pakiet jest instalowany i służą do testowania funkcji zawartych w pakiecie (dzieje się to automatycznie podczas instalowania pakietu).

Dane, które tworzone są podczas testowania pakietu mają strukturę odpowiadającą prawdziwym zbiorom danych oraz niektóre kluczowe zależności między zmiennymi, które podlegają testom, są zachowane jednak są też zmienne, które nie mają logicznych powiązań między sobą (np. może się zdarzyć, że szkoła będąca technikum będzie miała w nazwie inny typ szkoły).

Podstawą tworzenia symulowanych zbiorów są dwa inne zbiory danych, które zawarte są w pakiecie:

- `agregat` - jest to zbiór nazw i kodów teryt powiatów wraz z przyporządkowanymi do nich województwami i podregionami NUTS3
- `rspo` - jest to wylosowany wycinek ogólnodostępnego Rejestru Szkół i Placówek oświatowych (RSPO)

Do powyższych zbiorów danych można dostać się za pomocą polecenia `data("[nazwa_zbioru]")` po uprzednim załadowaniu pakietu:

```r
library(MLASZdaneAdm4)
ls()
data("agregat")
data("rspo")
ls()
```

## Logika tworzenia zbiorów

Poniżej opisano kolejność powstawania zbiorów oraz szczegółowe opisy zmiennych, które są tworzone.

1. Pierwszym tworzonym zbiorem jest tabela pośrednia `p4` zawierająca niezmienne w czasie informacje o absolwentach takie jak płeć, typ szkoły, której absolwentami zostali itp. Zbiór ten tworzony jest przy pomocy funkcji `dummyP4(agregat, rspo)`, gdzie argumenty `agregat` i `rspo` to zbiory danych będące częścią pakietu.
2. Po utworzeniu tabeli pośredniej `p4`, następną w kolejności jest tabela pośrednia `p3` tworzona za pomocą funkcji `dummyP3(indyw)`, gdzie argument `indyw` to wynik działania funkcji `dummyP4()`, czyli tabela pośrednia `p4`.
3. Ostatnią tabelą jest zbiór informacji o ścieżkach dalszej edukacji absolwentów, czyli tabela pośrednia `p2`. Zbiór ten tworzony jest za pomocą funkcji `dummyP2(osobomies)`, gdzie argument `osobomies` to tabela pośrednia `p3` wygenerowana w poprzednim punkcie.

```r
library(MLASZdaneAdm4)
data("agregat")
data("rspo")
p4 = dummyP4(agregat, rspo)
p3 = dummyP3(p4)
p2 = dummy_P2(p3)
```

## Szczegółowy opis generowanych zmiennych

### Tabela pośrednia `p4` - niezmienne w czasie informacje o absolwentach

Tabela `p4` tworzona jest na podstawie agregatu, czyli mapowania nazw i kodów teryt powiatów, podregionów NUTS3 oraz województw (zbiór `agregat`) i zawiera następujące kolumny:

- 

### Tabela pośrednia `p3` - informacje o statusie eduakcyjno-zawodowym w poszczególnych miesiącach

### Tabela pośrednia `p2` - informacje o kontynuacji nauki
