choice.rule <- function(qs, rpt, beta, p) { 
    vals <- exp(qs * beta + p * rpt)
    return(vals/sum(vals))
}

slpBasic <- function(st, tr, xtdo = FALSE) { 
    ## Initialize variables
    out <- array(0,dim= c(nrow(tr),2)) 
    q1.mf <- c(0,0)
    rpt <- c(0,0)
    xout <- NULL                      
    ## Run through training list
    for(i in 1:nrow(tr)) {                  
        ## Read action, state, and reward for current trial
        s1.act <- tr[i,'s1.act']      
        t <- tr[i,'t']
        ## Track repeated of previous action for perseveration
        if(i>1) {
            prev.act <- tr[i-1,'s1.act']               
            rpt <- c(0,0)                              
            if(s1.act == prev.act) rpt[prev.act] <- 1   
        }                                              
        
        ## Record response probabilities
        out[i,] <- choice.rule(st$q1.mf, rpt, st$beta, st$p)            
        ## Calculate MF delta                
        s1.d.mf <- t - st$q1.mf[s1.act]     
        ## Calculate stuff the model doesn't use (but might be handy as neural regressors)
        if(xtdo) {     
            }
        ## Update S1 QMF
        st$q1.mf[s1.act] = st$q1.mf[s1.act] + st$alpha * s1.d.mf  
        
        ## Extended output
        if(xtdo) {
            xout <- rbind(xout, cbind(t(st$q1.mf), s1.d.mf))
        }
    }
    if(xtdo) {
        rownames(xout) <- 1:nrow(xout)
        colnames(xout) <- c('q1.mf.1', 'q1.mf.2', 's1.d.mf')
        fout <- list(out = out, q1.mf = st$q1.mf, xout = xout)
    } else {
        fout <- list(out = out, q1.mf = st$q1.mf)
    }
    return(fout)                                                 
}
