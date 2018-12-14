library(readr)
library(superheat)
library(reshape2)
library(dplyr)
library(gdata)

sortFunction <- function(data) {
  drugs <- unique(data$Pert_Iname)
  averages <- c()
  
  for (item in drugs) {
    values <- filter(data, Pert_Iname == item)
    avgExpression <- median(values$Pert_Value)
    averages <- c(averages, avgExpression)
  }
  
  names(averages) <- drugs
  averages <- sort(averages)
  sortedDrugs <- names(averages)
  return(sortedDrugs)
}

organizeFunction <- function(heatmapFile, dataFile, gene) {
  png(heatmapFile, height = 900, width = 800)
  pertData <- read_tsv(dataFile, col_names = TRUE)
  
  populousData <- filter(pertData, Base_Cell_ID == "A375" | Base_Cell_ID == "HA1E" | Base_Cell_ID == "HELA" | 
                           Base_Cell_ID == "HT29" | Base_Cell_ID == "MCF7" | Base_Cell_ID == "PC3" | Base_Cell_ID == "YAPC")
  drugs <- select(pertData, Pert_Iname)
  
  populousDataMatrix <- acast(populousData, Pert_Iname~Base_Cell_ID, value.var = "Pert_Value")
  
  sortedPopulousData <- populousDataMatrix[sortFunction(populousData),]
  
  heatmap <- superheat(sortedPopulousData, scale = T,
                       left.label.size = 0.01,
                       left.label.text.size = .01,
                       bottom.label.text.size = 6.5,
                       bottom.label.size = 0.1, 
                       title = gene,
                       title.size = 11, 
                       title.alignment = "center",
                       row.title = "Drugs",
                       row.title.size = 10,
                       column.title = "Cell Lines",
                       column.title.size = 10, 
                       legend.height = 0.1,
                       legend.width = 2.5,
                       legend.text.size = 15)
  
  dev.off()
}

organizeFunction("HPRT1superheat1_sortByAvg.png", "HPRT1_pert_comparison.tsv", "HPRT1")
organizeFunction("AURKAsuperheat1_sortByAvg.png", "AURKA_pert_comparison.tsv", "AURKA")
