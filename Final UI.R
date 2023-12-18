

library(shiny)
library(plotly)

# Define UI
ui <- fluidPage(
  # App title with image
  titlePanel(
    h1(
      img(src = "https://lh3.googleusercontent.com/pw/ADCreHetwhQRfdo9tT7Nd1ynpjFf_IfyJiKYzNsvJIsEWjhuyF7384PNUxeE2sPzOwgZlIzJ5gdwENBUQcrWZwYPG9o4NoT6RVRBIjqEMx7iW8z88A5wh4UonuOAYQjlG_1-y0Dqd5LYmLvsAcZJe8NDhyb0eiGxAo8DUPX3OhhVM9wq5lEgPX92mGirZlGtuLTFLLuGnLZXJBmWRBie_bw-SOMyw0YrP1WO_FloLfBf5XbxbvnDUryKrlyyooHVZeyYJFR3cXhmfOwn9XeFJiraM5nv2pxjBqDV6rDmncwIiw7GV92W7hKTCQFeqK-dBRsVNvZb8XdIRdCRTdN1AiPe7qE36hyrWNMz9euyp-ezs9EviYCcW53mEopZESfp-adrqPjQZ2KU3G74cujslM5pO4OwVN_3XLzVvGKaxmLttp1l41NR-j2I5w4YCJYfEQhFyRhjAZ2nJaATIcBNlXxMoyveBRXca9M0MPNbJUHe1tH_SwJTHiCr6aSR69EF0leMrA0TJnYufRZS5AttazkKb3tg7f--FyeJmDrgs6otEyiRoBXTLEptlEPoFPXgpYl7WKOeI3uhrxrqmbBHBU2Uu78Ws7mDfMdKmkLCUmXFWL9AhUflOlyXGZ8jrlMDIdP1XQK6bRql04v7AyWvvPpS7C2lfVZanr0ijoqX5Qd3qrTxn8IBiI3OlbWYcNuPlfe1SNQ-XjwLe5FjzdYHtHCk2iI4l_UJoUf5DgliCfRVe7AEpvJcYfd5uNjcVYl33naqFxWoIUvqkwB7FmKbmqHhvSD0Ltk2PRx1CGT21O0Or6TGyIrKY5Gk1nN8SW-NRCZO8Cl4ERME9Kd2cnnDbKpDhEZFBXfrnjAf6xq0TqN03BC7dc5RAxYXHTyFyK9KsKeHNbO3Puxo_sNpQr74CJcnq4-zN4BtNSH7S9BM_eN1MJyUr-Dp-GFyVNYnW0yYI_YjOBvn_O9R9Lo=w571-h260-s-no-gm?authuser=1", height = 90, width = 269),
      img(src = "https://photos.google.com/u/1/photo/AF1QipN_6_sngbi6SfvTM4SwoSAlZl_DfCyQWEX3Mu5r", height = 90, width = 100),
      strong("Graph Maker")
    )
  ),
  style = "background-color: #CDD7DD;",                                    #CDD7DD
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      style = "background-color:#31B698;",                   # 31B698 #33FFD4 #efdda7 #dc9b58
      
      # File input for uploading data
      fileInput("file", "Choose File", accept = c(".csv", "xlsx")),
      
      # Select input for graph type
      selectInput("graph_type", "Select Graph Type",
                  choices = c("Scatter Plot", "Bar Chart", "Line Chart", "Histogram")),
      
      # Select input for X-axis variable
      selectInput("x_axis", "Select X-Axis", NULL),
      
      # Conditional panel for Y-axis variable based on graph type
      conditionalPanel(
        condition = "input.graph_type != 'Histogram'",
        selectInput("y_axis", "Select Y-Axis", NULL)
      ),
      
      # Text input for graph title
      textInput('title_graph', 'Write a Title for the Graph'),
      
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Data", tableOutput("head")),
        tabPanel("Plot", plotlyOutput("graph1"))
      )
    )
  )
)

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

# Run the Shiny app
shinyApp(ui, server)

