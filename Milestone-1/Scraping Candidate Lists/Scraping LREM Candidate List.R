library(rvest)
library(dplyr)
library(stringr)
library(tidyr)

setwd("~/French Election Project/Milestone 1")

### Page 1

page<- read_html("https://nos-candidats.avecvous.fr/nos-candidats/")

people<- html_elements(page, css = "h3.elementor-heading-title")%>%
  html_text()

districts<- html_elements(page, css = "p.elementor-heading-title")%>%
  html_text()
districts<- districts[str_detect(districts, "è")]

outdf<- data.frame(name = people, district = districts)

### Page 2

page<- read_html("https://nos-candidats.avecvous.fr/nos-candidats/page/2/")

people<- html_elements(page, css = "h3.elementor-heading-title")%>%
  html_text()

districts<- html_elements(page, css = "p.elementor-heading-title")%>%
  html_text()
districts<- districts[str_detect(districts, "è")]

newdf<- data.frame(name = people, district = districts)

outdf<- rbind(outdf, newdf)

### Page 3

page<- read_html("https://nos-candidats.avecvous.fr/nos-candidats/page/3/")

people<- html_elements(page, css = "h3.elementor-heading-title")%>%
  html_text()

districts<- html_elements(page, css = "p.elementor-heading-title")%>%
  html_text()
districts<- districts[str_detect(districts, "è")]

newdf<- data.frame(name = people, district = districts)

outdf<- rbind(outdf, newdf)

outdf<- separate(data = outdf, col = district, into = c("district", "department"), sep = " de ?l?a?'? | de l' | du | de la | des | d' ", extra = "merge")

outdf$start<- str_locate(outdf$name, "\\s[A-ZÀ-Ú']{2,}+")[,"start"]

outdf<- mutate(outdf, first_name = substr(name, 0, start - 1))

outdf<- mutate(outdf, last_name = str_trim(substr(name, start+1, 100)))

outdf$last_name<- str_to_title(outdf$last_name)

deps<- read.csv("departments.csv", stringsAsFactors = F)

deps$NUMÉRO<- str_pad(deps$NUMÉRO, width = 3, side = "left", pad = "0")

outdf[!outdf$department %in% deps$NOM,]%>%
  View()

outdf$department[outdf$department=="Seine-Saint-Denis"]<- "Seine-St-Denis"
outdf$department[outdf$department=="Val-d'Oise"]<- "Val-D'Oise"

outdf<- left_join(outdf, deps, by = c("department" = "NOM"))

outdf$circon<- str_extract(outdf$district, "\\d+")
outdf$circon<- str_pad(outdf$circon, width = 2, side = "left", pad = "0")
outdf$district_number<- paste0(outdf$NUMÉRO, outdf$circon)

outdf<- select(outdf, district_number, district, department, first_name, last_name)

write.csv(outdf, file = "Scraped LREM Candidate List.csv", row.names = F)
