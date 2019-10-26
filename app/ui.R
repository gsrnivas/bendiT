
dashboardPagePlus(skin = "green", 
              title = "BendiT", # Browser Tab Title
  
  dashboardHeaderPlus(title = "BendiT Dev"), # Header Title

  dashboardSidebar(
    sidebarMenu(
      menuItem("Order", tabName = "order", icon = icon("info-circle")),
      menuItem("Listing", tabName = "list", icon = icon("info-circle")),
      menuItem("Admin", tabName = "admin", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    useShinyalert(),
    useShinyjs(),
    tabItems(
      source(file.path("ui/order_tab_ui.R"),  local = TRUE)$value
    )
  ),
  
  dashboardFooter(
    left_text = "1&ONLY Team - #cma-Challenge-CircularEconomy- CAMELOT", 
    right_text = "https://github.com/gsrnivas/bendiT"
  )
)