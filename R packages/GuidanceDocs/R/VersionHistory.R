#' Version history table
#'
#' Function to create a simple version history table that can be added to documents
#'
#' @usage VersionHistory(c("date", "Version"), c("date", "Version"), ...)
#'
#' @param ... Pass 1 list per version, with a date (dd/mm/yyyy) and a comment. The most recent update should be given first. For example: 'c("29/09/2022", "Updated with more content"),c("01/09/2022", "Initial release")'
#'
#' @details This function is used for our guidance documents. It may have limited use cases beyond those.
#'
#' @author Ben Cuff


#' @export
VersionHistory <- function(...){
  vh <- data.frame(rbind(...))
  vh_out <- "<table><tr><th>Date</th><th>Notes</th></tr>"
  for(i in 1:nrow(vh)){
    assign("vh_out", paste0(vh_out, "<tr><td>", vh[i,1], "</td><td>", vh[i,2], "</td></tr>"))
  }
  vh_out <- paste0(vh_out, "</table>")
  return(vh_out)
}
