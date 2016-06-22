## Analysis.R
if (!exists("CONFIG.LOADED")) source("Config.R")

wordcoverage <- function(sorted.freq, cover = 0.5, word_ct = sum(sorted.freq))
{
    acc_words <- 0
    cover_count <- 0
    word_cap <- cover * word_ct
    while (acc_words < word_cap) {
        cover_count <- cover_count + 1
        # Add count of the next frequently used word
        acc_words <- acc_words + sorted.freq[[cover_count]]
    }
    
    return(cover_count)
}

# Reload clean datasets
files <- list.files(source.path, recursive = TRUE,
                    pattern = paste0("clean.*_rmSW", rmSW, ".Rdata"))
lapply(X = files, FUN = load.data, path = source.path)

# Line count
line_ct <- lapply(texts.clean, FUN = length)
line_ct$all <- sum(unlist(line_ct))
# Word count
word_ct <- lapply(char.vectors, FUN = length)
word_ct$all <- sum(unlist(word_ct))
# Unique word count
word.unique <- lapply(freq.tables, FUN = length)
word.unique$all <- length(all.freq.table)
# Word coverage
cover50 <- sapply(sorted.freq, FUN = wordcoverage, cover = 0.5,
                  simplify = TRUE, USE.NAMES = TRUE)
cover50["all"] <- wordcoverage(all.sorted.freq, cover = 0.5)
cover90 <- sapply(sorted.freq, FUN = wordcoverage, cover = 0.9,
                  simplify = TRUE, USE.NAMES = TRUE)
cover90["all"] <- wordcoverage(all.sorted.freq, cover = 0.9)
cover99 <- sapply(sorted.freq, FUN = wordcoverage, cover = 0.99,
                  simplify = TRUE, USE.NAMES = TRUE)
cover99["all"] <- wordcoverage(all.sorted.freq, cover = 0.99)

text.summary <- data.frame(row.names = c("twitter", "blogs", "news", "SUM"),
                           numLines = unlist(line_ct), numWords = unlist(word_ct),
                           numUnigram = unlist(word.unique),
                           cover50, cover90, cover99)

# Clean workspace
objects_rm <- ls()
objects_rm <- objects_rm[!(objects_rm %in% c("text.summary", "word_ct",
                                             "wordcoverage"))]
# Clean workspace
remove(list = objects_rm)

# Reload configuration
if (!exists("CONFIG.LOADED")) source("Config.R")

# Summarize N-grams
files <- list.files(source.path, recursive = TRUE,
                    pattern = paste0("ngrams.*_rmSW", rmSW, ".Rdata"))
lapply(X = files, FUN = load.data, path = source.path)

Ngram.names <- paste0(2:max.Ngram, "-grams")
Ngram.ct <- sapply(ngrams.all.sorted.freq, FUN = length,
                   simplify = TRUE, USE.NAMES = TRUE)

cover50 <- sapply(ngrams.all.sorted.freq, FUN = wordcoverage, cover = 0.5,
                  word_ct = word_ct$all, simplify = TRUE, USE.NAMES = TRUE)
cover90 <- sapply(ngrams.all.sorted.freq, FUN = wordcoverage, cover = 0.9,
                  word_ct = word_ct$all, simplify = TRUE, USE.NAMES = TRUE)
cover99 <- sapply(ngrams.all.sorted.freq, FUN = wordcoverage, cover = 0.99,
                  word_ct = word_ct$all, simplify = TRUE, USE.NAMES = TRUE)

Ngram.summary <- data.frame(row.names = unlist(Ngram.names),
                            unique.count = unlist(Ngram.ct),
                            cover50, cover90, cover99)

save(text.summary, Ngram.summary, file = paste0(source.path, "summary_rmSW",
                                                rmSW, ".Rdata"))

# Clean workspace
remove(list = ls())
