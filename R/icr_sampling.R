#' Calculate One-Tailed Z-Score and Standard Error
#'
#' This function calculates the one-tailed z-score for a given confidence interval,
#' and then divides  (1 - confidence interval) z-score by to adjust the confidence interval.
#'
#' @param confidence_interval A numeric value representing the confidence level (e.g., 0.95 for 95% confidence).
#' @return The adjusted confidence interval.
#' @examples
#' adjusted_confidence_interval <- one_tailed_z_score_adjusted(0.95)
#' @export
standard_error <- function(confidence_interval) {

  #calculate the z-score for the one-tailed confidence interval
  alpha <- 1 - confidence_interval  #significance level
  z_score <- qnorm(1 - alpha)  #one-tailed z-score

  #find standard error by dividing (1 - confidence_interval) by the z-score
  SE <-  (1 - confidence_interval) / z_score

  #return the standard error
  return(SE)
}

#' Lacy Riffe Calculation
#'
#' This function is an implementation of the formula for calculating intercoder reliability samples developed by Lacy and Riffe (1996).
#' It requires the user to input the total number of content units being studied (x), then provide their desired degree of confidence
#' (ci, default is a 95% confidence interval (p=0.05)). It requires an estimate of the level of agreement in coding all study units. This is either estimated from a minimal
#' acceptable level of agreement (min.agree, default is .85) or another estimate of P, such as from prior ICR work is provided explicitly using the argument P.
#' The function calculates the result based on the formula provided and provides a sample size (rounded to the nearest whole number) that will "permit a known degree
#' of confidence that the agreement in a sample of test units is representative of the pattern that would occur if all study units were coded by all coders."
#'
#'
#' @param x A numeric value to apply the formula to.
#' @param ci A numeric value between 0 and 1 representing the desired degree of confidence (default is 0.95).
#' @param min.agree A numeric value between 0 and 1 representing the minimum agreement as a decimal (default is 0.85).
#' #'          `min.agree` with an additional 0.05 will be used to estimate P.
#' @param P An optional numeric value between 0 and 1, representing an estimate of the level of agreement in coding all study units as a decimal. If provided, `P` overrides `min.agree`.
#'          The value will be converted into a decimal (e.g., 90% becomes 0.9). If not provided, the default behavior of adjusting
#' @return The result of the Lacy-Riffe calculation, rounded to 0 decimal places.
#' @examples
#' result <- lacy_riffe_calc(100)
#' result_custom <- lacy_riffe_calc(100, ci = 0.99, min.agree = 0.9)
#' result_with_P <- lacy_riffe_calc(100, P = .90)  # Uses P instead of min.agree
#' @export
#'
lacy_riffe_calc <- function(x, ci = 0.95, min.agree = 0.85, P = "") {

  #ensure confidence interval (ci) is between 0 and 1
  if (ci <= 0 || ci >= 1) {
    stop("Confidence interval (ci) must be between 0 and 1.")
  }

  #ensure min.agree is between 0 and 1
  if (min.agree <= 0 || min.agree >= 1) {
    stop("Minimum agreement (min.agree) must be between 0 and 1.")
  }

  #if P is provided, use it instead of min.agree
  if (P != "") {
    # Ensure P is between 0 and 1 (if provided as a percentage, divide by 100)
    if (P < 0 || P > 1) {
      stop("Percentage P must be between 0 and 1")
    }
    min.agree <- P  # Override min.agree with P
  } else {
    #add 0.05 to min.agree if P is not provided
    min.agree <- min.agree + 0.05

    #ensure that min.agree doesn't exceed 1
    if (min.agree > 1) {
      min.agree <- 1
    }
  }

  #calculate the standard error
  adjusted_standard_error <- standard_error(ci)

  #apply the formula with the standard error, rounding up to the nearest whole number
  result <- round({
    (((x - 1) * (adjusted_standard_error^2)) + ((min.agree * (1 - min.agree)) * x)) /
      (((x - 1) * (adjusted_standard_error^2)) + (min.agree * (1 - min.agree)))
  }, digits = 0)

  {round({
    (((x-1)*(.03^2))+((.85*.15)*x))/
      (((x-1)*(.03^2))+((.85*.15)))
  }, digits = 0)}
  return(result)
}


#' Lacy Riffe Sample
#'
#' This function uses the `lacy_riffe_calc` function to subset a random selection of observations
#' from a dataframe. The number of observations selected is based on the result from `lacy_riffe_calc()`.
#'
#' @param x A dataframe from which to sample observations.
#' @param ci A numeric value representing the confidence interval (default is 0.95).
#' @param min.agree A numeric value representing the minimum acceptable agreement (default is 0.85).
#' @return A randomly selected subset of observations from the dataframe.
#' @examples
#' df <- data.frame(a = 1:100, b = rnorm(100))
#' sampled_data <- lacy_riffe_sample(df)
#' @export
lacy_riffe_sample <- function(x, ci = 0.95, min.agree = 0.85) {

  #check if x is a dataframe
  if (!is.data.frame(x)) {
    stop("Input 'x' must be a dataframe.")
  }

  #get the number of observations in the dataframe
  num_rows <- nrow(x)

  #calculate the number of observations to sample using lacy_riffe_calc
  rows_to_sample <- lacy_riffe_calc(num_rows, ci, min.agree)

  #ensure that the number of observations to sample is not greater than the total number of rows
  if (rows_to_sample > num_rows) {
    stop("The calculated number of rows to sample exceeds the total number of rows in the dataframe.")
  }

  #randomly sample the observations
  sampled_rows <- x[sample(1:num_rows, rows_to_sample), ]

  return(sampled_rows)
}
