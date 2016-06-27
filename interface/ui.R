shinyUI(
        bootstrapPage(
                
                # style
                theme = "flatly.css",
                div(class= "col-lg-12",   
                
                # Title + personal welcome message
                div(
                        class="page-header",
                        h1("Your Digital DNA"),
                        div(class="text-success",
                            verbatimTextOutput("queryText")
                            )
                ),
                
                # Show personal data (based on id)
                p("On this page you can find your personal research data. How would you interpret this?"),
                plotOutput("plot"),
                
                # Store respondent feedback
                shinyjs::useShinyjs(),
                shinyjs::hidden(
                        div(id = "thankyou_msg",
                            div(class="text-success",
                                "Thanks, your response was submitted successfully!"
                                )
                        )
                ),
                
                fluidPage(div(
                        textInput("response1","Question 1",""),
                        textInput("response2","Question 2",""),
                        actionButton("submit","Submit","")
                ))
        ))
)