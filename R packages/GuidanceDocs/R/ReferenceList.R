#' Reference list adder
#'
#' Functions to add superscript references to text and to create and add an ordered reference list to markdown documents.
#'
#' @usage SetUpReferenceList(.path, .sheet = 1)
#' @usage addRef(.StableID)
#' @usage AddReferenceList()
#'
#' @param .path The file path to the references spreadsheet or workbook. Can be a relative filepath when knitted within a project.
#' @param .sheet For .xlsx and .ods files, the tab number where the references are held. Defaults to 1.
#' @param ... One or more row numbers of the reference(s) to be added to the reference list, each separated by a comma.
#'
#' @details The spreadsheet must contain a list of names in Column A, a list of URLs in Column B, and row numbers in Column C (note that rows do not need to be in any particular order but each ID should be unique).
#' @details Supported formats currently include .xlsx, .ods and .csv
#'
#' @details Call SetUpReferenceList() at the start of your markdown file, within your setup code chunk.
#' @details Call ^`r addRef(n,n,...)`^ in the text each time you want to add a reference. n = the stable ID number from the spreadsheet.
#' @details Call `r AddReferenceList()` at the end of your markdown document to add the formatted list.
#' @details These functions are used for our guidance documents but they may be used to manage references in other documents as well.
#'
#' @author Ben Cuff
#'
#' @importFrom readxl read_xlsx
#' @importFrom readODS read_ods
#' @importFrom readr read_csv


#' @export
SetUpReferenceList <- function(.path, .sheet=1){

  # Load file according to file type
  if(endsWith(.path, ".xlsx")){
    all_refs <- readxl::read_xlsx(.path, sheet=.sheet)

  }else if(endsWith(.path, ".ods")){
    all_refs <- readODS::read_ods(.path, sheet=.sheet)

  }else if(endsWith(.path, ".csv")){
    all_refs <- readr::read_csv(.path)

  }else{
    stop("Filetype not supported. Please pass one of the following file types: .xlsx, .ods, .csv")
  }

  #Define columns
  all_refs <- all_refs[,1:3]
  names(all_refs) <- c("Name", "Link", "StableID")

  assign("all_refs", all_refs, envir = .GlobalEnv)

}


#' @export
addRef <- function(...){

  l <- c(...)
  .out <- ""

  for(.StableID in l){
    #If not already done, set up output dataframe
    if(!exists("ref_list")){
      ref_list <- data.frame("Row" = integer(), "Name" = character(), "Link" = character())
      assign("ref_list", ref_list, envir = .GlobalEnv)
    }

    #Add reference to the list
    if(nrow(all_refs[which(all_refs$StableID==.StableID),])==0){
      stop(paste("Check your references! There is no reference number", .StableID))
    }

    .Name <- all_refs[which(all_refs$StableID==.StableID), 'Name'][[1]]
    .Link <- all_refs[which(all_refs$StableID==.StableID), 'Link'][[1]]

    if(!.Name %in% ref_list$Name){
      ref_list[nrow(ref_list)+1, 1:3] <- c(nrow(ref_list)+1, .Name, .Link)
    }

    assign("ref_list", ref_list, envir = .GlobalEnv)

    .out <- paste0(.out, "[[",  ref_list[which(ref_list$Name == .Name),1],  "](#References)]")
  }

  return(.out)

}


#' @export
AddReferenceList <- function(){

  list_out="\n<a id='References'></a>\n\n"
  for(i in 1:nrow(ref_list)){
    list_out <- paste(list_out, i, '. [', ref_list[i,2], '](', ref_list[i,3], ')\n', sep="")
  }

  return(list_out)
}
