#order server part

observe({
  req(material_type_choices())
  updateSelectInput(session,  inputId = 'order_material_type',  choices =material_type_choices(), selected ="" )
  
})

observe({
  req(material_group_choices())
  updateSelectInput(session,  inputId = 'order_material_group',  choices =material_group_choices(), selected ="" )
  
})

observe({
  req(companies_choices())
  updateSelectInput(session,  inputId = 'order_material_company',  choices =companies_choices(), selected ="" )
  
})


observe({
  
  if(isTruthy(input$order_material_type) & isTruthy(input$order_material_group) & isTruthy(input$order_material_company)) {
    
    enable("order_listing")
    
  }else{
    
    disable("order_listing")
  }
  
})

# Order listing   ------

observeEvent(input$order_listing, {
  
  withBusyIndicatorServer("order_listing", {
    
    # filter and rename column names
    
    load_data$order_list_table <- load_data$data %>% filter(Materia.Type %in% input$order_material_type) %>% 
                                                     filter(Materialgroup %in% input$order_material_group) %>% 
                                                     filter(ABC %in% input$order_material_company)%>% 
                                                     rename(.,Material.Name= Text) %>% 
                                                     rename(.,ID= Material) %>% rename(.,company=ABC) %>% 
                                                    select(-ID, -avergae.use.time..days., -costs.of.refurbishment, -refurbishment.time,
                                                           -Seling.Price, -Demand.Q1.2020, -Demand.Q2.2020, -Demand.Q3.2020,
                                                           -sales.Q1.Q3.2020) %>% 
                                                     mutate(Buy= paste0(
                                                       '<div class="btn-toolbar" role="group">',
                                                       shinyInput(bsButtonTooltip, id, 'button_view_', label = "", 
                                                                  icon = icon("play-circle"), size = "small", tooltip = "To be part of Industrial Symbiosis - Order now", style="info", 
                                                                  onclick = 'Shiny.setInputValue(\"select_button_order\", this.id, {priority: \"event\"})'))) %>% 
                                                      select(Buy, everything(.))
    
    load_data$order <- load_data$data %>% filter(Materia.Type %in% input$order_material_type) %>% 
      filter(Materialgroup %in% input$order_material_group) %>% 
      filter(ABC %in% input$order_material_company)%>% 
      rename(.,Material.Name= Text) %>% 
      rename(.,ID= Material) %>% rename(.,company=ABC)
  })
  
})


myModal <- function(session) {
  ns <- session$ns
  modalDialog(actionButton(ns("closeModalBtn"), "Close Modal"))
}

observeEvent(input$closeModalBtn, { 
  removeModal() 
})


observeEvent(input$select_button_order, {
  selectedRow <- as.numeric(strsplit(input$select_button_order, "_")[[1]][3])
  load_data$order[selectedRow,]
  
  showModal(myModal(session))
  
})



# budgeting_table DT-------------------------------------------------------------------

output$order_listing_DT <- renderDT({
  
  req(load_data$order_list_table)
  
  table_columns <- load_data$order_list_table %>% 
    colnames()
  DT::datatable(load_data$order_list_table,
                selection = 'none',
                escape = FALSE,
                style = 'bootstrap',
                rownames = FALSE,
                filter = 'top',
                extensions = c('Buttons', 'FixedColumns'),
                options = list(dom = 'Bfrtip', 
                               pageLength = 10, 
                               scrollX = TRUE, 
                               #scrollY = "80vh",
                               autoWidth = TRUE,
                               bFilter = TRUE, 
                               scrollCollapse = TRUE,
                               searchHighlight = TRUE,
                               buttons = list(I('colvis'), 'excel', 'copy'),
                               columnDefs = list(list(width = '200px', targets = c(0,1))),
                               search = list(regex = TRUE, caseInsensitive = TRUE)
                )
  ) %>% 
    formatStyle(columns = table_columns, fontSize = '100%') 
}) 
