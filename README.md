# sambrook1
Two Action Forced Choice Q Learning
This code is a stripped back version of code developed by Andy Wills for running a version of Nathaniel Daw’s two step task (Daw ND et al. 2011), as implemented by Gillan CM et al. (2015) and then by myself (Sambrook TD et al. 2018) and now held at the catlearn site (https://ajwills72.github.io/catlearn/). It uses the second step of that task. Please be aware that naming conventions are less intuitive than might be expected, and commenting is not always useful since it may in some cases refer to the original version. The original code is very elegant, the modified version, much less so. Additionally, documentation of the code is better for the original. However, if you would like assistance in running it, you can try emailing me at t.sambrook@uea.ac.uk

The code models Q learning in a two-action forced choice task. It fits two parameters, alpha (learning rate) and beta (inverse temperature). It provides trial-by-trial estimates of Q for the chosen action and delta for the outcome.

You should load the R Project in R Studio and ensure that the model folder contains a file named tr_complete.csv containing subject, action and feedback columns as shown in the example file.

Run the script fitBasic.r

This will generate the fitted parameters, with the fits and a report on whether convergence occurred (=0) in a file mdl_fits.csv.

It will generate deltas and Q values in a file eeg_out.csv.

These will look a bit strange in cases where fitting has assigned a subject’s value of alpha to either zero or one. For model-based analysis of imaging data, Daw, among others has recommended using deltas and Q values, not based on individually fitted alphas, but on their median. To do this, first run fitBasic.r and then run refitBasic.r

Daw ND, Gershman SJ, Seymour B, Dayan P, Dolan RJ. 2011. Model-based influences on humans' choices and striatal prediction errors. Neuron. 69:1204-1215.
Gillan CM, Otto AR, Phelps EA, Daw ND. 2015. Model-based learning protects against forming habits. Cogn Affect Behav Ne. 15:523-536.
Sambrook TD, Hardwick B, Wills AJ, Goslin J. 2018. Model-free and model-based reward prediction errors in EEG. Neuroimage. 178:162-171.



