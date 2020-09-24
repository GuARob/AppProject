#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(plotly)
library(dplyr)
library(ggplot2)

db <- read.csv("C:/RFoldr/Part9/Project/Currencies.csv")
db$MonthBeg <- paste(db$MonthDate,"-01", sep="")
db$MonthDateNum <- as.Date(db$MonthBeg, format="%Y-%m-%d")
db$MonthEnd <- db$MonthDateNum + months(1) - days(1)
currlist <- names(db)[2:23]
indexlist <- names(db)[24:26]



#
shinyServer(function(input, output) {

    output$myPlot <- renderPlot({
        currsym <- input$currency
        indexsym <- input$index
        begdate <- as.Date(input$datesel[1],format("%Y-%m-%d"))
        enddate <- as.Date(input$datesel[2],format("%Y-%m-%d"))
        colvec <- c(which(names(db) == currsym),which(names(db) == indexsym), 29)
        dbbeta <- db[db$MonthEnd>=begdate & db$MonthEnd <= enddate,colvec]
        modfit <- lm(dbbeta[,currsym] ~ dbbeta[,indexsym])
        ggplot(dbbeta, aes(x=dbbeta[,indexsym], y=dbbeta[,currsym])) +
            geom_point(color="purple", size=2) +
            geom_smooth(method=lm,se=FALSE) +
            annotate(geom="text", x=0, y=2, label=paste("alpha=",
                    as.character(round(modfit$coefficients[1],4)),"; beta=",
                    as.character(round(modfit$coefficients[2],4))),
                     color="red")+
            ggtitle(paste(currsym, "Sensitivity to", indexsym)) +
            xlab(paste("Monthly Returns (%) of",indexsym)) + 
            ylab(paste("Monthly Returns (%) of", currsym))
    })


    
    
})
