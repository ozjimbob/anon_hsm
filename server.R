
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(sp)
library(maptools)
library(rgdal)
library(DT)

tas = readOGR("tas.gpkg","tas")
proj4string(tas)="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
tas=spTransform(tas,CRS("+proj=utm +zone=55 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs" ))

#if(file.exists("test.csv")){
#  of = read.csv("test.csv")
#}else{
  of=data.frame(MAP=0,
                MAT=0,
                ELE=0,
                SLO=0,
                ASP=0,
                TPI=0)
  write.csv(of,"test.csv",row.names=FALSE)
#}

joinEnv = function(x,y){
  data.frame(MAP=runif(1,450,2000),
             MAT=runif(1,5,25),
             ELE=runif(1,0,1650),
             SLO=runif(1,0,90),
             ASP=runif(1,0,360),
             TPI=runif(1,-2,2))
}


shinyServer(function(input, output) {
  
  data <- reactiveValues(
      of = read.csv("test.csv")
  )
  
  output$tasMap <- renderPlot({

    # input$bins 

    # draw the histogram with the specified number of bins
    par(mar=c(0,0,0,0))
    plot(tas,col="yellow",xlim=c(250000,625000),ylim=c(5150000,5600000))
    points(input$easting,input$northing,col="red",pch=15)
    #points(of$x,of$y,col="black",pch=14)
  })
  
  datasetInput <- reactive({
    of
  })
  
  output$view <- renderTable({
    data$of
  })
  
  observeEvent(input$addpoint,{
    tf=joinEnv(input$easting,input$northing)
    write.table(tf,"test.csv",col.names=FALSE, sep=",",row.names=FALSE,append=TRUE)
    data$of <- read.csv("test.csv")
  })

})
