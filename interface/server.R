# Load MYSQL config
library(RMySQL)
Sys.setenv(MYSQL_HOME = "/var/run/")
source("config.R")

# (dev only) test database connection
# mydb <- dbConnect(MySQL(), host=host, port=port, user=user, password=password, dbname=databaseName)
# dbListTables(mydb)
# dbListFields(mydb, table)
# dbReadTable(mydb, table)

# Define data fields
fields <- c("id","response1", "response2")

###########################
######  SHINY SERVER ######
###########################

shinyServer(function(input, output, session){
        source("slack_updates.R")
        
        # The id is captured through the URL (?name=id)
        # query <- parseQueryString(session$clientData$url_search)
        
        # Personal welcome message
        output$queryText <- renderText({
                query <- parseQueryString(session$clientData$url_search)
                paste("Hello ", query, ", welcome (back) to your personal research environment.", sep ="")
        })
        
        # Show personal data (based on id and day input)
        output$plot <- renderPlot({
                id <- parseQueryString(session$clientData$url_search)
                day <- as.character(input$date)
                source("getdata.R")
                getplot(id, day)
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
                db <-
                        dbConnect(
                                MySQL(), dbname = databaseName, host = options()$mysql$host,
                                port = options()$mysql$port, user = options()$mysql$user,
                                password = options()$mysql$password
                        )
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
                db <-
                        dbConnect(
                                MySQL(), dbname = databaseName, host = options()$mysql$host,
                                port = options()$mysql$port, user = options()$mysql$user,
                                password = options()$mysql$password
                        )
                # Construct the fetching query
                query <- sprintf("SELECT * FROM %s", table)
                # Submit the fetch query and disconnect
                data <- dbGetQuery(db, query)
                dbDisconnect(db)
                data
        }
        
        # Whenever a field is filled, aggregate all form data
        formData <- reactive({
                data <- sapply(fields, function(x)
                        input[[x]])
                data$id <- unlist(parseQueryString(session$clientData$url_search))
                data
        })
        
        # When the Submit button is clicked, save the form data (+ push to Slack)
        observeEvent(input$submit, {
                saveData(formData())
                slackPost(
                        paste(
                                "`", Sys.time(), "` - `",
                                parseQueryString(session$clientData$url_search), "` ",
                                "answered `",
                                input$response1,"` and `",
                                input$response2,"`",
                                sep = ""
                        )
                )
        })
        
        # Show the previous responses
        # (update with current response when Submit is clicked)
        output$responses <- DT::renderDataTable({
                input$submit
                loadData()
        })
        
        # confirmation message
        observeEvent(input$submit, {
                shinyjs::reset("form")
                shinyjs::hide("form")
                shinyjs::show("thankyou_msg")
        })
})
