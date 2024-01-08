

# Define server
server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  observeEvent(input$file, {
    updateSelectInput(session, "x_axis", choices = names(data()))
    updateSelectInput(session, "y_axis", choices = names(data()))
  })
  
  output$head <- renderTable({
    head(data())
  })
  
  output$graph1 <- renderPlotly({
    xvar <- input$x_axis
    yvar <- input$y_axis
    
    if (input$graph_type == "Scatter Plot") {
      plot_ly(data(), x = ~get(xvar), y = ~get(yvar), type = "scatter", mode = "markers") %>%
        layout(title = input$title_graph,
               xaxis = list(title = xvar),
               yaxis = list(title = yvar))
    } else if (input$graph_type == "Bar Chart") {
      plot_ly(data(), x = ~get(xvar), y = ~get(yvar), type = "bar") %>%
        layout(title = input$title_graph,
               xaxis = list(title = xvar),
               yaxis = list(title = yvar))
    } else if (input$graph_type == "Line Chart") {
      plot_ly(data(), x = ~get(xvar), y = ~get(yvar), type = "scatter", mode = "lines") %>%
        layout(title = input$title_graph,
               xaxis = list(title = xvar),
               yaxis = list(title = yvar))
    } else if (input$graph_type == "Histogram") {
      plot_ly(data(), x = ~get(xvar), type = "histogram") %>%
        layout(title = input$title_graph,
               xaxis = list(title = xvar),
               yaxis = list(title = "Frequency"))
    }
  })
}