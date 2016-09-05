
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
      textInput("northing",
                  "Northing",
                  value=0),
      textInput("easting",
                "Easting",
                value=0),
      actionButton("addpoint","Add Point")
    ),


    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("tasMap"),
      h4("Data Collected"),
      tableOutput("view")
    )
  )
))
