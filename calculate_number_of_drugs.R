library("readr")
pertData <- read_tsv("HPRT1_pert_comparison.tsv", col_names = TRUE)
drugs <- filter(pertData, Base_Cell_ID == "A375" | Base_Cell_ID == "HA1E" | Base_Cell_ID == "HELA" | 
                  Base_Cell_ID == "HT29" | Base_Cell_ID == "MCF7" | Base_Cell_ID == "PC3" | Base_Cell_ID == "YAPC")
uniqueDrugs <- unique(drugs$Pert_Iname)
number <- length(uniqueDrugs)
pertData2 <- read_tsv("AURKA_pert_comparison.tsv", col_names = TRUE)
drugs2 <- filter(pertData2, Base_Cell_ID == "A375" | Base_Cell_ID == "HA1E" | Base_Cell_ID == "HELA" | 
                   Base_Cell_ID == "HT29" | Base_Cell_ID == "MCF7" | Base_Cell_ID == "PC3" | Base_Cell_ID == "YAPC")
uniqueDrugs2 <- unique(drugs2$Pert_Iname)
number2 <- length(uniqueDrugs2)
