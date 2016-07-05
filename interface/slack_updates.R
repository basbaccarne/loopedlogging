# preparation:
# (1) login to slack team
# (2) build > custom integration > incoming webhook (copy webhook url from there)

require(httr)

slackPost <- function(message){
        
        # global parameters
        source("config.R")
        
        # POST to slack
        body = list(
                channel = channel, 
                username = username, 
                text = message, 
                icon_emoji = icon_emoji 
        )
        POST(url, body = body, encode = "json")  
}