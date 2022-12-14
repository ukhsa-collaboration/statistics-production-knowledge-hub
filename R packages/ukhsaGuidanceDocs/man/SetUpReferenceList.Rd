% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ReferenceList.R
\name{SetUpReferenceList}
\alias{SetUpReferenceList}
\title{Reference list adder}
\usage{
SetUpReferenceList(.path, .sheet = 1)

addRef(.StableID)

AddReferenceList()
}
\arguments{
\item{.path}{The file path to the references spreadsheet or workbook. Can be a relative filepath when knitted within a project.}

\item{.sheet}{For .xlsx and .ods files, the tab number where the references are held. Defaults to 1.}

\item{...}{One or more row numbers of the reference(s) to be added to the reference list, each separated by a comma.}
}
\description{
Functions to add superscript references to text and to create and add an ordered reference list to markdown documents.
}
\details{
The spreadsheet must contain a list of names in Column A, a list of URLs in Column B, and row numbers in Column C (note that rows do not need to be in any particular order but each ID should be unique).

Supported formats currently include .xlsx, .ods and .csv

Call SetUpReferenceList() at the start of your markdown file, within your setup code chunk.

Call ^`r addRef(n,n,...)`^ in the text each time you want to add a reference. n = the stable ID number from the spreadsheet.

Call `r AddReferenceList()` at the end of your markdown document to add the formatted list.

These functions are used for our guidance documents but they may be used to manage references in other documents as well.
}
\author{
Ben Cuff
}
