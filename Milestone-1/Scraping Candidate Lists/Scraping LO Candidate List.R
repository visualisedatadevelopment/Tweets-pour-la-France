library(RSelenium)
library(netstat)
library(wdman)
library(dplyr)
library(tidyr)

setwd("~/French Election Project/Milestone 1")

p<- free_port()

cdvs<- binman::list_versions("chromedriver")

cdvs$win32[1]
mypage<- rsDriver(chromever=cdvs$win32[1], port = p)
myclient<- mypage$client
myclient$navigate("https://www.lutte-ouvriere.org/legislatives")

css_slector<- "#map > svg > path:nth-child(4)"
svg<- myclient$findElement("css", "#map > svg")
paths<- svg$findChildElements("css", "path")

path<- myclient$findElement("css", css_slector)
dfout<- data.frame(department = c(), district = c(), text = c())

for (svgp in paths){
  newrow<- data.frame(department = c(), district = c(), text = c())
  svgp$clickElement()
  popup<- myclient$findElement("css", "#popup")
  dep<- popup$findChildElement("css", ".title")$getElementText()%>%
    unlist()
  print(dep)
  candidate_list<- popup$findChildElement("css", ".candidats")
  districts<- candidate_list$findChildElements("css", "h4")
  circons<- lapply(districts, function(d){d$getElementText()})%>%
    unlist()
  candidates<- popup$findChildElements("css", "div.candidat")
  candidate_names<- sapply(candidates, function(c){return(c$getElementText())})%>%
    unlist()
  filtered_candidates<- candidate_names[!grepl("SupplÃ©ant", candidate_names, fixed = T)]
  newrow<- data.frame(department = rep(dep, length(circons)), district = circons, text = filtered_candidates)
  newrow$text<- gsub("\n", " >> ", newrow$text, fixed = T)
  dfout<- rbind(dfout, newrow)
}

write.csv(dfout, file = "Scraped LO Candidate List.csv", row.names = F)

#####
#Changed in excel
#####
rm(list = ls())

df<- read.csv("Raw Copy of Scraped LO Candidate List .csv", stringsAsFactors = F)
df$start<- str_locate(df$name, "\\s[A-ZÀ-Ú']{2,}+")[,"start"]

df<- mutate(df, first_name = substr(name, 0, start - 1))
df<- mutate(df, last_name = str_trim(substr(name, start+1, 100)))

df$last_name<- str_to_title(df$last_name)
dfout<- select(df, department, district, first_name, last_name, profession)

write.csv(dfout, file = "Scraped LO Candidate List.csv", row.names = F)
df[is.na(df$last_name),]

 