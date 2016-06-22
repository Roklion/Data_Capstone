## BuildModel.R
library(gdata)
library(parallel)
library(doParallel)
if (!exists("CONFIG.LOADED")) source("Config.R")

numCores <- min(8, detectCores() - 1)

subset.list <- function(in.list, max.idx, start = 1, min.freq)
{
    out.list <- in.list[start:max.idx]
    out.list <- out.list[out.list >= min.freq]
    
    return (out.list)
}

get.keys <- function(ngrams)
{
    rexp <- "^(.*)(\\s.*)$"
    keys <- sub(rexp,"\\1", names(ngrams))
    
    return (keys)
}

clean.keys <- function(raw, input)
{
    return (intersect(raw, names(input)))
}

next.prob <- function(word, outcomes, out.names)
{
    numchar <- nchar(word)
    next.words <- outcomes[(substr(out.names, 1, numchar) == word), ]
    
    sum_freq <- next.words / sum(next.words)
    names(sum_freq) <- substring(names(sum_freq), first = numchar + 1)
    sum_freq <- sort(sum_freq, decreasing = TRUE)
    
    # Only need up to 5 prediction
    return (sum_freq[1:min(5, length(sum_freq))])
}

get.prob <- function(word, ngrams)
{
    cl <- makeCluster(numCores)
 
    key <- paste0(word, " ")   
    probs <- parSapply(cl, X = key, FUN = next.prob, outcomes = ngrams,
                       out.names = rownames(ngrams),
                       simplify = TRUE, USE.NAMES = TRUE)
    names(probs) <- word

    stopCluster(cl)
    return (probs)
}

# Load word and n-gram vector frequency tables
files <- c(paste0("ngrams.all.sorted.freq_rmSW", rmSW, ".Rdata"),
           paste0("clean.all.freqSorted_rmSW", rmSW, ".Rdata"),
           paste0("summary_rmSW", rmSW, ".Rdata"))
lapply(X = files, FUN = load.data, path = source.path)

# Reduce size of words to work with (keep enough coverage while removing less
#  frequently used words)
coverage <- paste0("cover", max.cover)
idx_cover <- c(text.summary["SUM", coverage])
idx_cover <- c(idx_cover, Ngram.summary[1:(max.Ngram-2), coverage])

# Construct list of input (1~4-grams) and outcome (2~5-grams)
ngrams.inputs <- c()
ngrams.inputs$`1` <- all.sorted.freq
ngrams.inputs <- append(ngrams.inputs, ngrams.all.sorted.freq[1:(max.Ngram-2)])
ngrams.inputs <- mapply(FUN = subset.list, in.list = ngrams.inputs, 
                        max.idx = idx_cover, MoreArgs = list(min.freq = min.freq),
                        SIMPLIFY = TRUE, USE.NAMES = TRUE)
idx_cover <- Ngram.summary[, coverage]
ngrams.outcomes <- mapply(FUN = subset.list, in.list = ngrams.all.sorted.freq, 
                          max.idx = idx_cover, MoreArgs = list(min.freq = min.freq),
                          SIMPLIFY = TRUE, USE.NAMES = TRUE)

keyset <- sapply(X = ngrams.outcomes, FUN = get.keys,
                 simplify = TRUE, USE.NAMES = TRUE)
keyset <- mapply(FUN = clean.keys, raw = keyset, input = ngrams.inputs,
                 SIMPLIFY = TRUE, USE.NAMES = TRUE)

df.outcomes <- sapply(X = ngrams.outcomes, FUN = data.frame,
                      simplify = FALSE, USE.NAMES = TRUE)

# FOR LOOP is faster in this case
next.predict <- c()
for (i in 1:(max.Ngram-1))
{
    next.predict[[i]] <- get.prob(word = keyset[[i]], ngrams = df.outcomes[[i]])
}
next.predict <- unlist(next.predict, recursive = FALSE, use.names = TRUE)

save(next.predict, file = paste0(source.path, file.predict.tb))

# Clean workspace
remove(list = ls())
