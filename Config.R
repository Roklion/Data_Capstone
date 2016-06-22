## SetConfig.R
CONFIG.LOADED = TRUE

# data path
data.path <- "./data/"
file.dir <- "en_US/"
source.path <- paste0(data.path, file.dir)

# Load data from filename and path
load.data <- function(filename, path)
{
    load(paste0(path, filename), envir = .GlobalEnv)
}

# Clean params
rmSW <- FALSE

# N grams
max.Ngram <- 5

# Data Reduction
# unique words should cover max. 99% of text and with min. freq of 3 times
max.cover <- 99
min.freq <- 3

# Predict file
file.predict.tb = paste0("predict_ngm", max.Ngram, "_cv", max.cover,
                         "_frq", min.freq, "_rmSW", rmSW, ".Rdata")
file.predict.result = paste0("result_ngm", max.Ngram, "_cv", max.cover,
                             "_frq", min.freq, "_rmSW", rmSW, ".Rdata")