#' Basic and semi-controlled random rounding for tabulated data
#'
#' @description `base_round` finds locations in your data where the
#' specified cell is less than or equal to a cutoff value of your choosing.
#' The function prints off a list of locations that can optionally be stored as variable.
#'
#' @param obj an `aggregate_data` object
#' @param base numeric, can take any integer value greater than zero. Values in your data will be rounded to a
#' multiple of `base`.
#' @param controlled_ran logical. If `FALSE`, values in the data will simply be rounded to the
#' nearest multiple of `base`. Totals will not be preserved. If set to `TRUE` then semi-controlled random rounding will
#' be applied to the data in order to preserve the overall total. Marginal totals will not be
#' preserved. This introduces some distortion into your data. See 'Details' below for more information about semi-controlled random rounding.
#' @param fewer_than_base character or statement that yields a value with class character. A message to display
#' in cells that are rounded down to 0 to distinguish them from "true" 0 values where no observations
#' were recorded. See "Details" below for more information about best practice in representing rounded 0 values.
#'
#' @returns A data frame with the same dimensions and format as `obj$original_data`,
#' with rounding applied according to your choice of `base`.
#'
#' @details
#' Semi-controlled random rounding is carried out according to the method described in section 3.2
#' of the paper [Measuring Disclosure Risk and Data Utility for Flexible Table Generators](https://sciendo.com/article/10.1515/jos-2015-0019) (Shlomo et al, 2015).
#' While "fully controlled" random rounding seeks to preserve the additivity of all marginal totals of a data table, semi-controlled
#' random rounding only preserves the (rounded) overall table total. This is to say that the overall total
#' given by `base_round` in the output data will be the same as if the total in the input data were rounded to the
#' nearest multiple of `base` and the rounded marginal totals for rows and columns will each add up to that overall total.
#' However, each column may not add up to its individual marginal total after applying semi-controlled random rounding.
#'
#' This is perhaps easier to grasp when presented in the form of an example. The table `unrounded_data`
#' below has not has any rounding applied to it. Therefore, risk of disclosure may be present.
#'
#' `data frame name: unrounded_data`
#'
#' | **treatment**&nbsp;&nbsp;&nbsp;&nbsp; | **data1**&nbsp;&nbsp;&nbsp;&nbsp; | **data2**&nbsp;&nbsp;&nbsp;&nbsp; | **data3**&nbsp;&nbsp;&nbsp;&nbsp; | **total_col**&nbsp;&nbsp;&nbsp;&nbsp;|
#' |:---------:|:-----:|:-----:|:-----:|:--------:|
#' | **A**         |   0   |   5   |   1   |     6    |
#' | **B**         |   4   |   2   |   2   |     8    |
#' | **C**         |   1   |   7   |   3   |     11   |
#' | **D**         |   2   |   2   |   2   |     6    |
#' | **total_row** |   7   |   16  |   8   |     31   |
#'
#'
#' The table `simple_rounded` below has had all values rounded to the nearest multiple of three with no control applied,
#' equivalent to calling `base_round()` with `base = 3` and `controlled_ran = FALSE`. We do not remove the marginal
#' totals before rounding and recalculate them afterwards as this would introduce significant rounding error,
#' especially for very large tables, causing us to lose vital information.
#'
#' All values in the table are rounded as closely to their original values as possible, but all of the original
#' values have been obscured, helping to reduce the risk of disclosure. However, the marginal totals no
#' longer align with the table values nor with the the overall total, suggesting that methods which prioritise closeness
#' to the original data  at the level of individual cells nevertheless incur some loss of information at a wider level.
#'
#' `data frame name: simple_rounded`
#'
#' | **treatment**&nbsp;&nbsp;&nbsp;&nbsp; | **data1**&nbsp;&nbsp;&nbsp;&nbsp; | **data2**&nbsp;&nbsp;&nbsp;&nbsp; | **data3**&nbsp;&nbsp;&nbsp;&nbsp; | **total_col**&nbsp;&nbsp;&nbsp;&nbsp;|
#' |:---------:|:-----:|:-----:|:-----:|:--------:|
#' | **A**         |   0              |   6   |   fewer than 3   |     6    |
#' | **B**         |   3              |   3   |   3              |     9    |
#' | **C**         |   fewer than 3   |   6   |   3              |     12   |
#' | **D**         |   3              |   3   |   3              |     6    |
#' | **total_row** |   6              |   15  |   9              |     30   |
#'
#'
#'
#' The table `semi_controlled_rounding` below has had base-3 semi-controlled random rounding applied to it, equivalent to calling
#' `base_round()` with `base = 3` and `controlled_ran = TRUE`. We see that as before, all cells have been rounded up or down to
#' a multiple of three, but rather than round to the closest multiple, we have randomly chosen whether each
#'  cell is rounded up or down. In doing so, we have created a table where the rounded marginal totals still
#'  add up to the same value as the original rounded overall total. Our individual cells, however, still do not add to the marginal total.
#'
#'
#'
#' | **treatment**&nbsp;&nbsp;&nbsp;&nbsp; | **data1**&nbsp;&nbsp;&nbsp;&nbsp; | **data2**&nbsp;&nbsp;&nbsp;&nbsp; | **data3**&nbsp;&nbsp;&nbsp;&nbsp; | **total_col**&nbsp;&nbsp;&nbsp;&nbsp;|
#' |:---------:|:-----:|:-----:|:-----:|:--------:|
#' | **A**         |   0              |             6   |   fewer than 3   |     6    |
#' | **B**         |   3              |             3   |   3              |     9    |
#' | **C**         |   3              |             6   |   3              |     12   |
#' | **D**         |   3              |  fewer than 3   |    fewer than 3  |     6    |
#' | **total_row** |   6              |             15  |   9              |     30   |
#'
#'
#'
#' @examples To do
#' @export
base_round <- function(obj, base = 5, controlled_ran = FALSE, fewer_than_base = paste0("fewer than ", base)) {

  # check if base is a positive integer
  if(base <=0 | base%%1 != 0){
  stop("You entered the following value as your base: ",
          base,
          "\nArguments passed to base must be integers with value greater than 0.\nPlease try again with a valid base.",
          call. = FALSE)
  }

  data <- obj$original_data[-obj$total_row,obj$data]

  if (controlled_ran == FALSE) {

    data <- obj$original_data[,-obj$treatment]

    data <- cbind("week_number" = obj$original_data[, obj$treatment],
                  round(data/base)*base)
    data[data == 0 & obj$original_data != 0] <- fewer_than_base

  }

  # semi-controlled random rounding

  if (controlled_ran == TRUE) {

    data <- obj$original_data[-obj$total_row,obj$data]
    data_floor <- data - (data%%base)
    res_data <- data-data_floor
    prob <- res_data/base
    n_roundup <- round(sum(prob))

    datam <- as.matrix(data)
    roundup <- sample(which(datam%%base!=0),n_roundup)
    datam_rdown <- datam - (datam%%base)
    datam_rdown[roundup] <- datam_rdown[roundup] + base

    datam_rdown <- adorn_totals(cbind(obj$original_data[-obj$total_row,obj$treatment],as.data.frame(datam_rdown)), c("row", "col"))
    datam_rdown[datam_rdown == 0 & obj$original_data != 0] <- fewer_than_base
    data <- as.data.frame(datam_rdown)


  }
  return(data)
}

