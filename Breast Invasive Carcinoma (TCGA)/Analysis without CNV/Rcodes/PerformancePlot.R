
#################################
## R-code for Performance Plot ## 
#################################

CVdat = read.delim("../Output/CVerrors.txt",as.is=T,check.names = F)

minError = min(CVdat$CVerror)
minThres = CVdat$Threshold[which(CVdat$CVerror==minError)][1]
genesurv = CVdat$EdgesSelected[which(CVdat$CVerror==minError)][1]

cid = grep("CVerror_", colnames(CVdat))
ll=gsub("CVerror_","",colnames(CVdat)[cid])
legend_lab = c("Overall")
for(i in 1:length(ll)) legend_lab = c(legend_lab, ll[i])
cc = c("black","blue","maroon","green","purple")

sd = sd(CVdat$CVerror[-nrow(CVdat)])
within = CVdat$Threshold[which(abs(CVdat$CVerror)< (minError+sd))]
index = which(CVdat$Threshold>4.8 & CVdat$Threshold<=5)
xcoor = CVdat$Threshold[c(index, index+1)]
ycoor = CVdat$CVerror[match(xcoor,CVdat$Threshold)]
zcoor = CVdat$EdgesSelected[match(xcoor,CVdat$Threshold)]
grad = (ycoor[2] - ycoor[1])/(xcoor[2] - xcoor[1])
c = ycoor[1] - grad*xcoor[1]
xpt = 4.9
ypt = grad*xpt +c

pdf("CVplot_Penalty_noCNV.pdf",height=5, width=7, useDingbats = F)
par(mar=c(3,4,7,2),mai=c(1,1,1,0.5))
plot(CVdat$Threshold,CVdat$CVerror,ylim=c(0,1),type="o",pch=16,col=1,lwd=2, cex.axis=0.8,ylab="Mean misclassification error", xlab="Threshold")
mtext("Edges selected",side=3,line=3)
axis(side = 3,at=CVdat$Threshold, lab=CVdat$EdgesSelected,las=2,srt= 45,cex.axis=0.8)
for(i in 1:length(cid)) lines(CVdat$Threshold, CVdat[,cid[i]], col=cc[i+1],lty=1)
legend("topleft",legend_lab, col=cc,lty=1 ,lwd=c(5,rep(5,length(ll))),cex=0.8)

points(minThres,CVdat$CVerror[match(minThres,CVdat$Threshold)], pch=4,lwd=2,col=2)
points(xpt,ypt, pch=4,lwd=2,col=2)
text(minThres,CVdat$CVerror[match(minThres,CVdat$Threshold)],pos=1, offset=1,lab=paste0("Minimum Threshold = ",paste(round(minThres,3),collapse="\t"),"\nClassification Error = ",round(minError,3),"\nSelected Edges = ",paste(genesurv,collapse="\t")),cex=0.6,las=1)
text(xpt, ypt,pos=3, offset=1,lab="Selected Threshold = 4.9",font =2,cex=0.7,las=1)
abline(h=0.3,lty=2,col="grey40")
text(-0.15,(0.3)+0.02, pos =4, font =2,lab="30% Misclassification error",cex=0.7,col="grey40")

dev.off()


########################################## end #########################################
