
### Note takes about an hour to run 35K trial training file
source("model/slpBasic.R")      
source("model/fitfuncBasic.R")      
sink("model/console_out.txt")

tr.all <- data.frame(read.csv("model/tr_complete.csv", header = TRUE, stringsAsFactors = FALSE))              
## Select only the columns we need
tr.all <- tr.all[, c('subject', 's1.act', 't')]
##Create array of subject numbers
subjs <- unique(tr.all$subject)                           

## Main fitting loop
eeg.big <- NULL
fit.big <- NULL

for(ppt in subjs) {
    ## Take out one subject
    tr <- as.matrix(tr.all[tr.all$subject == ppt,])             
    ## Extract participant P(left) for max likelihood fitting   
    p.l <- tr[,'s1.act']                                        
    p.l[p.l == 2] <- 0                                                 
    print(paste("Subject:",ppt))      
                                                                
    eeg.out <- make.eeg.out(tr) 
    ## Store everything
    eeg.big <- rbind(eeg.big, cbind(ppt,eeg.out$eeg))          
    fit.big <- rbind(fit.big, c(ppt, eeg.out$fit))              
}

colnames(fit.big) <- c('subj', 'alpha', 'beta', 'llik', 'conv')
write.csv(eeg.big, file = "model/eeg_out.csv", row.names = FALSE)
write.csv(fit.big, file = "model/mdl_fits.csv", row.names = FALSE)
sink()                                                              

                                                                   
