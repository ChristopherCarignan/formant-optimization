# formant-optimization
Praat script for automatic formant optimization

This Praat script provides an automated optimzation of formant values F1-F5 by iterating through a range of possible formant ceiling values and selecting the median formant estimate across this range.

The procedure is as follows:

* Iterate through F5 ceilings in 50 Hz steps within the range 3500-6000 Hz
* Concatenate F1-F5 estimates at each ceiling step
* For each time step, find the median F1-F5 values across all estimates
* Append the median values to a table along with the time stamp

After the script has completed, a table called "formants" will remain in the Object window. This table can then be saved to your desired data format.

Note: before running the script, make sure that a sound object is selected in the Objects window.