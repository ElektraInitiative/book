#
# q <- qplot(cty, hwy, data = mpg, colour = displ)
# q + xlab(expression(beta +frac(miles, gallon)))
# 
# http://www.r-bloggers.com/using-consistent-r-and-latex-fonts-in-org-or-knitr-or-sweave/
#
# http://blog.revolutionanalytics.com/2012/09/how-to-use-your-favorite-fonts-in-r-charts.html
#
# p + annotate("text", x=10, y=40, label="text[subscript]", parse=TRUE)
# 
# label=expression(text[subscript]), parse = TRUE)
#

#pie chart:
#http://mathematicalcoffee.blogspot.co.at/2014/06/ggpie-pie-graphs-in-ggplot2.html

library(ggplot2)
library(plyr)



cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")



data <- read.csv("data.csv")
summary(data)





#
# plot if benchmark
#

ifdata <- data
#ifdata <- data[with(data,  grepl("mountpoint", value)),]

#ifdata <- data[data$value == 'contextual noop',] # specify explicitely
#ifdata$value <- factor(ifdata$value)

g <- ggplot(ifdata, aes(x=value, y=benchmark)) +
#    xlim(rev(levels(ifdata$value))) + # limit plot to a specific part
#    geom_bar() +
     geom_boxplot() +
     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     xlab("") +
     ylab("Execution time (s)")
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "benchmark.pdf", height=4)

