###########################
## MYSQL SERVER SETTINGS ##
###########################
## MYSQL Database config ##
##    for responses      ##
###########################

library(RMySQL)

        host = "localhost"
        port = 3306
        user =  "root"
        password =  "mysql"
        databaseName = "shinydatabase"
        table = "responses"

# code to test database connection
# mydb <- dbConnect(MySQL(), host=host, port = port, user=user, password=password, dbname=databaseName)
# dbListTables(mydb)

###########################
######  SHINY SERVER ######
###########################

shinyServer(function(input, output, session) {
        
        # The id is captured through the URL (?name=id)
        # query <- parseQueryString(session$clientData$url_search)

        # Welcome message
        output$queryText <- renderText({
                query <- parseQueryString(session$clientData$url_search)
                paste("Hello ", query, ", welcome back to your personal research environment.", sep="")
        })
        
        # Show personal data (based on id)
        output$plot <- renderPlot({
                query <- parseQueryString(session$clientData$url_search)
                source("dummydata.R")
                getplot(query)
        })
        
        # Store respondent feedback
        options(mysql = list(
                "host" = host,
                "user" = user,
                "password" = password,
                "port" = port
        ))
        databaseName <- databaseName
        table <- table
        
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



