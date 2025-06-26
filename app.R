#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library("shiny")
library("dplyr")
library("ggplot2")
library("readr")
library("ggExtra")

df <- read_csv(paste0(getwd(), "/CSV/penguins.csv"), col_types = NULL, show_col_types = FALSE)
# View(df)
df_num <- df %>% select("Bill Length (mm)", "Bill Depth (mm)", "Flipper Length (mm)", "Body Mass (g)")
# View(df_num)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # headerPanel("Here goes the header"),
    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
    sidebarLayout(
      sidebarPanel(
        varSelectInput("xvar", "X variable", df_num, selected = "Bill Length (mm)"),
        varSelectInput("yvar", "Y variable", df_num, selected = "Bill Depth (mm)"),
        checkboxGroupInput(
          "species", "Filter by species",
          choices = unique(df$Species),
          selected = unique(df$Species)
        ),
        hr(), # horizontal rule (line)
        br(), # line break
        checkboxInput("by_species", "Show species", TRUE),
        checkboxInput("show_margins", "Show marginal plots", TRUE),
        checkboxInput("smooth", "Add smoother", FALSE)
        ),
    
      mainPanel(plotOutput("scatter"))
    )

)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  subsetted <- reactive({
    
    req(input$species)
    df <- df %>% filter(Species %in% input$species)
    
  })

  output$xvar <- renderPrint({
    
    xvar <- get(input$xvar)
    
  })

  output$yvar <- renderPrint({

    yvar <- get(input$yvar)
    
  })
  
  output$scatter <- renderPlot({
    
    p <- ggplot(subsetted()) + geom_point() + aes(x = !!input$xvar, y = !!input$yvar) 
    # + theme(legend.position = "inside")
    # "none", "left", "right", "bottom", "top", "inside"
    
    if (input$by_species)
      p <- p + aes(color = Species)
    
    if (input$smooth) 
      p <- p + geom_smooth()
    
    if (input$show_margins){
      
      margin_type <- if_else(input$by_species, "density", "histogram")
      p <- ggMarginal(p, type = margin_type, margins = "both", size = 8, groupColour = input$by_species, groupFill = input$by_species)
      
    }
    
    p
  }, res = 100)
  
}

# Run the application 
shinyApp(ui = ui, server = server)