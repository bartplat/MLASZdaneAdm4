#' @title Tworzenie dummy data na podstawie tabeli pośredniej \code{P4}
#' @description Funkcja tworzy dummy data na podstawie tabeli pośredniej
#' \code{P4}, które potem będą używane do testowania pakietu
#' \code{MLASZdaneAdm4}.
#' @details Zbiór tworzony przez tę funkcję ma odzwierciedlać tabelę pośrednią
#' \code{P4} w stopniu, jaki jest wymagany do przetestowania funkcji liczących
#' wskaźniki zagregowane. Ze względu na to, że dane z monitoringu nie mogą być w
#' formie indywidualnej dostępne publicznie, a na potrzeby testowania pakietu
#' potrzebny jest jakiś zbiór odzwierciedlający strukturę prawdziwego zbioru, na
#' potrzeby testowania pakietu tworzony będzie zbiór dummy data. Zbiór ten
#' będzie zawierał zmienne podobne do tych w zbiorze z monitoringu, ale nie
#' zawsze będzie zachowana logiczna zależność między zmiennymi. Na przykład,
#' nazwy szkoły mogą nie odpowiadać typowi szkoły. Jest to celowe uproszczenie,
#' ponieważ ten aspekt nie będzie podlegał testowaniu, ale wymienione zmienne są
#' wymagane na potrzeby testów. Takich uproszczeń w zbiorze jest więcej, ale
#' zostały zastosowane tylko tam, gdzie ma to sens.
#' Uproszczenia te wynikają z potrzeby generowania zbioru za każdym razem kiedy
#' testy są uruchamiane. Dzięki temu, że przy każdym testowaniu używany jest
#' nieco inny zbiór ograniczany jest wpływ zawartości zbioru na testy. Przy raz
#' wygenerowanym zbiorze jakiś specyficzny układ wartości zmiennych mógłby mieć
#' wpływ na test, a przy generowaniu wartości zmiennych oddzielnie dla każdego
#' testu wpływ ten jest ograniczany.
#' @param agregat agregat, na podstawie, którego tworzony będzie zbiór (w
#' rzeczywistości jest to mapowanie numerów teryt i nazw JST na podstawie tabeli
#' pośredniej \code{P4})
#' @param rspo zbiór RSPO zawierający minimum 100 wierszy opisujących id RSPO,
#' nazwę i adres szkoły
#' @param seed wartość ziarna generatora - domyślna wartość to \code{NULL}
#' (argument opcjonalny na wypadek potrzeby powtarzalności obliczeń)
#' @return data.frame
#' @importFrom tibble is_tibble
#' @importFrom dplyr %>% filter rowwise mutate ungroup slice_sample row_number
#' case_when left_join join_by select n distinct
#' @importFrom tidyr uncount
#' @export
dummyP4 = function(agregat, rspo, seed = NULL) {
  stopifnot(is.character(seed) | is.numeric(seed) | is.null(seed),
            is_tibble(agregat) | is.data.frame(agregat),
            is_tibble(rspo) | is.data.frame(rspo),
            nrow(rspo) > 99)

  # ustawianie ziarna generatora
  if (!is.null(seed)) {
    set.seed(seed)
  }

  zawody = data.frame(
    typ_szk = c("Branżowa szkoła I stopnia", "Branżowa szkoła I stopnia", "Branżowa szkoła I stopnia",
                "Branżowa szkoła I stopnia", "Branżowa szkoła I stopnia", "Branżowa szkoła II stopnia",
                "Branżowa szkoła II stopnia", "Branżowa szkoła II stopnia", "Branżowa szkoła II stopnia",
                "Branżowa szkoła II stopnia", "Szkoła policealna", "Szkoła policealna",
                "Szkoła policealna", "Szkoła policealna", "Szkoła policealna",
                "Technikum", "Technikum", "Technikum", "Technikum", "Technikum"),
    kod_zaw = c(723103, 512001, 514101, 522301, 712905, 311513, 343404, 314403, 514105, 311504,
                532102, 325509, 514207, 334306, 343203, 351203, 333107, 343404, 331403, 422402),
    nazwa_zaw = c("Mechanik pojazdów samochodowych", "Kucharz", "Fryzjer", "Sprzedawca",
                  "Monter zabudowy i robót wykończeniowych w budownictwie",
                  "Technik pojazdów samochodowych", "Technik żywienia i usług gastronomicznych",
                  "Technik technologii żywności", "Technik usług fryzjerskich", "Technik mechanik",
                  "Opiekun medyczny", "Technik bezpieczeństwa i higieny pracy",
                  "Technik usług kosmetycznych", "Technik administracji", "Florysta",
                  "Technik informatyk", "Technik logistyk", "Technik żywienia i usług gastronomicznych",
                  "Technik ekonomista", "Technik hotelarstwa"),
    branza = c("motoryzacyjna", "hotelarsko-gastronomiczno-turystyczna", "fryzjersko-kosmetyczna",
               "handlowa", "budowlana", "motoryzacyjna", "hotelarsko-gastronomiczno-turystyczna",
               "spożywcza", "fryzjersko-kosmetyczna", "mechaniczna", "opieki zdrowotnej",
               "ochrony i bezpieczeństwa osób i mienia", "fryzjersko-kosmetyczna",
               "ekonomiczno-administracyjna", "ogrodnicza", "teleinformatyczna",
               "spedycyjno-logistyczna", "hotelarsko-gastronomiczno-turystyczna",
               "ekonomiczno-administracyjna", "hotelarsko-gastronomiczno-turystyczna"))

  # zawsze 3 typy szkół (tech, bs1 i LO), a do tego losowe dwa typy z pozostałych
  obj_typ_szk = c(c("Technikum", "Branżowa szkoła I stopnia", "Liceum ogólnokształcące"),
                  sample(c("Szkoła policealna",
                           "Liceum dla dorosłych",
                           "Branżowa szkoła II stopnia",
                           "Szkoła specjalna przysposabiająca do pracy"),
                         size = 2))

  agregat = agregat %>%
    rowwise() %>%
    mutate(powiat_sr_wynagrodzenie = runif(n = 1, min = 4200, max = 11300)) %>%
    ungroup() %>%
    filter(teryt_woj %in% c(sample(unique(teryt_woj), size = 3, replace = FALSE))) %>%
    filter(teryt_pow %in% c(sample(unique(teryt_pow), size = 25, replace = TRUE))) %>%
    rowwise() %>%
    mutate(typ_szk = sample(obj_typ_szk, replace = TRUE, size = 1)) %>%
    ungroup()

  rspo_bind = rspo %>%
    slice_sample(n = nrow(agregat))

  agregat = cbind(agregat, rspo_bind) %>%
    mutate(n = sample(c(1:9, 10:100), size = n(), replace = TRUE, prob = c(rep(0.1 / 9, 9), rep(0.9 / 91, 91))))

  # jeśli nie mam żadnej wartości poniżej 10 to wartość minimalną zmieniam na wartość 8
  if (all(agregat$n > 9)) {
    min_index = which.min(n)
    agregat$n[min_index] = 8
  }

  agregat = agregat %>%
    uncount(n) %>%
    mutate(id_abs = row_number(),
           rok_ur = sample(c(2001:2003), size = n(), prob = c(23.0, 47.2, 29.8), replace = TRUE),
           rok_abs = 2021) %>%
    mutate(
      nazwa_zaw = case_when(

        typ_szk %in% "Technikum" ~ sample(zawody[zawody$typ_szk %in% "Technikum", "nazwa_zaw"], replace = TRUE, size = 1, prob = unname(unlist(zawody[zawody$typ_szk %in% "Technikum", "ods"]))),

        typ_szk %in% "Branżowa szkoła I stopnia" ~ sample(zawody[zawody$typ_szk %in% "Branżowa szkoła I stopnia", "nazwa_zaw"], replace = TRUE, size = 1, prob = unname(unlist(zawody[zawody$typ_szk %in% "Branżowa szkoła I stopnia", "ods"]))),

        typ_szk %in% "Szkoła policealna" ~ sample(zawody[zawody$typ_szk %in% "Szkoła policealna", "nazwa_zaw"], replace = TRUE, size = 1, prob = unname(unlist(zawody[zawody$typ_szk %in% "Szkoła policealna", "ods"]))),

        typ_szk %in% "Branżowa szkoła II stopnia" ~ sample(zawody[zawody$typ_szk %in% "Branżowa szkoła II stopnia", "nazwa_zaw"], replace = TRUE, size = 1, prob = unname(unlist(zawody[zawody$typ_szk %in% "Branżowa szkoła II stopnia", "ods"]))),

        typ_szk %in% c("Liceum ogólnokształcące", "Liceum dla dorosłych", "Szkoła specjalna przysposabiająca do pracy") ~ NA_character_)) %>%
    left_join(zawody %>%
                select(nazwa_zaw, kod_zaw, branza) %>%
                distinct(),
              join_by(nazwa_zaw)) %>%
    rowwise() %>%
    mutate(
      plec = sample(c("K", "M"), size = 1, prob = c(0.52, 0.48), replace = TRUE),
      abs_w_cke = sample(c(TRUE, FALSE), size = 1, replace = TRUE, prob = c(0.78, 0.22)),
      abs_w_sio = sample(c(TRUE, FALSE), size = 1, replace = TRUE, prob = c(0.18, 0.82)),
      abs_w_polon = ifelse(typ_szk %in% c("Technikum",
                                          "Liceum dla dorosłych",
                                          "Szkoła policealna",
                                          "Liceum ogólnokształcące"),
                           sample(c(TRUE, FALSE), size = 1, replace = TRUE),
                           FALSE),
      abs_w_zus = sample(c(TRUE, FALSE), size = 1, replace = TRUE, prob = c(0.18, 0.82))
    ) %>%
    ungroup() %>%
    select(id_abs, rok_abs, rok_ur, plec, id_szk, typ_szk,
           teryt_woj, woj_nazwa, teryt_pow, nazwa_pow_szk, powiat_sr_wynagrodzenie, podregion,
           kod_zaw, nazwa_zaw, branza,
           abs_w_cke, abs_w_sio, abs_w_polon, abs_w_zus,
           adres_szk, nazwa_szk)

  return(agregat)
}
#' @title Tworzenie dummy data tabeli pośredniej \code{P3}
#' @description Funkcja tworzy dummy data tabeli pośredniej \code{P3} na
#' podstawie tabeli pośredniej \code{P4}, która potem będzie używana do
#' testowania pakietu \code{MLASZdaneAdm4}.
#' @details Zbiór tworzony przez tę funkcję ma odzwierciedlać tabelę pośrednią
#' \code{P3} w stopniu, jaki jest wymagany do przetestowania funkcji liczących
#' wskaźniki zagregowane. Tabela \code{P4}, a konkretniej jej symulowana wersja
#' tworzona przez funkcję \code{\link{dummyP4}}, to tabela zawierająca
#' niezmienne w czasie (każdy wiersz to osobny absolwent) informacje o
#' absolwentach na podstawie, której tworzony jest zbiór osobo-miesięcy
#' opisujący epizody edukacyjno-zawodowe, czyli tabelę \code{P3}.
#' @param indyw tabela pośrednia \code{P4} w wersji symulowanej (np. za pomocą
#' funkcji \code{\link{dummyP4}})
#' @param seed wartość ziarna generatora - domyślna wartość to \code{NULL}
#' (argument opcjonalny na wypadek potrzeby powtarzalności obliczeń)
#' @return data.frame
#' @importFrom tibble is_tibble
#' @importFrom dplyr %>% group_by slice_sample ungroup select mutate rowwise
#' case_when all_of
#' @importFrom tidyr uncount
#' @export
dummyP3 = function(indyw, seed = NULL) {
  col_p4 = c("id_abs", "rok_abs", "id_szk", "typ_szk", "teryt_woj", "teryt_pow",
             "plec", "branza", "nazwa_zaw", "podregion", "powiat_sr_wynagrodzenie")

  stopifnot(is.character(seed) | is.numeric(seed) | is.null(seed),
            is_tibble(indyw) | is.data.frame(indyw),
            nrow(indyw) > 0 & ncol(indyw) > 0,
            col_p4 %in% names(indyw))

  # ustawianie ziarna generatora
  if (!is.null(seed)) {
    set.seed(seed)
  }

  p3 = indyw %>%
    group_by(id_szk) %>%
    slice_sample(prop = 0.9) %>%
    ungroup() %>%
    select(all_of(col_p4)) %>%
    mutate(n = 17) %>%
    uncount(n) %>%
    group_by(id_abs) %>%
    mutate(okres = 24253:24269) %>%
    ungroup() %>%
    rowwise() %>%
    mutate(
      praca = sample(c(0:7, NA_integer_), replace = TRUE, size = 1, prob = c(0.15, 0.6, 0.03, 0.12, rep.int(0.1 / 5, times = 5)))
    ) %>%
    ungroup() %>%
    mutate(
      mlodociany = ifelse(typ_szk %in% c("Branżowa szkoła I stopnia", "Branżowa szkoła II stopnia", "Technikum") & praca %in% 1, sample(c(0, 1), prob = c(0.1, 0.9), size = 1), NA_integer_),
      bezrobocie = ifelse(praca %in% c(1:7), NA_integer_, sample(c(0, 1), prob = c(0.85, 0.15))),
      wynagrodzenie = ifelse(praca %in% c(2:7), runif(n = 1, min = 450, max = 5000), NA_integer_),
      wynagrodzenie_uop = ifelse(praca %in% 1, runif(n = 1, min = 900, max = 7500), NA_integer_),
      status_nieustalony = ifelse(is.na(praca), 1, 0),
      nauka = ifelse(status_nieustalony %in% 1, 0, sample(c(0, 1), prob = c(0.6, 0.4))),
      nauka2 = nauka,
      nauka_szk_abs = ifelse(nauka %in% 1, 1, sample(c(0, 1), prob = c(0.8, 0.2))),
      nauka_bs2st = ifelse(nauka %in% 1, sample(c(0, 1), prob = c(0.99, 0.01)), 0),
      nauka_lodd = ifelse(nauka %in% 1, sample(c(0, 1), prob = c(0.99, 0.01)), 0),
      nauka_spolic = ifelse(nauka %in% 1, sample(c(0, 1), prob = c(0.95, 0.05)), 0),
      nauka_studia = ifelse(typ_szk %in% c("Technikum",
                                           "Szkoła policealna",
                                           "Liceum ogólnokształcące",
                                           "Liceum dla dorosłych"),
                            sample(c(0, 1)),
                            NA_integer_),
      nauka_kkz = sample(c(0, 1), prob = c(0.999, 0.001), size = 1),
      nauka_kuz = sample(c(0, 1), prob = c(0.999, 0.001), size = 1),
      kont_mlodoc_prac = ifelse(typ_szk %in% "Branżowa szkoła I stopnia" & praca %in% 1,
                                sample(c(1:5)),
                                NA_integer_)
    )

  if (nrow(p3) < 1) {
    stop("Funkcja zwraca ramkę danych o zerowej liczbie wierszy!")
  } else {
    return(p3)
  }
}
#' @title Tworzenie dummy data tabeli pośredniej \code{P2}
#' @description Funkcja tworzy dummy data tabeli pośredniej \code{P2} na
#' podstawie tabeli pośredniej \code{P3} (zbiór osobo-miesięcy opisujących
#' sytuację edukacyjno-zawodową absolwentów), która potem będzie używana do
#' testowania pakietu \code{MLASZdaneAdm4}.
#' @details Zbiór tworzony przez tę funkcję ma odzwierciedlać tabelę pośrednią
#' \code{P2} w stopniu, jaki jest wymagany do przetestowania funkcji liczących
#' wskaźniki zagregowane. Tabela \code{P3}, a konkretniej jej symulowana wersja
#' tworzona przez funkcję \link{\code{dummyP3}}, to tabela osobo-miesięcy
#' opisujących sytuację edukacyjno-zawodową absolwentów w poszczególnych
#' miesiącach.
#' Zbiór tworzony przez funkcję zawiera 3 testowane w pakiecie
#' \code{MLASZdaneAdm4} zmienne:
#' \itemize{
#'  \item{branza_kont}{dla absolwentów kontynuujących naukę w szkołach
#'  kształcących w zawodzie jest to branża, do której należy zawód, którego uczą
#'  się w tej szkole}
#'  \item{dziedzina_kont}{dla absolwentów kontynuujących kształcenie na studiach
#'  jest to dziedzina naukowa, do której należy kierunek, który studiują}
#'  \item{dyscyplina_wiodaca_kont}{odpowiadająca dziedzinie dyscyplina naukowa}
#' }
#' @param osobomies tabela pośrednia \code{P3} w wersji symulowanej (np. za
#' pomocą funkcji \link{\code{dummyP3}})
#' @param seed wartość ziarna generatora - domyślna wartość to \code{NULL}
#' (argument opcjonalny na wypadek potrzeby powtarzalności obliczeń)
#' @return data.frame
#' @importFrom tibble is_tibble
#' @importFrom dplyr %>% group_by slice_sample ungroup select mutate rowwise
#' case_when all_of distinct
#' @importFrom tidyr uncount
#' @export
dummyP2 = function(osobomies, seed = NULL) {
  col_p3 = c("id_abs", "rok_abs", "id_szk", "typ_szk", "teryt_woj", "teryt_pow",
             "branza", "podregion", "plec",
             "nauka_bs2st", "nauka_spolic", "nauka_studia", "nauka_kkz", "nauka_kuz")

  stopifnot(is.character(seed) | is.numeric(seed) | is.null(seed),
            is_tibble(osobomies) | is.data.frame(osobomies),
            nrow(osobomies) > 0 & ncol(osobomies) > 0,
            col_p3 %in% names(osobomies))

  # ustawianie ziarna generatora
  if (!is.null(seed)) {
    set.seed(seed)
  }

  branze_top10 = c("opieki zdrowotnej", "fryzjersko-kosmetyczna", "ochrony i bezpieczeństwa osób i mienia", "ekonomiczno-administracyjna", "ogrodnicza", "pomocy społecznej", "motoryzacyjna", "hotelarsko-gastronomiczno-turystyczna", "rolno-hodowlana", "mechaniczna")

  dziedziny_dyscypliny = data.frame(
    dziedzina_kont = c(rep("nauk inżynieryjno-technicznych", times = 11),
                       rep("nauk rolniczych", times = 5),
                       rep("nauk społecznych", times = 11),
                       rep("nauk ścisłych i przyrodniczych", times = 7)),
    dyscyplina_wiodaca_kont = c(
      "automatyka, elektronika i elektrotechnika", "informatyka techniczna i telekomunikacja", "architektura i urbanistyka", "inżynieria biomedyczna", "inżynieria lądowa i transport", "inżynieria mechaniczna", "inżynieria chemiczna", "inżynieria środowiska, górnictwo i energetyka", "inżynieria materiałowa", "inżynieria lądowa, geodezja i transport", "automatyka, elektronika, elektrotechnika i technologie kosmiczne", "technologia żywności i żywienia", "nauki leśne", "zootechnika i rybactwo", "rolnictwo i ogrodnictwo", "weterynaria", "nauki o zarządzaniu i jakości", "pedagogika", "ekonomia i finanse", "nauki o polityce i administracji", "nauki o bezpieczeństwie", "nauki prawne", "geografia społeczno-ekonomiczna i gospodarka przestrzenna", "psychologia", "nauki socjologiczne", "nauki o komunikacji społecznej i mediach", "prawo kanoniczne", "nauki biologiczne", "nauki chemiczne", "nauki o Ziemi i środowisku", "matematyka", "informatyka", "nauki fizyczne", "astronomia"
    )
  )

  stopifnot(nrow(dziedziny_dyscypliny) > 0)

  p2_dummy = osobomies %>%
    select(all_of(col_p3)) %>%
    mutate(nauka_bs2st = ifelse(any(nauka_bs2st %in% 1), 1, 0),
           nauka_spolic = ifelse(any(nauka_spolic %in% 1), 1, 0),
           nauka_studia = ifelse(any(nauka_studia %in% 1), 1, 0),
           nauka_kkz = ifelse(any(nauka_kkz %in% 1), 1, 0),
           nauka_kuz = ifelse(any(nauka_kuz %in% 1), 1, 0)) %>%
    distinct() %>%
    slice_sample(prop = 0.95) %>%
    filter(typ_szk %in% c("Branżowa szkoła I stopnia",
                          "Technikum",
                          "Liceum ogólnokształcące",
                          "Branżowa szkoła II stopnia",
                          "Szkoła policealna"),
           any(nauka_bs2st %in% 1,
               nauka_spolic %in% 1,
               nauka_studia %in% 1,
               nauka_kkz %in% 1,
               nauka_kuz %in% 1)) %>%
    mutate(
      branza_kont = ifelse(typ_szk %in% c("Branżowa szkoła I stopnia",
                                          "Branżowa szkoła II stopnia",
                                          "Technikum",
                                          "Szkoła policealna") &
                             all(nauka_bs2st %in% 1 | nauka_spolic %in% 1 | nauka_kkz %in% 1 | nauka_kuz %in% 1),
                           sample(branze_top10, size = 1),
                           NA_character_),
      dyscyplina_wiodaca_kont = ifelse(nauka_studia %in% 1,
                                       sample(dziedziny_dyscypliny$dyscyplina_wiodaca_kont, size = 1), NA_character_)
    ) %>%
    left_join(dziedziny_dyscypliny, join_by(dyscyplina_wiodaca_kont)) %>%
    select(-c(nauka_bs2st:nauka_kuz))

  return(p2_dummy)
}
