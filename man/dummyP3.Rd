% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dummy_data.R
\name{dummyP3}
\alias{dummyP3}
\title{Tworzenie dummy data tabeli pośredniej \code{P3}}
\usage{
dummyP3(indyw, seed = NULL)
}
\arguments{
\item{indyw}{tabela pośrednia \code{P4} w wersji symulowanej (np. za pomocą
funkcji \code{\link{dummyP4}})}

\item{seed}{wartość ziarna generatora - domyślna wartość to \code{NULL}
(argument opcjonalny na wypadek potrzeby powtarzalności obliczeń)}
}
\value{
data.frame
}
\description{
Funkcja tworzy dummy data tabeli pośredniej \code{P3} na
podstawie tabeli pośredniej \code{P4}, która potem będzie używana do
testowania pakietu \code{MLASZdaneAdm4}.
}
\details{
Zbiór tworzony przez tę funkcję ma odzwierciedlać tabelę pośrednią
\code{P3} w stopniu, jaki jest wymagany do przetestowania funkcji liczących
wskaźniki zagregowane. Tabela \code{P4}, a konkretniej jej symulowana wersja
tworzona przez funkcję \code{\link{dummyP4}}, to tabela zawierająca
niezmienne w czasie (każdy wiersz to osobny absolwent) informacje o
absolwentach na podstawie, której tworzony jest zbiór osobo-miesięcy
opisujący epizody edukacyjno-zawodowe, czyli tabelę \code{P3}.
}
