require(ggplot2)
require(xts)
require(reshape2)

# from http://www.r-bloggers.com/plotting-git-statistics/

options(scipen=5)

#setwd('/home/git/Rproject/gitStats/') 
#Sys.setenv(TZ="GMT")
tmp=as.matrix(read.table('history.csv',sep=',',header=FALSE))
commits=xts(cbind(as.double(tmp[,4]),as.double(tmp[,5])),order.by=as.POSIXct(strptime(tmp[,2],'%Y-%m-%d %H:%M:%S')))

colnames(commits)=c('Getenv','LOC')

getenv=data.frame(Date=as.Date(index(commits)),Getenv=as.numeric(commits$Getenv))
getenv=melt(getenv,id.vars=c('Date'))

loc=data.frame(Date=as.Date(index(commits)),LOC=as.numeric(commits$LOC))
loc=melt(loc,id.vars=c('Date'))

#png('gitStats.png',width=500)
pdf('history.pdf',, width=6, height=3)
print(ggplot(getenv,aes(Date,value,color=variable))+
	#geom_jitter(data=getenv, alpha=.65,size=3) +
	#geom_line (data=getenv, alpha=.95) +
	#geom_line (data=loc, alpha=.95) +
	geom_smooth (data=getenv) +
# wrong:
# geom_vline(xintercept = 14144) +   # for wget
# geom_vline(xintercept = 14365) +   # for chromium
	guides(colour=FALSE) +
	ylab("Lines of code")
	)
dev.off()
#?trans_new
#scale_y_continuous(limits = c(0, 100)) +
