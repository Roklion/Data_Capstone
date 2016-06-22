## CleanData.R
if (!exists("CONFIG.LOADED")) source("Config.R")
source("CleanAlgo.R")

read.source <- function(filename, path)
{
    text <- scan(paste0(source.path, filename), what="char", sep="\n",
                 strip.white=TRUE, blank.lines.skip=TRUE,
                 encoding='UTF-8')
    
    return(text)
}

clean.char <- function(raw_text)
{
    return (clean.algo(raw_text, rmSW, "english"))
}

vectorize.text <- function(text, split)
{
    return (unlist(strsplit(text, split)))
}

# Read all files under specified source directory
files <- list.files(source.path, recursive = TRUE, pattern = "*.txt")
texts <- sapply(X = files, FUN = read.source, path = source.path,
                simplify = FALSE, USE.NAMES = TRUE)
# Simplify variable names
names(texts) <- substring(names(texts), 7, nchar(names(texts)) - 4)

# Clean up characters in the raw file
texts.clean <- sapply(X = texts, FUN = clean.char,
                      simplify = FALSE, USE.NAMES = TRUE)

# Break sentences into words, delimiting by spaces
char.vectors <- sapply(X = texts.clean, FUN = vectorize.text, split =" +",
                       simplify = FALSE, USE.NAMES = TRUE)
# Summary word vector into a frequency table
freq.tables <- sapply(X = char.vectors, FUN = table,
                      simplify = FALSE, USE.NAMES = TRUE)
# Sort frequency to high to low
sorted.freq <- sapply(X = freq.tables, FUN = sort, decreasing = TRUE,
                      simplify = FALSE, USE.NAMES = TRUE)

# Save processed dataset for future use
save(texts.clean, file = paste0(source.path,
                                "clean.text_rmSW", rmSW, ".Rdata"))
save(char.vectors, file = paste0(source.path,
                                 "clean.charVec_rmSW", rmSW, ".Rdata"))
save(freq.tables, file = paste0(source.path,
                                "clean.freqTable_rmSW", rmSW, ".Rdata"))
save(sorted.freq, file = paste0(source.path,
                                "clean.freqSorted_rmSW", rmSW, ".Rdata"))

# Clean workspace
remove(list = ls())
