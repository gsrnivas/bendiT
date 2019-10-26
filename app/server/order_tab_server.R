#order server part

observe({
  req(material_type_choices())
  updateSelectInput(session,  inputId = 'order_material_type',  choices =material_type_choices(), selected ="" )
  
})