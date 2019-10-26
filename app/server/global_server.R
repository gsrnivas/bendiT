# Global variables

# Find numeric columns in the dataset
material_type_choices <- reactive({
  
  req(load_data$data)
  load_data$data %>% select(Materia.Type) %>% unique() %>% pull()
  
})