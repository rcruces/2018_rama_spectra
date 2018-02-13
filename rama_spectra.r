####################################################################################### title: "Rama Spectra Analysis"
# author: "Raúl Rodríguez-Cruces"
# raulrcruces@inb.unam.mx
######################################################################################

#--------------------------------------------
#### Step 1: Data reading & ordering  ####
#--------------------------------------------
# The first steps only uploads the `xlsx` file and concatenates each sheet into one woorkbook.

# PACKAGES
#----------------------------
# This code requires the previous installation of the following R-packages: lazyeval, ggplot2, hyperSpec, baseline, gplots, rJava & xlsx
# java JDK should be installed for xlsx package to work properly

require("xlsx")        # Read xlsx documents
require("hyperSpec")   # For spectrum analysis
require("baseline")    # For baseline analysis
require("gplots")      # Package for ploting heatmaps

# Set path 
setwd("/home/rr/git_here/rama_spectra/")  # <<--CHANGE THIS for your local path

# Loads the xlsx file to java object
wb <- loadWorkbook("./Data-Raman_Raul.xlsx")

# Get the number of sheets
sheets<-length(getSheets(wb))

# Obtains all the data into a list of data.frames
spectros<-list()
for (i in 1:sheets) {
  print(paste("READING sheet",i,"..."))
  spectros[[i]] <- data.frame(read.xlsx("./Data-Raman_Raul.xlsx", i))  # read Workbook sheet i
}

# Merge all sheets (merges list) into one data.frame and reverse the order (sort by wavelenght)
all_spec<-Reduce(function(...) merge(..., all=TRUE), spectros)

# Data frames for analysis
wavelengt<-all_spec$Raman.Shift
raw_data<-all_spec[2:60]
corr_data<-raw_data

# removes unnecessary variables
rm(wb,spectros,sheets,i)

#--------------------------------------------
#### Baseline Correction ####
#--------------------------------------------
n=length(corr_data[1,])
for (i in 1:n) {
  corrected <- new ("hyperSpec", spc = raw_data[,i], wavelength = wavelengt)
  bl <- baseline (corrected [[]], method="als", lambda=6, p=0.01)
  corrected [[]] <- getCorrected (bl)
  corr_data[i]<-as.vector(corrected[[]])
  rm(corrected) 
  if (i == 1) {Base<-bl@baseline}}
# plots
  par(mfrow=c(1,2))
  plot(wavelengt,raw_data[,1],type='l',main="Raw Data",ylab="Amplituded",bty='l')
  lines(wavelengt,Base,col="red")
  plot(wavelengt,corr_data[,1],type='l',main="Baseline Corrected",ylim=c(0,1500),ylab="Amplituded",bty='l')


#--------------------------------------------  
#### Signal to Noise Ratio  ####
#--------------------------------------------
  snr<-apply(corr_data,2,mad)/apply(corr_data,2,sd)
  barplot(snr,ylab="ratio",main="Signal to Noise",xlab="",col=c(rep("dodgerblue",30),rep("firebrick1",29)),border = c(rep("dodgerblue4",30),rep("firebrick3",29)))
  abline(h=0.4,lty=2,lwd=2,col="red")


#--------------------------------------------
#### Smoothing of the signal  #### 
#--------------------------------------------
  par(mfrow=c(1,2))
  # 1 Non-linear Nadaraya-Watson Kernel
    y<-corr_data[,1]
    NyWt<-ksmooth(wavelengt, y, "normal", bandwidth = 5)
    plot(wavelengt,y,type='l',main="Nadaraya-Watson Kernel",ylim=c(0,1500),ylab="Amplituded",bty='l',lwd=.5)
    lines(NyWt$x,NyWt$y,lwd=1.5,col="red")
    
  # fft with convolution
    Han <- function(y) # Hanning, circular open filter
    convolve(y, rep(0.2,5), type = "open")
    plot(wavelengt,y,type='l',main="fft with Convolution",ylim=c(0,1500),ylab="Amplituded",bty='l',lwd=.5)
    lines(wavelengt,Han(y)[3:872], col = "red",lwd=1.5)
    
# Smoothing
Smooth=list()
for (i in 1:n) {
  y<-corr_data[,i]
  Smooth[[i]]<-ksmooth(wavelengt, y, "normal", bandwidth = 5)[[2]]
}
x<-ksmooth(wavelengt, y, "normal", bandwidth = 5)[[1]]

#---------------------------------------------------------------
#### Normalization of the data & Peak detection  #### 
#---------------------------------------------------------------
  # Normalization with Mean Absolute Deviation 
    smth<-Smooth[[1]]
    MAD<-sapply(smth,simplify=TRUE, function (x) (x-median(smth))/mad(smth))
    
    N<-dim(corr_data)
    spect.fit<-matrix(data = 0,nrow = N[2],ncol = N[1])
    for (i in 1:n) {
      smth<-Smooth[[i]]
       spect.fit[i,]<-sapply(smth,simplify=TRUE, function (x) (x-median(smth))/mad(smth))
    }
    
    # First peak detection
    peaks<-MAD
    peaks[peaks < 2] <- 0
    
    # Find Peaks Coordinates
    peaks.coord<-cbind(which(diff(sign(diff(peaks)))==-2)+1,peaks[which(diff(sign(diff(peaks)))==-2)+1])
    
    # plot
    plot(x,MAD,type='l',main="Normalization with MAD",ylab="Amplituded",bty='l',lwd=.5)
    abline(h=c(0,2),lwd=1.5,lty=c(2,1),col="red")
    lines(x,peaks,col="blue")
    points(x[peaks.coord[,1]],peaks.coord[,2],col="red4",bg="red",pch=21,lwd=1.5)
 
#--------------------------------------------
#### Heatmap of all cases  #### 
#--------------------------------------------
# grupos
grupos<-c(rep("c1",6),rep("c2",6),rep("c3",6),rep("c4",6),rep("c5",6),
          rep("e1",6),rep("e2",6),rep("e3",6),rep("e4",6),rep("e5",5))
# following code limits the lowest and highest color to 5%, and 95% of your range, respectively
quantile.range <- quantile(spect.fit, probs = seq(0, 1, 0.01))
palette.breaks <- seq(quantile.range["5%"], quantile.range["95%"], 0.1)

# Find optimal divergent color palette (or set own)
color.palette  <- matlab.dark.palette(length(palette.breaks) - 1)
colG<-c("lightskyblue","deepskyblue","dodgerblue2","dodgerblue4","navy","red","firebrick2","firebrick3","firebrick","firebrick4")
require(gplots)
a<-which(grupos=="c1")
heatmap.2(spect.fit,
          main = "Pulmonary Lobe spectra",
          density.info="none",  
          trace="none",
          key.title = "",
          dendrogram='none',
          Rowv=FALSE,
          Colv=FALSE,
          RowSideColors = colG[as.factor(grupos)],
          col    = color.palette,
          breaks = palette.breaks,
          labRow =names(corr_data),
          labCol = rep("",length(870))
)

  
#--------------------------------------------  
#### Detection of duplicated data & Heatmap of Non-duplicated data ####   
#--------------------------------------------
# Find Duplicates
# Data frame of the first line
df <- data.frame(a = as.numeric(raw_data[1,]))
# Location of the duplicates
C<-which(duplicated(df) | duplicated(df[nrow(df):1, ])[nrow(df):1])
# Order of the duplicates
C<-colnames(sort(raw_data[1,C]))
# Removes duplicates
a<-as.numeric(names(table(as.numeric(raw_data[1,C]))))
a<-match(a,as.numeric(raw_data[1,C]))
C<-C[-a]
# Vector of repeated columns
a<-match(C,colnames(corr_data))

# Heatmap of Unique values
heatmap.2(spect.fit[-a,],
          main = "Pulmonary Lobe spectra",
          density.info="none",  
          trace="none",
          key.title = "",
          dendrogram='none',
          Rowv=FALSE,
          Colv=FALSE,
          col    = color.palette,
          breaks = palette.breaks,
          labRow =names(corr_data[-a]),
          labCol = rep("",length(870))
)

#-------------------------------------------- 
#### Control vs Experiment spectra  #### 
#--------------------------------------------
# AVERAGE CONTROL vs EXPERIMENTS
# PLot the controls
y<-apply(spect.fit[31:59,],2,mean)
y1<-apply(spect.fit[1:30,],2,mean)
Std<-2
plot(x,y,type='l',ylim=c(0,45),lwd=1.5,plt=2,col="white",xlab="",ylab="",
     xaxt='n',bty='n',axes = F)
polygon(c(350,350,2040,2040,350),c(-2,Std,Std,-2,-2),col="gray85",border = NA)
abline(h=c(5,15,30),col="gray85",lwd=1.5)
abline(h=0,col="gray55",lwd=1.5)
mtext("Control vs Experimental",3,cex = 2.5)
axis(2,c(5,15,30),line = NA,las=2,tick = F,pos=350,cex.axis=1.5)
axis(1,seq(650,1650,250),line = NA,las=1,tick = F,cex.axis=1.5,pos = -1.5)
mtext("normalized a.u.",2,cex = 1.5,line = 2.5,at = 20)
mtext("wavelength",1,cex = 1.5,line = 2.5,at = 1300)
Diff<-rbind(cbind(x,y1),cbind(rev(x),rev(y)),cbind(x[1],y1[1]))
polygon(Diff,col="#EEB422C8",border = NA)
lines(x,y,col=colG[10],lwd=1.5)
lines(x,y1,col=colG[5],lwd=1.5)

#--------------------------------------------
#### Spectral comparison Comparison  #### 
#--------------------------------------------


