# Script that receives parameters from command line (Rscript)
# and executes MH_MCMC.R
# Example: 
# $ Rscript runMe.R dataFile="../data/OD600_B.csv" w.prior="uniform" n.clones=1 
############################################
# Receives and parses arguments from command line
args <- commandArgs(trailingOnly = TRUE)
if(length(args)>0){
  for (i in 1:length(args) ) {
    arg<-unlist(strsplit(args[i], "="))
    if(arg[1]=="dataFile"){
      dataFile<-arg[2]
    }else if(arg[1]=="runDir"){
      runDir<-arg[2]
    }else if(arg[1]=="w.prior"){
      w.prior<-arg[2]
    }else if(arg[1]=="n.clones"){
      n.clones<-as.numeric(arg[2])
    }else if(arg[1]=="N"){
      N<-as.numeric(arg[2])
    }
  }
}

if(!exists("dataFile"))  stop("dataFile not defined")
if(!exists("w.prior"))  w.prior<-"uniform"
if(!exists("n.clones"))  n.clones<-1
if(!exists("N"))  N<-1e6
if(!exists("runDir")) runDir=paste("../runs/_",format(Sys.time(), "%Y%m%d_%H%M%S"),"_",w.prior,sep="")

#Create output directory if not exists
if (!file.exists(runDir)){
  dir.create(runDir,recursive=TRUE)
  sink(paste(runDir,'/summary.txt', sep = ""), append=TRUE, split=TRUE) 
}

print(noquote(paste("Output Directory: ",runDir)))
print(noquote(paste("Input Data file: ",dataFile)))
print(noquote(paste("Number of iterations: ",N)))
print(noquote(paste("Prior: ",w.prior)))
print(noquote(paste("Number of clones: ",n.clones)))

############################################
# Load data 
ODdata<-read.csv(dataFile)

############################################
# Clone data 
ODdata <- lapply(as.data.frame(ODdata), function(z) rep(z, n.clones))
ODdata <- as.data.frame(ODdata)
ODdata<-ODdata[order(ODdata$t),]

############################################
# Runs MCMC script
start.time <- Sys.time()
print(noquote("*******************************"))
source("MH_MCMC.R")

end.time <- Sys.time()
time.taken <- end.time- start.time
print(noquote("MCMC Done...")) # Execution time
print(noquote(time.taken)) # Execution time

######
# Save variables into a file
save.image(file=paste(runDir,"/MCMC.RData", sep=""))
print(noquote(paste("image saved in ",paste(runDir,"/MCMC.RData", sep="")))) # Execution time
