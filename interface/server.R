###########################
## MYSQL SERVER SETTINGS ##
###########################
## MYSQL Database config ##
##    for responses      ##
###########################

library(RMySQL)
Sys.setenv(MYSQL_HOME = "/var/run/")

        host = # localhost
        port = # port
        user =  # user
        password =  # pass
        databaseName = # mySQL database
        table = # tables where answers should be stored


#######################
## define data fiels ##
#######################

fields <- c("response1", "response2")

###########################
######  SHINY SERVER ######
###########################

shinyServer(function(input, output, session) {
        
        # The id is captured through the URL (?name=id)
        # query <- parseQueryString(session$clientData$url_search)

        # Personal welcome message
        output$queryText <- renderText({
                query <- parseQueryString(session$clientData$url_search)
                paste("Hello ", query, ", welcome (back) to your personal research environment.", sep="")
        })
        
        # Show personal data (based on id)
        output$plot <- renderPlot({
                id <- parseQueryString(session$clientData$url_search)
                source("dummydata.R")
                getplot(id)
        })
        
        # Store respondent feedback
        options(mysql = list(
                "host" = host,
                "user" = user,
                "password" = password,
                "port" = port
        ))
        
                saveData <- function(data) {
                        # Connect to the database
                        db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                                        port = options()$mysql$port, user = options()$mysql$user, 
                                        password = options()$mysql$password)
                        # Construct the update query by looping over the data fields
                        query <- sprintf(
                                "INSERT INTO %s (%s) VALUES ('%s')",
                                table, 
                                paste(names(data), collapse = ", "),
                                paste(data, collapse = "', '")
                        )
                        # Submit the update query and disconnect
                        dbGetQuery(db, query)
                        dbDisconnect(db)
                }
                
                loadData <- function() {
                        # Connect to the database
                        db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                                        port = options()$mysql$port, user = options()$mysql$user, 
                                        password = options()$mysql$password)
                        # Construct the fetching query
                        query <- sprintf("SELECT * FROM %s", table)
                        # Submit the fetch query and disconnect
                        data <- dbGetQuery(db, query)
                        dbDisconnect(db)
                        data
                }
        
                # Whenever a field is filled, aggregate all form data
                formData <- reactive({
                        data <- sapply(fields, function(x) input[[x]])
                        data
                })
                
                # When the Submit button is clicked, save the form data
                observeEvent(input$submit, {
                        saveData(formData())
                })
                
                # Show the previous responses
                # (update with current response when Submit is clicked)
                output$responses <- DT::renderDataTable({
                        input$submit
                        loadData()
                })
                
                # confirmation message
                observeEvent(input$submit, {
                        saveData(formData())
                        shinyjs::reset("form")
                        shinyjs::hide("form")
                        shinyjs::show("thankyou_msg")
                })
})



