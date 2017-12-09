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

library(ggplot2)
library(plyr)

data <- read.csv("data.csv")
summary(data)





#
# plot if benchmark
#

#ifdata <- data
ifdata <- data[with(data,  grepl("if", value)),]

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

ggsave(filename = "benchmarkif.pdf", height=4)






#
# plot with benchmark
#

#withdata <- data
withdata <- data[with(data,  grepl("with", value)),]

#withdata <- data[data$value == 'contextual noop',] # specwithy explicitely
#withdata$value <- factor(withdata$value, levels=c("1", "2", "3", "6", "8", "4"))

g <- ggplot(withdata, aes(x=value, y=benchmark)) +
#    xlim(rev(levels(withdata$value))) + # limit plot to a specific part
     geom_boxplot() +
     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     xlab("") +
     ylab("Execution time (s)") +
     ylim(27.125, 27.185)

ggsave(filename = "benchmarkwith.pdf", height=4)





#
# plot cmp benchmark
#

#cmpdata <- data
cmpdata <- data[with(data,  grepl("cmp", value)),]

#cmpdata <- data[data$value == 'contextual noop',] # speccmpy explicitely
#cmpdata$value <- factor(cmpdata$value, levels=c("1", "2", "3", "6", "8", "4"))

g <- ggplot(cmpdata, aes(x=value, y=benchmark)) +
#    xlim(rev(levels(cmpdata$value))) + # limit plot to a specific part
     geom_boxplot() +
     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     xlab("") +
     ylab("Execution time (s)") +
     ylim(27.125, 27.185)

ggsave(filename = "benchmarkcmp.pdf", height=4)
