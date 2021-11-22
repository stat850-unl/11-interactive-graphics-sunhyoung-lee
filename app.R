library(shiny)
library(ggplot2)
library(dplyr)
library(rsconnect)

#Link to the cocktail app
rsconnect::deployApp('C:\\Users\\slee82\\OneDrive - University of Nebraska-Lincoln\\Documents\\Stat850\\11-interactive-graphics-sunhyoung-lee')

#read the cocktail data
cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')


ui = fluidPage(
  titlePanel("Cocktail Recipe"),
  
  sidebarPanel(
    #Drop-down menu for drink on the left side of the panel
    selectInput(inputId = "drink_type", "Drink", choices = sort(unique(cocktails$drink)), selected = "Rum Sour")
  ),
  #The barchart on the right side of the panel
  mainPanel(
    tabsetPanel(
      tabPanel("Barchart", plotOutput("ingredient"))
    )
  )
  
)


server = function(input, output) {
  #Filter by drink
  cocktails_subset <- reactive({
    cocktails %>%
      filter(drink == input$drink_type)
  })
  
  #Plot the bar graph
  output$ingredient <- renderPlot({
    
    ggplot(data = cocktails_subset(), aes(x = ingredient, fill = ingredient)) + 
      geom_bar()+
      labs(x = "Ingredient ", title = "Cocktails Ingredients")
  })
}


shinyApp(ui = ui, server = server)