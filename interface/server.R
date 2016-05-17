shinyServer(function(input, output, session) {
        
        # Parse the GET query string
        # Provide data though format url?variable1=value1&variable2=value2
        # In this case ?name=id
        output$queryText <- renderText({
                query <- parseQueryString(session$clientData$url_search)
                
                # Return a string with key-value pairs
                paste("Hello ", query, ", welcome back to your personal research environment.", sep="")
        })
        
        output$plot <- renderPlot({
                source("dummydata.R")
                library(ggplot2)
                data <- getdata()
                qplot(mpg, wt, data = data, colour = as.factor(cyl))
        })
})