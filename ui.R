
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
                    p("This is a light-weighted Shiny App built for presenting the prediction algorithm to predict the next word."),
                    p("The prediction algorithm is based on training on a large English language database."),
                    p("The prediction model relies on the assumption that frequency and sequence of the sentences in the language database is a good representation"),
                    p("of English language."),
                    p(" "),
                    
                    h3("Inputs and Configurations"),
                    p("Once the loading bar disappears and message 'Prediction Tool is ready!' shows below the 'Input Text String' box, it means the model has been"),
                    p("loaded and ready for prediction. User can then input the string for predicting the possible next word."),
                    p("Before start predicting, the user can use the 'Configuration' section to choose wether show probability of each word appearing next, as well as"),
                    p("total number of results showing."),
                    p(" "),
                    
                    h3("Predictions"),
                    p("By clicking 'Predict!' below the input box, the prediction algorithm will pick up the string user input and start generating results. Once the"),
                    p("loading bar on the bottom right corner fully progresses and disappears. The result will show on the top right section of the App page."),
                    p("If the prediction failed, due to insufficient data in the database or invalid input string, a message will pop up above the output section to"),
                    p("indicate the failure. Otherwise, the message will read 'Prediction Done!' and prediction will show in form of table. The information in the table"),
                    p("is based on user's configuration (number of results and whether to show probability).")
                ),
                
                tabPanel("Source Code & Deployment",
                    p("Full source code of this Shiny app can be found on github at"),
                    p("https://github.com/Roklion/Data_Capstone"),
                    p("The app is also deployed online at"),
                    p("https://roklion.shinyapps.io/Data_Capstone")
                )
            )
        )
    )
))
