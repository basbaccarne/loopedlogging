shinyUI(
        bootstrapPage(
        
                # intro text
                verbatimTextOutput("queryText"),
                
                # content
                p("On this page you can find your personal research data. How would you interpret this?"),
                plotOutput("plot"),
                
                # respondent input
                fluidPage(div(
                        textInput("var1","Variable 1",""),
                        numericInput("var2","Variable 2",""),
                        actionButton("submit","Submit","")
                ))
                
        )
)