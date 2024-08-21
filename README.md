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

- `id_abs` unikalny dla każdego absolwenta kod służący identyfikacji
- `rok_abs` rok ukończenia szkoły
- `rok_ur` rok urodzenia absolwenta. Wartości od 2001 do 2003 z ok. 50% szansy na wylosowanie wartosći 2002
- `plec` płeć absolwenta losowana z prawdopodobieństwem 52% wylosowania kobiety
- `id_szk` numer RSPO szkoły
- `typ_szk` typ szkoły, którą ukończył absolwent. W zbiorze zawsze są 3 typy szkoły: Technikum, Branżowa szkoła I stopnia, Liceum ogólnokształcące, a dodatkowo dolosowywane są 2 typy z pozostałych i z tego zestawu typów szkoły przypisywane są one losowo absolwentom.
- `teryt_woj` dwucyfrowy numer teryt województwa, w którym znajduje się szkoła. Z obiektu `agregat` losowane są 3 województwa bez zwracania.
- `woj_nazwa` nazwa województwa, w którym znajduje się szkoła
- `teryt_pow` sześciocyfrowy numer teryt powiatu, w którym znajduje się szkoła. Z obiektu`agregat` losowane jest 25 powiatów, które wchodzą w skład danego województwa ze zwracaniem.
- `nazwa_pow_szk` nawzwa powiatu, w którym znajduje się szkoła
- `podregion` podregion NUTS3, w którym znajduje się szkoła
- `nazwa_zaw` nazwa zawodu, w którym kształcił się absolwent. Dla szkół niekształcących zawodowo - brak danych. Zawody losowane z top 5 najliczniejszych zawodów według danych z monitoringu w danym typie szkoły.
- `kod_zaw` kod zawodu
- `branza` branża, do której należy zawód
- `abs_w_cke` zmienna binarna mówiąca o tym czy informacja o danym absolwencie jest z rejsestru CKE. Prawdopodobieństwo wylosowania wartości TRUE to 78%.
- `abs_w_sio` zmienna binarna mówiąca o tym czy informacja o danym absolwencie jest z rejsestru SIO. Prawdopodobieństwo wylosowania wartości TRUE to 18%.
- `abs_w_polon` zmienna binarna mówiąca o tym czy informacja o danym absolwencie jest z rejsestru POLON. Zmienna przyjmuje wartości TRUE/FALSE dla absolwentów, którzy ukończyli szkoły, po których można przystąpić do egzaminu maturalnego, a dla pozostałych przyjmuje brak danych. Prawdopodobieństwo wylosowania wartości TRUE to 50%.
- `abs_w_zus` zmienna binarna mówiąca o tym czy informacja o danym absolwencie jest z rejsestru ZUS. Prawdopodobieństwo wylosowania wartości TRUE to 18%.
- `adres_szk` adres szkoły z RSPO, którą ukończył absolwent
- `nazwa_szk` nazwa szkoły z RSPO, którą ukończył absolwent

### Tabela pośrednia `p3` - informacje o statusie eduakcyjno-zawodowym w poszczególnych miesiącach

- `id_abs` unikalny dla każdego absolwenta kod służący identyfikacji z tabeli `p4`
- `rok_abs` rok ukończenia szkoły z tabeli `p4`
- `id_szk` numer RSPO z tabeli `p4`
- `typ_szk` typ szkoły z tabeli `p4`
- `teryt_woj` numer teryt województwa z tabeli `p4`
- `teryt_pow` numer teryt powiatu z tabeli `p4`
- `plec` płeć absolwenta z tabeli `p4`
- `branza` branża, do której należy wyuczony zawódz tabeli `p4`
- `nazwa_zaw` nazwa zawodu z tabeli `p4`
- `podregion` podregion NUTS3, w którym znajduje się szkoła z tabeli `p4`
- `okres` wartość liczbowa będąca datą. Jest to liczba miesięcy, która upłynęła od roku 0, dzięki temu pojedynczą wartość liczbową można przekonwertować na miesiąc i rok.
- `praca` zmienna liczbowa o wartościach od 0 do 7, gdzie wartości od 1 do 7 określają formę zatrudnienia w danym miesiącu
- `mlodociany` zmienna binarna mówiąca o tym czy absolwent technikum, branżowej szkoły I stopnia lub branżowej szkoły II stopnia, który równocześnie pracuje jest w danym miesiącu zatrudniony jako pracownik młodociany. Prawdopodobieństwo wylosowania wartości 1 (fakt zatrudnienia jako młodociany) to 90%.
- `bezrobocie` zmienna binarna mówiąca o tym czy absolwent, który nie pracuje (wartość zmiennej `praca` równa 0) jest zarejestrowany jako bezrobotny w określonym miesiącu. Prawdopodobieństwo wylosowania wartości 1 to 15%.
- `wynagrodzenie` wynagrodzenie absolwentów w miesiącu, w którym byli zatrudnieni, w złotówkach z przedziału od 450 złotych do 5000 złotych
- `wynagrodzenie_uop` wynagrodzenie absolwentów w miesiącu, w którym byli zatrudnieni na umowę o pracę, w złotówkach z przedziału od 450 złotych do 5000 złotych
- `powiat_sr_wynagrodzenie` średnie wynagrodzenie w powiecie według GUS
- `status_nieustalony` zmienna binarna informująca, że absolwent posiadający brak danych w zmiennej `praca` posiada brak jakichkolwiek informacji o sytuacji w danym miesiącu w zebranych danych
- `nauka` zmienna binarna informująca czy absolwent w danym miesiącu kontynuował naukę
- `nauka2` zmienna binarna informująca czy absolwent w danym miesiącu kontynuował naukę za wyjątkiem kontynuacji na KUZ i KKZ
- `nauka_szk_abs` zmienna binarna informująca czy absolwent w danym miesiącu uczył się jeszcze w szkole, której jest absolwentem (np. w okresie wakacyjnym)
- `nauka_bs2st` zmienna binarna informująca czy w danym miesiącu absolwent kontynuował naukę w branżowej szkole II stopnia
- `nauka_lodd` zmienna binarna informująca czy w danym miesiącu absolwent kontynuował naukę w LO dla dorosłych
- `nauka_spolic` zmienna binarna informująca czy w danym miesiącu absolwent kontynuował naukę w szkole policealnej
- `nauka_studia` zmienna binarna informująca czy w danym miesiącu absolwent kontynuował naukę na uczelni wyższej
- `nauka_kkz` zmienna binarna informująca czy w danym miesiącu absolwent kontynuował naukę na KKZ
- `nauka_kuz` zmienna binarna informująca czy w danym miesiącu absolwent kontynuował naukę na KUZ
- `kont_mlodoc_prac` zmienna informująca czy w danym miesiącu absolwent, który był wcześniej młodocianym pracownikiem, pracował u tego samego pracodawcy (u którego był młodocianym pracownikiem) również po ukończeniu szkoły

### Tabela pośrednia `p2` - informacje o kontynuacji nauki

- `id_abs` unikalny dla każdego absolwenta kod służący identyfikacji z tabeli `p4`
- `rok_abs` rok ukończenia szkoły z tabeli `p4`
- `id_szk` numer RSPO z tabeli `p4`
- `typ_szk` typ szkoły z tabeli `p4`
- `teryt_woj` numer teryt województwa z tabeli `p4`
- `teryt_pow` numer teryt powiatu z tabeli `p4`
- `branza` branża, do której należy wyuczony zawódz tabeli `p4`
- `podregion` podregion NUTS3, w którym znajduje się szkoła z tabeli `p4`
- `plec` płeć absolwenta z tabeli `p4`
- `branza_kont` branża, do której przypisany został zawód, którego uczył się absolwent kontynuując kształcenie
- `dyscyplina_wiodaca_kont` nazwa (wiodącej) dyscypliny nauki/sztuki, do której przypisany został kierunek studiów podjętych przez absolwenta
- `dziedzina_kont` nazwa (wiodącej) dziedziny nauki/sztuki, do której przypisany został kierunek studiów podjętych przez absolwenta
