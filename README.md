# formant-optimization
Praat script for automatic formant optimization

This Praat script provides an automated optimzation of formant values F1-F5 by iterating through a range of possible formant ceiling values and estimating the point where the formant measurement estimates stabilize. 

Since any given formant ceiling can yield accurate results for one formant, but not necessarily another (e.g., accurate estimate for F1 but not F3, or vice versa), and since the accuracy of these estimates can change over the time course of dynamic speech, the optimization is carried out independently for each formant and for each time point. 

The procedure is as follows:

* Iterate through F5 ceilings in 50 Hz steps within the range 3500-6000 Hz (default, but can be changed)
* Concatenate F1-F5 estimates at each ceiling step
* For each time step, and for each formant, use the first difference (velocity) to locate point(s) of stability within the formant track
* Trim the data to the area of stability (if two areas are found, the second is used)
* Find the most stable F1-F5 values of the trimmed data, taken as the point of minimum absolute velocity
* Append the formant values to a table along with the time stamp

After the script has completed, a table called "formants" will remain in the Object window. This table can then be saved manually to your desired data format.

Note: before running the script, make sure that a sound object is selected in the Objects window.