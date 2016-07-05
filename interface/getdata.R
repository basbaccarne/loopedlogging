require(ggplot2)

# id format = number
# day format = character, "2013-03-15"

getplot <- function(id, day){
        
        # data preparation
        data <- read.csv("../preprocessing/dummydata.csv",sep=";")
        names(data) <- c("id", "time", "day", "foregroundapp", "duration_sec", "signal_strength", "MOSvideo")
        data$time <- strptime(data$time, "%d/%m/%Y %H:%M")
        data <- data[,c(1, 2, 4, 5)]
        
        # data selection (ID based)
        id_data <- data[data$id==id,]
        
        # data selection (day based)
        id_day_data <- id_data
        id_day_data$day <- as.Date(id_day_data$time)
        id_day_data <- id_day_data[id_day_data$day==as.Date(day),]

        # data visualisation
        g <- ggplot(
                data = id_day_data,
                aes(time, foregroundapp)
        )
        g <- g + 
                geom_point(aes(color=foregroundapp, size=10, alpha=.5)) +
                theme(legend.position="none") + 
                ggtitle(paste("plot for test user ", id, " at ", day, sep=""))
        g
}
