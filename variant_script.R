data <- read.csv(url("https://data.cdc.gov/resource/jr58-6ysp.csv?variant=BA.2.86"))
data$week_ending <- as.Date(substr(data$week_ending, 1, 10))
str(data)
head(data)
summary(data)

ui <- fluidPage(
  titlePanel("BA.2.86 SARS-CoV-2 Variants by HHS Region"),
  sidebarLayout(
    sidebarPanel(
            textInput("usa_or_hhsregion", "Enter your HHS Region:"),
      textInput("week_ending", "Enter Biweekly Date YYYY-MM-DD (e.g. 2023-10-28):")
    ),
    mainPanel(
      tags$img(src = "https://www.hhs.gov/sites/default/files/regional-offices.png", height = 200, width = 300),
      tableOutput("variant_table")
    )
  )
)
server <- function(input, output) {
  selected_variants <- reactive({
    subset(data, usa_or_hhsregion == as.character(input$usa_or_hhsregion) & week_ending == as.character(input$week_ending))
  })
  
  output$variant_table <- renderTable({
    print(selected_variants())
  })
  
  # Print unique values of 'usa_or_hhsregion' and 'week_ending'
  observe({
    print(unique(data$usa_or_hhsregion))
    print(unique(data$week_ending))
  })
}
shinyApp(ui = ui, server = server)

