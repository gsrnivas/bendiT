#order UI part
useShinyjs()
tabItem(tabName = "order",
        fluidRow(
          div(
            class= "col-sm-12 col-md-3",
            boxPlus(
              title ='Order options',
              width = 12,
              status = "success",
              closable = FALSE,
              collapsible = TRUE,
              selectizeInput('order_material_type', 'Material Type',multiple=TRUE,choices=NULL,selected = NULL),
              selectizeInput('order_material_group', 'Material Group',multiple=TRUE,choices=NULL,selected = NULL),
              selectizeInput('order_material_company', 'Company',multiple=TRUE,choices=NULL,selected = NULL),
              disabled(withBusyIndicatorUI(actionButton("order_listing", "show list")))
            )
          ),
          div(
            class= "col-sm-12 col-md-9",
            boxPlus(
              title ='Available Material List',
              width = 12,
              status = "success",
              closable = FALSE,
              collapsible = TRUE,
              DT::dataTableOutput("order_listing_DT")
            )
          )
        )
)