server <- function(input, output, session) {
  
  # Reactive Values --------------------------------------------------------
  load_data <- reactiveValues(data = NULL)
  load_data$data <- get_data(collection, db, mongourl)
  
  # Source Server Files -----------------------------------------------------
  source(file.path("server/global_server.R"),  local = TRUE)$value
  source(file.path("server/order_tab_server.R"),  local = TRUE)$value
  
}







