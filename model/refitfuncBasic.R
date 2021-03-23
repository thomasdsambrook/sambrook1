
remake.eeg.out <- function(tr) {
    
    st <- list(alpha = grp.alpha, beta = grp.beta,
               p = grp.p, q1.mf = c(.5, .5))
    
    out <- slpBasic(st, tr, xtdo = TRUE)

    ## Package it up nicely for EEG analysis

    ## Add training array (needed to determine current s1 action)
    eeg.out <- data.frame(cbind(tr, out$xout))

    ## Add Q values for stage 1 action chosen

    eeg.out$q1.mf.c[eeg.out$s1.act == 1] <- eeg.out$q1.mf.1[eeg.out$s1.act
                                                            == 1]
    eeg.out$q1.mf.c[eeg.out$s1.act == 2] <- eeg.out$q1.mf.2[eeg.out$s1.act
                                                            == 2]
  

    ## Select only the columns wanted for EEG analysis

    eeg.out <- eeg.out[,c('s1.d.mf','q1.mf.c')]
    
    return(list(eeg = eeg.out, fit = c(grp.alpha,grp.beta,grp.p)))
}

