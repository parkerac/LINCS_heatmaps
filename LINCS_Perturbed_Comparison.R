#! /usr/bin/env Rscript
#install.packages(c("dplyr", "readr"))

library(dplyr)
library(readr)

#parse LINCS files
HPRT1data <- read_tsv("outputHPRT1Data.tsv", col_names = TRUE)
AURKAdata <- read_tsv("outputAURKAData.tsv", col_names = TRUE) 

#open output files
HPRT1OutFile <- file("HPRT1_pert_comparison.tsv", "w")
AURKAOutFile <- file("AURKA_pert_comparison.tsv", "w")

organizeData <- function(gene, data, outputFile) {
  #extract base_cell_id and gene expression only
  dataFrame <- select(data, base_cell_id, pert_iname, pert_type, gene)
  perturbedDataFrame <- filter(dataFrame, pert_type == "trt_cp")
  cells <- unique(perturbedDataFrame$base_cell_id)
  
  #organize perturbed values
  myMatrix <- NULL
  
  for (item in cells) {
    values <- filter(perturbedDataFrame, base_cell_id == item)
    inames <- unique(values$pert_iname)
    for (iname in inames) {
      inameValues <- filter(values, pert_iname == iname)
      avgExpression <- median(inameValues[[gene]])
      myMatrix <- rbind(myMatrix, c(item, iname, round(avgExpression, 3)))
    }
  }
  
  dataFrame <- as.data.frame(myMatrix, stringsAsFactors = FALSE)
  colnames(dataFrame) <- c("Base_Cell_ID", "Pert_Iname", "Pert_Value")
  sortedDataFrame <- dataFrame[with(dataFrame, order(as.numeric(Pert_Value))),]
  
  write_tsv(sortedDataFrame, outputFile)
  close(outputFile)
}

organizeData("HPRT1", HPRT1data, HPRT1OutFile)
organizeData("AURKA", AURKAdata, AURKAOutFile)

