## Define function to minimize                                              
fit.basic <- function(params) { 
    st <- list(alpha = params[1],                      
               beta = params[2],
               p = 0,                                  
               q1.mf = c(.5, .5)
               )
    out <- slpBasic(st, tr, xtdo = FALSE)                             
    ## Log Likelihood calc                                          
    llik <- out$out[,1]                       
    llik[p.l == 0] <- 1 - llik[p.l == 0]                   
    llik[llik < 1e-15] <- 1e-15          # Avoid: log(0) = -Inf    
    llik <- log(llik)                                    
    obj <- sum(llik)                                   
    return(-obj)                           
}

## Define function to return eeg.out for one participant
make.eeg.out <- function(tr) {                               
    
    ## Initial parameter values set at different values to deal with local minima..remove some of these if it is taking too long  
    alpha.iqr <- c(.3, .7) 
    beta.iqr <-  c(3, 7) 
    
      ## Parameter boundaries
      lo     = c(   0,  0)
      hi     = c(   1,  100)

        ## Minimize objective function 
        fit.big <- NULL                                                             
        for(alpha in alpha.iqr) {                                                     
                for(beta in beta.iqr) {
                   params = c(alpha, beta)
                        print("Initial values:")
                        print(params)
                        result <- optim(params, fit.basic,                             
                                        method = 'L-BFGS-B', lower = lo,
                                        upper = hi,
                                        control = list(trace=1))
                        fit.sum <- c(result$par, result$value,
                                     result$convergence)
                        fit.big <- rbind(fit.big, fit.sum)
              
            }
        }
  

    ## Find the best fit (of those that converged)
    fits <- fit.big
    colnames(fits) <- c('alpha', 'beta', 'llik', 'conv')
    row.names(fits) <- NULL
    print("Results of fits:")
    print(fits)
    fits <- data.frame(fits)
    fits <- fits[fits$conv == 0,]
    win.fit <- fits[which.min(fits$llik),]                                      

    ## Generate extended output with best parameters
    params <- c(win.fit$alpha, win.fit$beta)
    st <- list(alpha = params[1], beta = params[2], p = 0, q1.mf = c(.5, .5))
    out <- slpBasic(st, tr, xtdo = TRUE)                                        

    ## Package it up nicely for EEG analysis

    ## Add training array (needed to determine current s1 action)
    eeg.out <- data.frame(cbind(tr, out$xout))

    ## Add Q values for stage 1 action chosen
    eeg.out$q1.mf.c[eeg.out$s1.act == 1] <- eeg.out$q1.mf.1[eeg.out$s1.act == 1]
    eeg.out$q1.mf.c[eeg.out$s1.act == 2] <- eeg.out$q1.mf.2[eeg.out$s1.act == 2]
    
  ## Select only the columns wanted for EEG analysis

    eeg.out <- eeg.out[,c('s1.d.mf', 'q1.mf.c')]                
    
    return(list(eeg = eeg.out, fit = win.fit))
}

