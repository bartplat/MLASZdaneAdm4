library(MLASZdaneAdm4)
library(dplyr)
library(tidyr)
load("agregat.rda")
load("rspo.rda")

p4_dummy = dummyP4(agregat, rspo)
p3_dummy = dummyP3(indyw = p4_dummy)
p2_dummy = dummyP2(osobomies = p3_dummy)
