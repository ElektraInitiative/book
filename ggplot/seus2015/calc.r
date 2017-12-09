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



data <- read.csv("lookup.csv")
summary(data)


#staticdata <- data[with(data,  grepl("static", value)),]

g <- ggplot(data, aes(x=reorder(value, benchmark, FUN=median), y=benchmark)) +
     ylim(0,0.3) +
#     scale_y_log10() +
#     ylim(0,5.3) +
#    xlim(rev(levels(data$value))) + # limit plot to a specific part
     geom_boxplot() +
#     scale_y_log10() +
#     coord_trans(y = "log10") +
#     scale_y_continuous(formatter='log10') +
     theme(axis.text.x = element_text(angle = 90, hjust = 1),
       axis.text.x = element_text(colour="black"),
       axis.text.y = element_text(colour="black")
	   ) +
     scale_colour_manual(values=cbbPalette) +
     xlab("") +
#     coord_flip() +
     ylab("Execution time (s)")
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "lookup.pdf", height=4)



data <- read.csv("piweb.csv")
summary(data)

g <- ggplot(data, aes(x=num)) +
     ylim(0,151) +
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
     #scale_x_continuous(breaks=c(1,11,21,31,41,51,61,71,81,91,101)) +
     xlab("Layer activations per millisecond (1/ms)") +
     ylab("Number per second (1/s)") +
     theme(
       legend.title=element_blank(),
       axis.text.x = element_text(colour="black"),
       axis.text.y = element_text(colour="black")
     )
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "piweb.pdf", height=4)





data <- read.csv("lock.csv")
summary(data)

g <- ggplot(data, aes(x=num)) +
     ylim(0,6001) +
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
     xlab("Lock-free time (ms)") +
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
     geom_line(aes(y = with, colour = "with")) +
     geom_point(aes(y = with, colour = "with", shape="with"), size=2) +
     geom_line(aes(y = switch, colour = "switch")) +
     geom_point(aes(y = switch, colour = "switch", shape="switch"), size=2) +
     scale_colour_manual(values=cbbPalette) +
     #geom_line(aes(y = time, colour = "time")) +
     #geom_line(aes(y = errors, colour = "errors")) +
     #geom_point(aes(y = errors), size=2) +
     #geom_line(aes(y = time, colour = "time")) +
     #geom_point(aes(y = time), size=2) +
     #theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     scale_x_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9)) +
     xlab("Number of connected contextual values") +
     ylab("Execution time (s)") +
     theme(
       axis.text.x = element_text(colour="black"),
       axis.text.y = element_text(colour="black"),
	   legend.title=element_blank())
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "switch.pdf", height=4)

