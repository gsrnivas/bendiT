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