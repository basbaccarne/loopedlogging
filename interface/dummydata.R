library(ggplot2)

getplot <- function(id){
        data(mtcars)
        g <- qplot(mpg, wt, data = mtcars, colour = as.factor(cyl))
        g + ggtitle(paste("plot for ", id, sep=""))
}
