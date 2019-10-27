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
  modalDialog(
    footer = NULL,
    size = "m",
    
      HTML(info_order),
          disabled(selectizeInput('order_data_material_name', 'Material Name',multiple=TRUE,choices=NULL,selected = NULL)),
          disabled(selectizeInput('order_data_material_type', 'Material Type',multiple=TRUE,choices=NULL,selected = NULL)),
          disabled(selectizeInput('order_data_material_group', 'Material Group',multiple=TRUE,choices=NULL,selected = NULL)),
          disabled(selectizeInput('order_data_material_company', 'Company',multiple=TRUE,choices=NULL,selected = NULL)),
          disabled(selectizeInput('order_data_material_BUM', 'Units',multiple=TRUE,choices=NULL,selected = NULL)),
          disabled(selectizeInput('order_data_material_costs_per_unit', 'Cost per unit in $ ',multiple=TRUE,choices=NULL,selected = NULL)),
          textInput('order_data_material_units_order', 'Total units to order', placeholder = "Input a number"),
          textInput('order_data_contact_name', 'Contact name', placeholder = "Your contact name here"),
          textInput('order_data_contact_email', 'Contact email', placeholder = "Your email address here"),
          uiOutput("payment_details"),
    
        fluidRow(
          column(4,
        actionButton("order_confirm", "Confirm Order")
          ),
        column(6,
        actionButton(ns("closeModalBtn"), "Close")
          )
        
        )
    )
  
}




output$payment_details <- renderUI({
  
  req(input$order_data_material_units_order)
  
  htmlOutput("payment_details_display")
})

output$payment_details_display <- renderText({ 
  
  req(input$order_data_material_units_order)
  dollar <- "\u20024"
  
  payment =  (as.numeric(input$order_data_material_units_order)) * (as.numeric(input$order_data_material_costs_per_unit))

  str1<-paste0("",'<font size="5">', " Total costs is = ", payment, "$","</font>", "")
  HTML(paste0(str1))
  
})



observeEvent(input$closeModalBtn, { 
  removeModal() 
})


observeEvent(input$select_button_order, {
  selectedRow <- as.numeric(strsplit(input$select_button_order, "_")[[1]][3])
  df<- load_data$order[selectedRow,]
  
  product_cost = as.numeric(gsub("[^0-9.]", "", df$costs.of.product))
  
  # browser()
  
  showModal(myModal(session))
  
  updateSelectizeInput(session, 'order_data_material_name', choices= df$Material.Name, selected = df$Material.Name )
  updateSelectizeInput(session, 'order_data_material_type', choices= df$Materia.Type, selected = df$Materia.Type )
  updateSelectizeInput(session, 'order_data_material_group', choices= df$Materialgroup, selected = df$Materialgroup )
  updateSelectizeInput(session, 'order_data_material_company', choices=df$company ,selected = df$company )
  
  updateSelectizeInput(session, 'order_data_material_BUM', choices= df$BUM, selected = df$BUM )
  updateSelectizeInput(session, 'order_data_material_costs_per_unit', choices= product_cost, selected = product_cost )

  
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


# Order confirm  ------

observeEvent(input$order_confirm, {
  
  shinyalert("Your order has been placed", "Confirmation will be notified shortly", type = "success")
  removeModal() 
  
})
  
