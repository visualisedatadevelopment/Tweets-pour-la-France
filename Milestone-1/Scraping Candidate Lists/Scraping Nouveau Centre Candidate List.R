library(rvest)
library(stringr)
library(tidyr)

page<- read_html("les_centristes_youtube.html", encoding = "UTF-8")
page
titles<- html_elements(page, "#video-title")
titles<- html_text(titles)
titles<- titles[str_detect(titles, "Nos candidats #L")]

candidates<- str_replace(titles, "\U0001f535\u26aa\U0001f534 Nos candidats #Législatives2022 : ", "")
candidates<- str_replace_all(candidates, "[\n\r]", "")
candidates<- str_trim(candidates)
outdf<- data.frame(candidate = candidates)

outdf<- separate(outdf, candidate, c("name", "circon"), ", ")

outdf<- separate(outdf, circon, c("circon", "department"), sep = "d.+(?=[A-ZÀ-Ú])")
