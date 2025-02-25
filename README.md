# ICRhelpR
Set of functions intended to facilitate the preperation of data for intercoder reliability content analysis. 

Includes the functions:


Lacy Riffe Calculation

This function is an implementation of the formula for calculating intercoder reliability samples developed by Lacy and Riffe (1996).
It requires the user to input the total number of content units being studied (x), then provide their desired degree of confidence
(ci, default is a 95% confidence interval (p=0.05)). It requires an estimate of the level of agreement in coding all study units. This is either estimated from a minimal
acceptable level of agreement (min.agree, default is .85) or another estimate of P, such as from prior ICR work is provided explicitly using the argument P.
The function calculates the result based on the formula provided and provides a sample size (rounded to the nearest whole number) that will "permit a known degree
of confidence that the agreement in a sample of test units is representative of the pattern that would occur if all study units were coded by all coders."


Lacy, S., & Riffe, D. (1996). Sampling Error and Selecting Intercoder Reliability Samples for Nominal Content Categories. Journalism & Mass Communication Quarterly, 73(4), 963-973. https://doi.org/10.1177/107769909607300414


Lacy Riffe Sample
This function uses the `lacy_riffe_calc` function to subset a random selection of observations
from a dataframe. The number of observations selected is based on the result from `lacy_riffe_calc()`.


ICR Random Draw

This function randomly selects observations from a dataframe to subset a given number for ICR analysis.


ICR Overlap

This function creates a dataset assigning coders to observations with a given level of overlap between coders.
It randomly selects a given number of rows, and assigns them to all coders.
It attempts to evenly distribute the remaining observations across all coders.