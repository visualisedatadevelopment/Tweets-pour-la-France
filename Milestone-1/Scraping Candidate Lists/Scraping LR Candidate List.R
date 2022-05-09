library(rvest)
library(stringr)
library(dplyr)

## First release

page<- read_html("https://republicains.fr/actualites/2021/10/27/decision-de-la-commission-nationale-dinvestiture-du-mardi-26-octobre/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps<- ps[2:(n-1)]

deps<- ps[!substr(html_text(ps),1,1)=="-"]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[substr(html_text(ps),1,1)=="-"]

n_circons<- lapply(cand_groups, function(group){
  html_elements(group, "u")%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  html_elements(group, "u")%>%
    html_text()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()

cands<- str_replace(cands, "circonscription\\s:\\s", "")

outdf<- data.frame(deparment = deps, circon = circons, candidate = cands)


## Second Release

page<- read_html("https://republicains.fr/actualites/2021/11/19/decision-de-la-commission-nationale-dinvestiture/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps<- ps[2:n]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  html_elements(group, "u")%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  html_elements(group, "u")%>%
    html_text()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)



## Third Release

page<- read_html("https://republicains.fr/actualites/2021/11/24/decision-de-la-commission-nationale-dinvestiture-2/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps<- ps[2:(n-1)]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  html_elements(group, "u")%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  html_elements(group, "u")%>%
    html_text()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)



## Fourth Release

page<- read_html("https://republicains.fr/actualites/2021/12/09/decision-de-la-commission-nationale-dinvestiture-3/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps<- ps[2:(n)]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription")%>%
    unlist()%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "[0-9]+[:alpha:]+\\scirconscription")%>%
    unlist()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)


## Fifth Release

page<- read_html("https://republicains.fr/actualites/2021/12/17/decision-de-la-commission-nationale-dinvestiture-4/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps
ps<- ps[2:(n-1)]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription")%>%
    unlist()%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "[0-9]+[:alpha:]+\\scirconscription")%>%
    unlist()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)


## Sixth Release

page<- read_html("https://republicains.fr/actualites/2021/12/17/decision-de-la-commission-nationale-dinvestiture-5/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps
ps<- ps[2:(n-1)]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription")%>%
    unlist()%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "[0-9]+[:alpha:]+\\scirconscription")%>%
    unlist()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)


## Seventh Release

page<- read_html("https://republicains.fr/actualites/2022/02/03/decision-de-la-commission-nationale-dinvestiture-6/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps
ps<- ps[2:(n-1)]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription")%>%
    unlist()%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "[0-9]+[:alpha:]+\\scirconscription")%>%
    unlist()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)


## Eighth Release

page<- read_html("https://republicains.fr/actualites/2022/02/16/decision-de-la-commission-nationale-dinvestiture-7/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps
ps<- ps[2:(n-1)]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription")%>%
    unlist()%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "[0-9]+[:alpha:]+\\scirconscription")%>%
    unlist()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)


## Ninth Release

page<- read_html("https://republicains.fr/actualites/2022/05/05/decision-de-la-commission-nationale-dinvestiture-8/")
list<- html_elements(page, "div.has-content-area")
ps<- html_elements(list, "p")
n<- length(ps)
ps
ps<- ps[2:(n)]

deps<- ps[!str_detect(substr(html_text(ps),1,1), "[0-9]")]

deps<- html_text(deps)%>%
  str_replace(" :", "")

cand_groups<- ps[str_detect(substr(html_text(ps),1,1), "[0-9]")]

n_circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription")%>%
    unlist()%>%
    length()
})%>%
  unlist()

deps<- rep(deps, n_circons)

circons<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "[0-9]+[:alpha:]+\\scirconscription")%>%
    unlist()
})%>%
  unlist()

cands<- lapply(cand_groups, function(group){
  str_extract_all(html_text(group), "circonscription\\s:\\s[[:alpha:] ''-]+")
})%>%
  unlist()


cands<- str_replace(cands, "circonscription\\s:\\s", "")

newdf<- data.frame(deparment = deps, circon = circons, candidate = cands)

outdf<- rbind(outdf, newdf)


outdf$candidate<- str_trim(outdf$candidate)

outdf$dep_number<- str_extract(outdf$deparment, "[0-9]+")
outdf$dep_number<- str_pad(outdf$dep_number, width = 3, side = "left", pad = "0")

outdf$circon_number<- str_extract(outdf$circon, "[0-9]+")
outdf$circon_number<- str_pad(outdf$circon_number, width = 2, side = "left", pad = "0")

subdf<- filter(outdf, is.na(dep_number))


deps<- read.csv("departments.csv", stringsAsFactors = F)

deps$NUMÉRO<- str_pad(deps$NUMÉRO, width = 3, side = "left", pad = "0")

subdf[!subdf$deparment %in% deps$NOM,]%>%
  View()

subdf<- left_join(subdf, deps, by = c("deparment" = "NOM"))

subdf$NUMÉRO[subdf$deparment==subdf$deparment[39]]<- 999


outdf$dep_number[is.na(outdf$dep_number)]<- subdf$NUMÉRO

outdf$district_number<- paste0(outdf$dep_number, outdf$circon_number)

outdf<- select(outdf, district_number, circon, deparment, candidate)
colnames(outdf)[2:3]<- c("district", "department")

write.csv(outdf, "Scraped LR Partial Candidate List.csv", row.names = F)
