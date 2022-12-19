#' Check for non-structural zeros in tabular data
#'
#' @description `k_anonymity` finds combinations of characteristics in microdata observations
#' that occur fewer than `k` times
#'
#' @param data a data frame of microdata with one observation per row
#' @param k numeric, combinations of characteristics that occur fewer than `k` times will be found
#' @param cols optional, a vector of indices indicating the columns in `data` that will be used
#' in generating combinations to search. By default, all columns in `data` are used
#'
#' @returns a data frame. This will have one row for each unique combination of the values of `cols`
#'  that occurs fewer than k times, and one column corresponding to each column in `cols`. The data frame will
#'  also contain the column `Freq`, which is numeric and give the number of times that each combination occurs.
#'
#'
#' @examples To do
#' @export
k_anonymity <- function(data, k, cols) {

  if(!is.null(cols)){
    data <- data[,cols]
  }

 # data <- obj$original_data[-obj$total_row,obj$data]
  paste <- unite(data, col= "str", sep = "#", remove = FALSE)

  freq <- as.data.frame(table(paste$str)) %>%
    filter(Freq < k)

  inds <- which(paste$str %in% freq$Var1)

  if(length(inds)==0) {
    print(paste0("No combinations of characteristics fall beneath the k = ", k, " threshold"))
  }
  if(length(inds) > 0) {

    combos <- merge(unique(paste[which(paste$str%in%freq$Var1),]), freq, by.x="str", by.y="Var1") %>%
      select(-str)

    print(paste0(nrow(combos), " combinations of characteristics occur fewer than k = ", k, " times"))

    return(combos)
    }

}
