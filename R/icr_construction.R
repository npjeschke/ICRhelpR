#' ICR Random Draw
#'
#' This function randomly selects observations from a dataframe to subset a given number for ICR analysis.
#'
#' @param x A dataframe containing the data.
#' @param sample A whole number specifying how many rows to randomly sample.
#' @return A modified dataframe with randomly selected rows.
#' @examples
#' df <- data.frame(a = 1:10, b = letters[1:10])
#' icr_random_draw(df, sample = 5)
#' @export
icr_random_draw <- function(x, sample) {

  #ensure sample value is valid
  if (!is.data.frame(x)) stop("x must be a dataframe.")
  if (!is.numeric(sample) || sample <= 0 || sample > nrow(x)) stop("sample must be a positive whole number and less than or equal to the number of rows in x.")

  #randomly select `sample` rows from the dataframe
  sampled_data <- x[sample(nrow(x), sample), ]

  #return a dataframe with randomly selected rows
  return(sampled_data)
}

#' ICR Overlap
#'
#' This function creates a dataset assigning coders to observations with a given level of overlap between coders.
#' It randomly selects a given number of rows, and assigns them to all coders.
#' It attempts to evenly distribute the remaining observations across all coders.
#'
#' @param x A dataframe containing the data.
#' @param sample A whole number specifying how many observations to overlap between coders.
#' @param percent A percentage expressed as a decimal between 0 and 1 that specifies the percentage of observations to sample.
#'                This argument cannot be used with the sample argument.
#' @param coders A whole number specifying how many coders to assign observations to.
#' @return A modified dataframe with a new column "coder" indicating coder assignments.
#' @examples
#' df <- data.frame(a = 1:10, b = letters[1:10])
#' icr_overlap(df, sample = 5, coders = 3)
#' @export
icr_overlap <- function(x, sample = NULL, percent = NULL, coders) {

  #check that input values are valid
  if (!is.data.frame(x)) stop("x must be a dataframe.")
  if (!is.numeric(coders) || coders <= 0) stop("coders must be a positive whole number.")

  #if both sample and percent are provided, raise an error
  if (!is.null(sample) && !is.null(percent)) stop("Cannot use both sample and percent arguments at the same time.")

  #determine number of rows to sample
  if (!is.null(sample)) {
    if (!is.numeric(sample) || sample <= 0 || sample > nrow(x)) stop("sample must be a positive whole number and less than or equal to the number of rows in x.")
    sampled_rows <- sample
  } else if (!is.null(percent)) {
    if (!is.numeric(percent) || percent < 0 || percent > 1) stop("percent must be a number between 0 and 1.")
    sampled_rows <- floor(nrow(x) * percent)
  } else {
    stop("Either sample or percent must be provided.")
  }

  #randomly select `sampled_rows` from the dataframe
  selected_data <- x[sample(nrow(x), sampled_rows), ]

  #duplicate the randomly sampled rows for each coder
  duplicated_data <- selected_data[rep(1:nrow(selected_data), each = coders), ]

  #create a new "coder" column for the duplicated rows
  duplicated_data$coder <- rep(paste0("coder_", 1:coders), length.out = nrow(duplicated_data))

  #assign coders to the non-overlapped rows
  non_selected_data <- x[!rownames(x) %in% rownames(selected_data), ]

  #create a vector of coders to assign to the remaining rows
  coders_vector <- rep(paste0("coder_", 1:coders), length.out = nrow(non_selected_data))

  #randomly shuffle the coders to ensure a random assignment
  set.seed(42) # Optional, to make it reproducible
  non_selected_data$coder <- sample(coders_vector)

  #combine the selected (duplicated) and non-selected data
  result_data <- rbind(duplicated_data, non_selected_data)

  #return the modified dataframe
  return(result_data)
}
