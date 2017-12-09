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




data <- read.csv("data.csv")
summary(data)


staticdata <- data[with(data,  grepl("static", value)),]

g <- ggplot(staticdata, aes(x=value, y=benchmark)) +
     ylim(0,5.3) +
#    xlim(rev(levels(staticdata$value))) + # limit plot to a specific part
#    geom_bar() +
     geom_boxplot() +
     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     xlab("") +
     ylab("Time [s]")
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "static.pdf", height=4)







dynamicdata <- data[with(data,  grepl("dynamic", value)),]

g <- ggplot(dynamicdata, aes(x=value, y=benchmark)) +
     ylim(0,5.3) +
#    xlim(rev(levels(dynamicdata$value))) + # limit plot to a specific part
#    geom_bar() +
     geom_boxplot() +
     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     xlab("") +
     ylab("Time [s]")
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "dynamic.pdf", height=4)




combineddata <- rbind(staticdata, dynamicdata)

g <- ggplot(combineddata, aes(x=value, y=benchmark), group=group, col=group, fill=group) +
     ylim(0,5.3) +
#    xlim(rev(levels(dynamicdata$value))) + # limit plot to a specific part
#    geom_bar() +
     geom_boxplot() +
     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
     xlab("") +
     ylab("Time [s]")
     #ylab("log10(Time [s])") +
     #scale_y_log10()

ggsave(filename = "combined.pdf", height=4)




mean <- read.csv("mean.csv")
summary(mean)

ggplot(mean, aes(x)) +
  geom_line(aes(y = static, colour = "static")) +
  geom_line(aes(y = dynamic, colour = "dynamic")) +
  scale_x_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9,10)) +
  scale_y_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9,10)) +
  xlab("Link Depth") +
  ylab("Time [s]") +
  theme(
    legend.title=element_blank()
    )

ggsave(filename = "mean.pdf", height=4)




mean <- read.csv("mean2.csv")
summary(mean)


#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
cbPalette <- c("#999999", #gray
	       "#56B4E9", #blue
	       "#009E73", #green
	       "#E69F00", #orange
	       "#F0E442"  #yellow
	      )


ggplot(mean, aes(x)) +
  geom_line(aes(y = static, colour = "frontend")) + #static
  geom_point(aes(y = static), size=2) +
  geom_line(aes(y = dynamic, colour = "backend")) +  #dynamic
  geom_point(aes(y = dynamic), size=2) +
  scale_x_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9,10)) +
  scale_y_continuous(breaks=c(0,1,2,3,4,5,6,7,8,9,10)) +
  xlab("Number of properties override") +
  ylab("Execution time (s)") +
  theme(
    legend.title=element_blank()
    )

ggsave(filename = "mean2.pdf", height=4)





wcdata <- read.csv("wc.csv")
summary(wcdata)

wc <- ggplot(wcdata, aes(x=1, y=value, fill=name)) +
     xlab("") +
     ylab("") +
     theme(
#	  axis.line=element_blank(),
#	  axis.text.x=element_blank(),
#	  axis.text.y=element_blank(),
	  axis.ticks=element_blank(),
	  axis.title.x=element_blank(),
	  axis.title.y=element_blank(),
	  axis.text.y=element_blank(),
#	  legend.position="none",
#	  panel.background=element_blank(),
#	  panel.border=element_blank(),
#	  panel.grid.major=element_blank(),
#	  panel.grid.minor=element_blank(),
	  plot.background=element_blank()
     ) +
     guides(fill=guide_legend(title=NULL)) +
     geom_bar(width = 1, stat="identity")

y.breaks <- cumsum(wcdata$value) - wcdata$value/2
y.breaks = numeric()
#[1]  32.0925  73.1045  87.7270  95.9325 100.1710
y.breaks[1] <- 42.0925
y.breaks[2] <- 66.5045
y.breaks[3] <- 87.7270
y.breaks[4] <- 94.9325
y.breaks[5] <- 100.1710
y.breaks

wc <- wc +
      theme(axis.text.x=element_text(color='black')) +
      scale_y_continuous(
			 breaks=y.breaks,   # where to place the labels
			 labels=wcdata$name # the labels
			) +
      scale_fill_manual(values=cbPalette)


wc + coord_polar(theta = "y")

ggsave(filename="wc.pdf", height=4)


# without csv:
#df <- data.frame(
#  variable = c("resembles", "does not resemble"),
#  value = c(80, 20)
#)
#ggplot(df, aes(x = "", y = value, fill = variable)) +
#  geom_bar(width = 1, stat = "identity") +
#  scale_fill_manual(values = c("red", "yellow")) +
#  coord_polar("y", start = pi / 3) +
#  labs(title = "Pac man")
