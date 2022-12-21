#' Check for non-structural zeros in tabular data
#'
#' @description `find_zeros` finds columns in your data that have a high proportion of
#' non-structural zeros as defined by a user-chosen cutoff
#'
#' @param obj an `aggregate_data` object
#' @param prop numeric, must be between 0 and 1. Any columns with a
#' proportion of zeros that is greater than or equal to `prop` will be included in the output.
#'
#' @returns A matrix with one row per column in the input data that has a proportion of zeros
#' greater than or equal to `prop`. There are two columns in the matrix, `col` and `proportion`,
#' which give the column name and proportion of zeros in that column, respectively.
#'  
#'
#' @examples To do
#' @export
find_zeros <- function(obj, prop = 0.1) {

  y<-obj$original_data[-obj$total_row,obj$data] %>% summarise_all(~mean(.==0)) %>%
    pivot_longer(everything(), names_to = "col", values_to = "proportion") %>%
    filter(proportion >= prop)

  return(as.data.frame(y))
}
