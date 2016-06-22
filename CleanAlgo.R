## CleanAlgo.R
library(qdap)
library(tm)

clean.algo <- function(raw_text, rmSW, language = "english")
{
    # Special version of '
    text <- gsub(intToUtf8(8217), "\'", raw_text)
    
    # Remove all non-graphic characters
    text <- gsub("[^[:graph:]]", " ", text)
    text <- tolower(text)
    
    # Replace everything not belonging to one of the non-letter chars, space
    #  and ' with a single space, also replace ' as quotation marks with space
    text <- gsub("[^[:alpha:][:space:]\']| \'|\' ", " ", text)
    # Remove excess spaces
    text <- gsub("\\s+", " ", text)
    # Remove other ' and leading and trailing spaces
    text <- gsub("\'+|[ \t]+$|^[ \t]+", "", text)
    
    # Revmoe stopwords (common words)
    if (rmSW == TRUE)
    {
        text <- text %sw% tm::stopwords(language)        
    }
    
    return(text)
}
