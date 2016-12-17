## Predict.R
if (!exists("CONFIG.LOADED")) source("Config.R")
source("CleanAlgo.R")

input.str <- function(num.words.in, in.text, n)
{
    return (paste(in.text[(n - num.words.in + 1):n], collapse = " "))
}

get.next <- function(text)
{
    text.vec <- unlist(strsplit(text, " +"))
    total.words <- length(text.vec)
    in.string <- sapply(1:min(total.words, max.Ngram-1), FUN = input.str,
                        in.text = text.vec, n = total.words,
                        simplify = TRUE, USE.NAMES = FALSE)
    
    return (sort(unlist(next.predict[in.string]), decreasing = TRUE))
}

clean.predict <- function(raw)
{
    predict.clean <- list()
    for(predict in names(raw))
    {
        #print(predict)
        key <- unlist(strsplit(predict, '.', fixed=TRUE))[2]
        if(is.null(predict.clean[[key]]))
        {
            predict.clean[key] <- raw[[predict]]
        }
        else
        {
            predict.clean[key] <- max(raw[[predict]], predict.clean[[key]])
        }
    }
    return (predict.clean)
}

