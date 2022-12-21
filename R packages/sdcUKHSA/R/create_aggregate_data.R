# The table formatting below is a little ugly - the '&nbsp;' elements in the header are
# the only way  I could figure out to widen the columns so they're easier to read

#' Create an aggregate_data object
#'
#' @description Convert a data frame into an object of class `aggregate_data`, the required format
#'  for use with sdcUKHSA functions.
#'
#' @param original_data A data frame that you wish to convert to an `aggregate_data` object. See details for
#' more information on required format.
#' @param data A vector of indices indicating the columns in original_data that contain numeric data.
#' @param treatment A single numeric value indicating the index of the column in original_data that contains row names.
#' @param total_col Optional. A single numeric value indicating the index of the column in original_data that contains row totals.
#' @param total_row Optional. A single numeric value indicating the index of the row in original_data that contains column totals.
#' @returns An aggregate_data object
#' @details
#' Aggregate data must be converted to an object of class `aggregate_data` before it can be used
#' with sdcUKHSA functions. Your data should be loaded into R as a data frame, at which point
#' it can be converted to an `aggregate_data` object using the `create_aggregate_data()` function.
#'
#' `create_aggregate_data()` expects `original_data` to take the form, essentially, of a two-way
#' table, with rows indicating groups of one categorical variable and columns indicating groups
#' of another categorical variable. This requires your data to have certain features which must
#' be indicated in the function call:
#'
#' \itemize{
#'   \item One column specifying groups of a treatment or other categorical variable.
#'   The index of this column is passed via the `treatment` parameter.
#'   \item Columns specifying the numerical observations in your data, broken down into groups of some
#'   how many observations for each group in `treatment`.
#' }
#'
#' Data of this type often includes totals for each row and/or column. These can be helpful to users
#' and although this is not required
#' to create an aggregate_data object.
#' If your data contains marginal totals for the rows and/or columns of `data`, these must be
#' indicated as well:
#'
#' \itemize{
#'   \item If marginal **column** totals are present, the **row** containing these must be specified
#'   by passing its index to the `total_row` parameter.
#'   \item If marginal **row** totals are present, the **column** containing these must be specified
#'   by passing its index to the `total_col` parameter.
#' }
#'
#' The table below shows an example of data in an appropriate format:
#'
#' `data frame name: example_data`
#'
#' | **treatment**&nbsp;&nbsp;&nbsp;&nbsp; | **data1**&nbsp;&nbsp;&nbsp;&nbsp; | **data2**&nbsp;&nbsp;&nbsp;&nbsp; | **data3**&nbsp;&nbsp;&nbsp;&nbsp; | **total_col**&nbsp;&nbsp;&nbsp;&nbsp;|
#' |:---------:|:-----:|:-----:|:-----:|:--------:|
#' | **A**         |   0   |   5   |   1   |     6    |
#' | **B**         |   4   |   2   |   2   |     8    |
#' | **C**         |   1   |   7   |   3   |     11   |
#' | **total_row** |   5   |   14  |   6   |     25   |
#'
#' The corresponding function call to convert this table into an `aggregate_data` object would be:
#' (recall that column names are not treated)
#' `create_aggregate_data(original_data = example_data, data = c(2, 3, 4), treatment = 1, total_col = 5, total_row = 4`
#'
#' @examples To do
#' @export
create_aggregate_data <- function(original_data, data, treatment, total_col = NULL, total_row = NULL) {

  # check for na and non-numeric values
  numeric <- as.data.frame(suppressWarnings(sapply(original_data, as.numeric)))[-treatment]
  all_non_numeric <- NULL

  if(anyNA(numeric)) {

    na_vals <- original_data[,-treatment][which(is.na(numeric), arr.ind = TRUE)]

    original_data[,-treatment] <- numeric

    na_inds <- which(is.na(original_data), arr.ind = TRUE)

    all_non_numeric <- as.data.frame(cbind(value = na_vals, na_inds)) %>%
      mutate(row = as.numeric(row), col = as.numeric(col))

    warning("At least one value in your data is NA or non-numeric: \n",
            paste(capture.output(print(all_non_numeric, row.names = FALSE)), collapse = "\n"),
            "\nYou may wish to check whether these values are correct\n",
            call. = FALSE)

  }

  # check if values are okay and totals are correct
  if(is.numeric(total_row)){
    if(all(colSums(na.rm = TRUE, original_data[,-treatment]) == original_data[total_row,-treatment]*2) == FALSE){
      false_totalc <- which(colSums(na.rm = TRUE, original_data[,-treatment]) != original_data[total_row,-treatment]*2)
      print(false_totalc)
      warning("Totals provided do not equal true column totals for the following column(s): \n",
              paste(colnames(original_data[,-1])[false_totalc], collapse = ", "),
              "\nYou may wish to check whether you have calculated your totals correctly and indicated the correct row index in your function call\n",
              call. = FALSE)
    }
  }
  if(is.numeric(total_row)){
    if(all(rowSums(na.rm = TRUE, original_data[,-treatment]) == original_data[, total_col]*2) == FALSE){
      false_totalr <- which(rowSums(na.rm = TRUE, original_data[,-1]) != original_data[, total_col]*2)
      warning("Totals provided do not equal true column totals for the following row(s): \n",
              paste(original_data[as.numeric(false_totalr), treatment], collapse = ", "),
              "\nYou may wish to check whether you have calculated your totals correctly and indicated the correct row index in your function call",
              call. = FALSE)
    }
  }

  # If no row/column totals are given, replace total_row/total_col with a vector of the negative indices
  # of the data rows/columns, so that when functions try to remove the total row/col, they don't change
  # the data, i.e. data[,-c(-1,-2)] is equivalent to data[,c(1,2)]
  # This is kind of hacky but it works?
  if(is.null(total_row)){
    total_row <- c(1:nrow(original_data))*-1
  }
  if(is.null(total_col)){
    total_col <- data*-1
  }


  # create aggregate_data object
  agg_data <- list(treatment = treatment,
                   data = data,
                   total_col = total_col,
                   total_row = total_row,
                   original_data = original_data,
                   na_vals = all_non_numeric
  )
  class(agg_data) <- "aggregate_data"

  return(agg_data)
}

