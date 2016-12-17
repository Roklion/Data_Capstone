
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# This Shiny web application can be used to take samples from various
# classic probability distributions with different parameters input/selected on
# this UI. The samples are then plotted on this UI.
#
# This application is a useful tool to learn process of sampling, as well as 
# basic probability distribution.

library(shiny)

APP_TITLE <- "Next Word Predictor"

shinyUI(fluidPage(
    # Application title
    titlePanel(APP_TITLE),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h2("Configuration"),
            checkboxInput('showFull', 'Show Probabilities', value = TRUE),
            numericInput('numPredict', 'Number of Candidates to display (1~10)',
                         value = 3, min = 1, max = 10, step = 1),
            br(),
            
            h2("Input"),
            textInput('inputStr',
                      'Input Text String', value="", placeholder="type text string here"),

            htmlOutput("loaded.msg"),
            # Action button to render plot
            actionButton('predictBtn', "Predict!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            textOutput('result.msg'),
            h2("output"),
            h3("Next Word Candidates"),
            # Dynamic parameter inputs based on radio button
            tableOutput("predictTable"),

            h2("User Manual"),
            tabsetPanel(
                tabPanel("Introduction",
                    p("The prediction algorithm is based on training on a large"),
                    p("English language database. ")
                ),
    
                tabPanel("Inputs", p("Describe inputs")),
                
                tabPanel("Predictions", p("Describe prediction table")),

                tabPanel("Source Code & Deployment",
                    p("Full source code of this Shiny app can be found on github at"),
                    p("https://github.com/Roklion/Developing_Data_Products"),
                    p("The app is also deployed online at"),
                    p("https://roklion.shinyapps.io/Developing_Data_Products")
                )
            )
        )
    )
))
