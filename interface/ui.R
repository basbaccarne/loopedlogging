shinyUI(
        bootstrapPage(
        
                verbatimTextOutput("queryText"),
                p("On this page you can find your personal research data. How would you interpret this?"),
                plotOutput("plot")
        )
)