
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Data Entry"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

	fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
			'text/comma-separated-values,text/plain', 
			'.csv')),
      actionButton("addpoint","Submit Points")
    ),


    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("tasMap"),
      h4("Data Collected"),
      tableOutput("view")
    )
  )
))
