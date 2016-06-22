## CombineText.R
if (!exists("CONFIG.LOADED")) source("Config.R")

load.data(filename = paste0("clean.charVec_rmSW", rmSW, ".Rdata"), source.path)

all.char.vector <- unlist(char.vectors, use.names = FALSE)
all.freq.table <- table(all.char.vector)
all.sorted.freq <- sort(all.freq.table, decreasing = TRUE)

save(all.char.vector, file = paste0(source.path, 
                                    "clean.all.charVec_rmSW", rmSW, ".Rdata"))
save(all.freq.table, file = paste0(source.path,
                                   "clean.all.freqTable_rmSW", rmSW, ".Rdata"))
save(all.sorted.freq, file = paste0(source.path,
                                    "clean.all.freqSorted_rmSW", rmSW, ".Rdata"))

# Clean workspace
remove(list = ls())
