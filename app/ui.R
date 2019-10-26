
dashboardPagePlus(skin = "blue", 
              title = "BendiT", # Browser Tab Title
              
  
  dashboardHeaderPlus(title = "BendiT Dev"), # Header Title

  dashboardSidebar(
    sidebarMenu(
      menuItem("Order", tabName = "order", icon = icon("info-circle")),
      menuItem("Test", icon = icon("file-text-o"),
            menuSubItem("Test1", tabName = "test1", icon = icon("outdent")),
            menuSubItem("Test2", tabName = "test2", icon = icon("outdent"))
            )
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