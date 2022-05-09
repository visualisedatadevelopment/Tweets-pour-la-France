library(dplyr)
library(stringr)

setwd("~/French Election Project/Milestone 1")

rm(list = ls())

districts<- read.csv("NUPES Parties by District.csv", stringsAsFactors = F, encoding = "UTF-8")

parties<- read.csv("NUPES Parties.csv", stringsAsFactors = F)
unique(districts$party)

conversion<- data.frame(old = unique(districts$party), new = unique(parties$PARTY_NAME_ORIGINAL)[c(3,1,2,4)]) 

parties<- left_join(parties, conversion, by = c("PARTY_NAME_ORIGINAL" = "new"))

districts<- left_join(districts, parties, by = c("party" = "old"))
colnames(districts)[1]<- "department"

outdf<- select(districts, -party)

outdf$district_code<- str_replace(outdf$district_code, "-", "")
outdf$NUMERIC_PARTY_IDENTIFIER[is.na(outdf$NUMERIC_PARTY_IDENTIFIER)]<- ""
write.csv(outdf, "NUPES Parties by District Official Names.csv", row.names = F)
