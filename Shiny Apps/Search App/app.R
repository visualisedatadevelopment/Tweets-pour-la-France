library(rtweet)
library(shiny)
library(stringr)
library(waiter)
library(stringdist)
library(dplyr)
library(stringdist)
library(readxl)

ui <- fluidPage(
  
  tags$head(tags$style(HTML("img{max-height: 50px;}"))),
  
  h3("User search"),
  fileInput(inputId = "upload", label = "Upload a xlsx file of candidates"),
  fileInput(inputId = "incumb_upload", label = "Upload a xlsx file of incumbents"),
  br(),
  selectInput("nameselect", label = "Choose candidate to search", choices = c()),
  br(),
  br(),
  conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                       div(id="loadmessage",
                           h5("Loading"))),
  htmlOutput("incumbent_flags"),
  br(),
  br(),
  dataTableOutput("resultstable")
)

server<- function(input, output, session){
  
  # Add credentials below
  #key = 
  #secret = 
  
  #accessToken = 
  #accessSecret = 
  
  
  token<- create_token(app = "refreshingTweepy", consumer_key = key, consumer_secret = secret, access_token = accessToken, access_secret = accessSecret)
  
  observe({
    inFile<- input$upload
    
    if (is.null(inFile)){
      return(NULL)
    }
    
    canddf<- read_excel(inFile$datapath)
    colnames(canddf)<- c("first_name", "last_name")
    canddf<- canddf%>%
      dplyr::mutate(full_name = paste(first_name, last_name))
    names<- canddf$full_name
    View(canddf)
    
    View(names)
    updateSelectInput(session = session, inputId = "nameselect", choices = names)
  })

  output$resultstable<- renderDataTable({
    
    if (input$nameselect == ""){
      print("Name is null")
      return(NULL)
    }
    outdf<- search_users(input$nameselect, n = 1000)
    if(nrow(outdf)==0){
      return(data.frame(result = c("No results")))
    }
    outdf$link<- paste0("<a href = 'https://twitter.com/", outdf$screen_name, "' target='_blank'>Link</a>")
    outdf$pic<- paste0("<img src = '", outdf$profile_image_url, "'></img>")
    outdf$banner<- paste0("<img src = '", outdf$profile_banner_url, "'></img>")
    outdf<- select(outdf, screen_name, user_id, name, description, statuses_count, followers_count, friends_count, link, pic, banner)
    colnames(outdf)<- c("handle", "id", "profile name", "bio", "tweets", "followers", "following", "link", "pic", "banner")
    outdf<- unique(outdf)
    return(outdf)
  }, escape = F)
  
  
  output$incumbent_flags<- reactive({
    if (is.null(input$incumb_upload)){
      return(NULL)
    }
    incumb_inFile<- input$incumb_upload
    
    incumb<- read_excel(incumb_inFile$datapath)
    colnames(incumb)<- c("first_name", "last_name")
    View(incumb)
    incumb<- incumb%>%
      dplyr::mutate(full_name = paste(first_name, last_name))
    incumb$sim<- stringsim(input$nameselect, incumb$full_name)
    flagdf<- filter(incumb, sim >= 0.7)
    if (nrow(flagdf>0)){
      return(paste("<div style = 'color: red'>Similar incumbents found:", as.character(flagdf$full_name), "</div>", collapse =  "<br>"))  
    }
    else{
      return("<div>No incumbent flags</div>")
    }
    
  })
  
}

shinyApp(ui = ui, server = server)
