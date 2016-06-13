shinyUI(
        bootstrapPage(
        
                # Welcome message
                verbatimTextOutput("queryText"),
                
                # Show personal data (based on id)
                p("On this page you can find your personal research data. How would you interpret this?"),
                plotOutput("plot"),
                
                # Store respondent feedback
                fluidPage(div(
                        textInput("var1","Variable 1",""),
                        numericInput("var2","Variable 2",""),
                        actionButton("submit","Submit","")
                ))
                
        )
)