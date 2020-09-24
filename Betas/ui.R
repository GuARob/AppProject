#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#

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


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Currencies Sensitivities to US Dollar Indexes"),
    fluidRow(column(width=12,
                 p("This application aims at estimating the sensitivity of 22 different currencies to a selected US dollar index, 
                    through a linear regression where the response variable is the monthly returns time series of a selected 
                    currency and the sole explanatory variable is the monthly returns time series of the selected index.",
                   style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
                 p("The data used in this application are publicly available on the page of the", em("G.5 Statistical Release"), "by the US Federal Reserve, 
                    at https://www.federalreserve.gov/",style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px")
                 )),
    fluidRow(column(width=12,
                    p("Instructions:",
                      style="text-align:justify;color:black;background-color:white;padding:1px;border-radius:5px"),
                    p("1. Select the from and to dates from the dialog box. You must select end of month dates",
                      style="text-align:justify;color:black;background-color:white;padding:1px;border-radius:5px"),
                    p("2. Select the currency to analyze",
                      style="text-align:justify;color:black;background-color:white;padding:1px;border-radius:5px"),
                    p("3. Select the US dollar index to use as a benchmark",
                      style="text-align:justify;color:black;background-color:white;padding:1px;border-radius:5px"))),

    sidebarLayout(
        sidebarPanel(
            width = 4,
            dateRangeInput("datesel", "From to Dates", start = "2015-07-31", end = "2020-08-31",
                           min = "2011-01-31",max = "2020-08-31", format = "yyyy-mm-dd",
                           startview = "month", weekstart = 0,language = "en", 
                           separator = " to ", width = NULL),
            br(),
            selectInput("currency",
                        label = "Choose Currency",
                        choices = currlist,
                        selected = "AUD"
            ),
            br(),
            selectInput("index",
                label = "Choose US Dollar Index",
                choices = indexlist,
                selected = "Broad_Dollar_Index"
            )),
        mainPanel(plotOutput("myPlot")))
 ))
