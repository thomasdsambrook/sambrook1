


## Load model implementation and fitting functions
source("model/slpBasic.R")
source("model/refitfuncBasic.R")

## Load model fits
fit.big <- read.csv("model/mdl_fits.csv", stringsAsFactors = FALSE)

## Calculate median values for other parameters
grp.alpha <- median(fit.big$alpha)
grp.beta <- median(fit.big$beta)
grp.p <- 0

## Save console output for records
sink("model/console_out_refit.txt")

## Load participant data
tr.all <- data.frame(read.csv("model/tr_complete.csv", header = TRUE,
                              stringsAsFactors = FALSE))

## Select only the columns we need
tr.all <- tr.all[, c('subject', 's1.act', 't')]

## Determine the set of participants
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
    ## Fit the model
    print(paste("Subject:",ppt))

    eeg.out <- remake.eeg.out(tr)
    ## Store everything
    eeg.big <- rbind(eeg.big, cbind(ppt,eeg.out$eeg))
    fit.big <- rbind(fit.big, c(ppt, eeg.out$fit))
}

colnames(fit.big) <- c('subj', 'alpha', 'beta', 'p')


## Save out
write.csv(eeg.big, file = "model/eeg_out_refit.csv", row.names = FALSE)
write.csv(fit.big, file = "model/mdl_refits.csv", row.names = FALSE)
sink()


