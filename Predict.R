## Predict.R
if (!exists("CONFIG.LOADED")) source("Config.R")
source("ModelInput.R")
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

load.data(filename = file.predict.tb, path = source.path)

inputs.clean <- clean.algo(inputs, rmSW, "english")

predictions <- sapply(X = inputs.clean, FUN = get.next,
                      simplify = TRUE, USE.NAMES = TRUE)

save(predictions, file = paste0(source.path, file.predict.result))

# Clean workspace
remove(list = ls())
