
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

## CUstomize libraries
if (!exists("CONFIG.LOADED")) source("Config.R")
source("CleanAlgo.R")
source("Predict.R")

shinyServer(function(input, output) {
    output$loaded.msg = renderUI({
        withProgress(message = "Loading Prediction Tool. Please wait!", value = 1, {
            load.data(filename = file.predict.tb, path = source.path)
        })
        
        helpText("Prediction Tool is ready!")
    })
    
    # Monitoring action button on UI
    observeEvent(input$predictBtn, {
        validate(
            need(!is.null(input$numPredict), "Please enter an integer (1~10)"),
            need(!is.null(input$inputStr), "Please enter some text for prediction")
        )
        
        withProgress(message = "", value = 0, {
            incProgress(0.33, detail = "Cleaning input text...")
            inputs.clean <- clean.algo(input$inputStr, FALSE, "english")
            
            incProgress(0.67, detail = "Reading crystal ball...")
            raw.predict <- sapply(X = inputs.clean, FUN = get.next,
                                  simplify = FALSE, USE.NAMES = TRUE)
            
            incProgress(1, detail = "Organize predictions...")
            predictions <- sort(unlist(clean.predict(raw.predict[[1]])), decreasing = TRUE)
            # Check validity of output
            if (!is.null(predictions) && length(predictions)){
                if(input$showFull) {
                    output$predictTable <- renderTable(
                        {df <- data.frame(t(predictions[1:input$numPredict]*100))
                         row.names(df) <- ("Probability (%)")
                         df},
                        bordered = TRUE, rownames = TRUE, colnames = TRUE)
                } else {
                    output$predictTable <- renderTable(
                        {df <- data.frame(t(names(predictions)[1:input$numPredict]))
                         row.names(df) <- ("Prediction:")
                         df},
                        bordered = TRUE, rownames = TRUE, colnames = FALSE)
                }
                output$result.msg <- renderText("Prediction Done!")
                
            } else {
                output$result.msg <- renderText("Prediction failed! Please try different inputs.")
            }
        })
    })
})

