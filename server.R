
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
library(raster)
sink(file="/var/log/shiny-server/thislog.log",append=TRUE)
tas = readOGR("tas.gpkg","tas")
proj4string(tas)="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
tas=spTransform(tas,CRS("+proj=utm +zone=55 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs" ))

fl=list.files("/tif")
br = stack(paste0("/tif/",fl))

shinyServer(function(input, output) {
  
  data <- reactiveValues(
      of = NULL
  )
  
  output$tasMap <- renderPlot({
	cat("File1\n")
    # input$bins 
    
	infile = input$file1
	if(is.null(infile)){
	       par(mar=c(0,0,0,0))
		plot(tas,col="blue",xlim=c(250000,625000),ylim=c(5150000,5600000))
		return()
	}
	cat(paste0(infile$datapath,"\n"))
	infile2 = read.csv(infile$datapath,stringsAsFactors=FALSE)
	names(infile2)=c("Site.Type","Easting","Northing")
	infile2 = subset(infile2, !is.na(Northing))
	infile2 = subset(infile2, !is.na(Easting))
	# draw the histogram with the specified number of bins
	par(mar=c(0,0,0,0))
	plot(tas,col="yellow",xlim=c(250000,625000),ylim=c(5150000,5600000))
	points(infile2$Easting,infile2$Northing,col="red",pch=15)
  })
  
  datasetInput <- reactive({
    of
  })
  
  output$view <- renderTable({
	if(is.null(data$of)){
		return(data.frame(status=getwd()))
	}
	    data$of
  })
  
  observeEvent(input$addpoint,{
    infile = input$file1
    infile2 = read.csv(infile$datapath)
    coordinates(infile2)=c("Easting","Northing")
    withProgress(message="Extracting data",value=0,{
	for(i in 1:dim(br)[3]){
	 trast = br[[i]]
	 print(i)
	 tcol = extract(trast,infile2)
	 incProgress(1/dim(br)[3],detail=paste("Layer:",names(br)[i]))
	 infile2$temp = tcol
	 names(infile2)[ncol(infile2)]=names(br)[i]
	}
	})

    write.csv(infile2@data,paste0("/tmp/output_",format(Sys.time(),"%Y%m%d_%H%M"),".csv"))
    data$of <- infile2@data
  })

})
