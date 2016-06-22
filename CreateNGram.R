## CreateNGram.R
library(NLP)
if (!exists("CONFIG.LOADED")) source("Config.R")

getNgram <- function(ngram, data)
{
    vapply(ngrams(x = data, n = ngram), FUN = paste, FUN.VALUE = "", 
           collapse = " ", USE.NAMES = FALSE)
}

getNgrams <- function(vector, n.list)
{
    sapply(X = n.list, FUN = getNgram, data = vector,
           simplify = FALSE, USE.NAMES = TRUE)
}

files <- list.files(source.path, recursive = TRUE,
                    patter = paste0("*charVec_rmSW", rmSW, ".Rdata"))
lapply(X = files, FUN = load.data, path = source.path)

# For each char vector source, find all the n-grams
n <- 2:max.Ngram
# ngrams <- sapply(X = char.vectors, FUN = getNgrams, n.list = n,
#                  simplify = FALSE, USE.NAMES = TRUE)
# ngrams <- lapply(X = ngrams, FUN = setNames, nm = n)

ngrams.all <- getNgrams(vector = all.char.vector, n.list = n)
ngrams.all <- setNames(ngrams.all, nm = n)

# Summarize into frequency table
# ngrams.freq <- rapply(ngrams, f = table, how = "list")
# ngrams.sorted.freq <- rapply(ngrams.freq, f = sort, how = "list", decreasing = TRUE)
ngrams.all.freq <- sapply(ngrams.all, FUN = table, USE.NAMES = TRUE)
ngrams.all.sorted.freq <- sapply(ngrams.all.freq, FUN = sort, decreasing = TRUE,
                                 USE.NAMES = TRUE)
ngrams.all.sorted.freq <- setNames(ngrams.all.sorted.freq, nm = n)

# save(ngrams, file = paste0(source.path, "ngrams.Rdata"))
# save(ngrams.all, file = paste0(source.path, "ngrams.all.Rdata"))
# save(ngrams.sorted.freq, file = paste0(source.path, "ngrams.sorted.freq.Rdata"))
save(ngrams.all.sorted.freq, file = paste0(source.path,
                                           "ngrams.all.sorted.freq_rmSW",
                                           rmSW, ".Rdata"))

# Clean workspace
remove(list = ls())
