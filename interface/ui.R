shinyUI(
        bootstrapPage(
                
                # style
                theme = "flatly.css",
                div(class= "col-lg-12",   
                
                # Title + personal welcome message
                div(
                        class="page-header",
                        h1("YOUR DIGITAL DNA"),
                        div(class="text-success",
                            verbatimTextOutput("queryText")
                            )
                ),
                
                # Show personal data (based on id)
                div (
                        class="data",
                        p("On this page you can find your personal research data. How would you interpret this?"),
                        dateInput("date", 
                          label = h3("Date input"), 
                          value = "2013-03-15"), 
                         plotOutput("plot")
                ),
                
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
                )),
                
                # Footer
                div(class= "footer",
                        p("Made by ", 
                                a("Bas Baccarne", 
                                  href = "http://www.ugent.be/ps/communicatiewetenschappen/en/research/mict/contact/team/bas-baccarne"),
                                "and ", 
                                a("Karel Verbrugge", 
                                  href = "http://www.ugent.be/ps/communicatiewetenschappen/en/research/mict/contact/team/karel-verbrugge")),
                        
                        p("Powered by",
                                a("iMinds - MICT - Ugent", 
                                  href = "http://www.ugent.be/ps/communicatiewetenschappen/en/research/mict")),
                        
                    a(href = "http://www.iminds.be/", img(src="http://www.ugent.be/ps/img/communicatiewetenschappen/mict/pictogrammen-logos/logo-iminds-klein", height = 20, width = 77, margin = 40)),
                    a(href = "https://github.com/basbaccarne/loopedlogging", img(src="git.png", height = 40, width = 40, align = "right", class = "right-footer"))
                )
        ))
)