shinyServer(function(input, output, session) {
        
        # Parse the GET query string
        # Provide data though format url?variable1=value1&variable2=value2
        # In this case ?name=id
        output$queryText <- renderText({
                query <- parseQueryString(session$clientData$url_search)
                
                # Return a string with key-value pairs
                paste("Hello ", query, ", welcome back to your personal research environment.", sep="")
        })
        
        # Fetch the plot/data related to the ID in the url
        output$plot <- renderPlot({
                source("dummydata.R")
                library(ggplot2)
                data <- getdata()
                qplot(mpg, wt, data = data, colour = as.factor(cyl))
        })
        
        # Store respondent feedback
        library(RMySQL)
        
        options(mysql = list(
                "host" = "localhost",
                "user" = "root",
                "password" = "mysql"
        ))
        databaseName <- "shinydatabase"
        table <- "responses"
        
        saveData <- function(data) {
                # Connect to the database
                db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                                port = options()$mysql$port, user = options()$mysql$user, 
                                password = options()$mysql$password)
                # Construct the update query by looping over the data fields
                query <- sprintf("INSERT INTO %s (%s) VALUES ('%s')", table,input$var1,input$var2)
                print(query)
                # Submit the update query and disconnect
                dbGetQuery(db, query)
                dbDisconnect(db)
        }
        
        loadData <- function() {
                # Connect to the database
                db <- dbConnect(MySQL(), dbname = databaseName, host =    options()$mysql$host, 
                                port = options()$mysql$port, user = options()$mysql$user, 
                                password = options()$mysql$password)
                # Construct the fetching query
                query <- sprintf("SELECT * FROM %s", table)
                # Submit the fetch query and disconnect
                data <- dbGetQuery(db, query)
                dbDisconnect(db)
                data
                
        }
})