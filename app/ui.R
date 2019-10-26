
dashboardPagePlus(skin = "blue", 
              title = "BendiT", # Browser Tab Title
              
  
  dashboardHeaderPlus(title = "BendiT Dev"), # Header Title

  dashboardSidebar(
    sidebarMenu(
      menuItem("Admin Overview", tabName = "overview", icon = icon("info-circle")),
      menuItem("Test", icon = icon("file-text-o"),
            menuSubItem("Test1", tabName = "test1", icon = icon("outdent")),
            menuSubItem("Test2", tabName = "test2", icon = icon("outdent"))
            )
    )
  ),
  
  dashboardBody(
    useShinyalert(),
    useShinyjs(),
    # tabItems(
    #   source(file.path("ui/normalization_tab_ui.R"),  local = TRUE)$value
    # )
  ),

  dashboardFooter(
    left_text = "Girish.Srinivas@basf.com", 
    right_text = "https://github.com/gsrnivas/bendiT"
  )
)