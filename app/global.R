## Packages -------------------------------------------------------
# library(taRifx)
library(httr)
library(jsonlite)
library(shiny)
library(shinydashboardPlus)
library(shinydashboard)
library(shinyalert)
library(shinycustomloader)
library(shinyjs)
library(rhandsontable)
library(shinycssloaders)
library(data.table)
library(shinyWidgets)
library(future)
library(DT)
library(shinyBS)
library(tidyverse)
library(plotly)
library(V8)
library(tidyr)
library(dplyr)
library(heatmaply)
library(scatterD3)
library(mongolite)
options(warn = -1)

plan(multisession)
options(scipen=999)

# Init env variables

# Global Variables --------------------------------------------------------

mongourl <- Sys.getenv("benditDB_url")
mongousr <- Sys.getenv('benditDB_usr')
mongopwd <- Sys.getenv('benditDB_pwd')
db <- Sys.getenv('benditDB_name')
collection <- Sys.getenv('benditDB_collection')

#load modules
#source("modules/test.R", local = TRUE)

mongo_insert_data <- function(data, collection, db, url, verbose){
  
  # connect to mongo
  mongo.con <- mongo(collection= collection, 
                     db = db, 
                     url = mongourl, 
                     verbose = TRUE)
  
  # dump the data to mongo
  
  message = mongo.con$insert(data)
  
  # remove the mongo connection
  rm(mongo.con)
  
  gc()
  
  return(message)
  
}

# Read data from the Excel file and move the data to mongo db
#data <- fread("data/CIRCULAR-ECONOMY-DATASET-I.csv")
# mongo_insert_data(data, collection,db,url,"TRUE")



