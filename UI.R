
# Define UI
ui <- fluidPage(
  # App title with image
  titlePanel(
    h1(
      img(src = "app_img.png", height = 90, width = 269),
      img(src = "app_img2.png", height = 90, width = 100),
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