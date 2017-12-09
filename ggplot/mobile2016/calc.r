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



data <- read.csv("lock.csv")
summary(data)

g <- ggplot(data, aes(x=num)) +
     ylim(0,2201) +
     xlim(0,10) +
     scale_x_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9)) +
#    xlim(rev(levels(data$value))) + # limit plot to a specific part
#    geom_bar() +
#     geom_boxplot() +
     #geom_line(aes(y = request, colour = "request")) +
     #geom_point(aes(y = request), size=2) +
     geom_line(aes(y = request, colour = "request")) +
     geom_point(aes(y = request, colour = "request"), shape=1, size=2.5) +
     geom_line(aes(y = reply, colour = "reply")) +
     geom_point(aes(y = reply, colour = "reply"), shape=1, size=2) +
     scale_colour_manual(values=cbbPalette) +
     #geom_line(aes(y = errors, colour = "errors")) +
     #geom_point(aes(y = errors), size=2) +
     #geom_line(aes(y = time, colour = "time")) +
     #geom_point(aes(y = time), size=2) +
     #theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     #scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10)) +
     xlab("Sync time (ms)") +
     ylab("Number per second (1/s)") +
     theme(
       axis.text.x = element_text(colour="black"),
       axis.text.y = element_text(colour="black"),
	   legend.title=element_blank())
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "lock.pdf", height=4)



data <- read.csv("switch.csv")
summary(data)

g <- ggplot(data, aes(x=number)) +
#     ylim(0,5.3) +
#    xlim(rev(levels(data$value))) + # limit plot to a specific part
#     geom_boxplot() +
     geom_line(aes(y = sync, colour = "sync")) +
     geom_point(aes(y = sync, colour = "sync", shape="sync"), size=2) +
     geom_line(aes(y = reload, colour = "reload")) +
     geom_point(aes(y = reload, colour = "reload", shape="reload"), size=2) +
     geom_line(aes(y = activate, colour = "activate")) +
     geom_point(aes(y = activate, colour = "activate", shape="activate"), size=2) +
     geom_line(aes(y = cv, colour = "activate cv")) +
     geom_point(aes(y = cv, colour = "activate cv", shape="activate cv"), size=2) +
     scale_colour_manual(values=cbbPalette) +
     #geom_line(aes(y = time, colour = "time")) +
     #geom_line(aes(y = errors, colour = "errors")) +
     #geom_point(aes(y = errors), size=2) +
     #geom_line(aes(y = time, colour = "time")) +
     #geom_point(aes(y = time), size=2) +
     #theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     scale_x_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9)) +
     #scale_y_log10() + #todo: breaks?
     xlab("Number of layer activations") +
     ylab("Execution time (s)") +
     theme(
       axis.text.x = element_text(colour="black"),
       axis.text.y = element_text(colour="black"),
       legend.title=element_blank())
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "switch.pdf", height=4)

dev.off()
