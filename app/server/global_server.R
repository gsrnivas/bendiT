# Global variables

# Find material types in the dataset
material_type_choices <- reactive({
  
  req(load_data$data)
  load_data$data %>% select(Materia.Type) %>% unique() %>% pull()
  
})

# Find material group in the dataset
material_group_choices <- reactive({
  
  req(load_data$data)
  load_data$data %>% select(Materialgroup) %>% unique() %>% pull()
  
})

# Find companies list in the dataset
companies_choices <- reactive({
  
  req(load_data$data)
  load_data$data %>% select(ABC) %>% unique() %>% pull()
  
})