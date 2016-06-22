library(NLP)
library(wordcloud)
library(RColorBrewer)

# Load files
f_en.blogs <- scan("./data/en_US/en_US.blogs.txt", what="char", sep="\n", 
                   strip.white=TRUE, blank.lines.skip=TRUE,encoding = 'UTF-8')
# Remove all non-graphic characters
en.blogs <- gsub("[^[:graph:]]", " ", f_en.blogs)
en.blogs <- tolower(en.blogs)
# Replace everything not belonging to one of the non-alphabetic chars, space
#  and ' with a single space
en.blogs <- gsub("[^[:alnum:][:space:]']", " ", en.blogs)
en.blogs <- gsub(" \'|\' ", " ", en.blogs)
en.blogs <- gsub("\\d+", " ", en.blogs)
en.blogs <- gsub("\\s+", " ", en.blogs)
en.blogs <- gsub("[ \t]+$", "", en.blogs)
# Break sentences into words, delimiting by spaces
en.blogs.list <- strsplit(en.blogs, " +")
en.blogs.vector <- unlist(en.blogs.list)
# Summary word vector into a table
en.blogs.freq <- table(en.blogs.vector)
en.blogs.sorted.freq <- sort(en.blogs.freq, decreasing = TRUE)
# # basic stats of the word frequency
# summary(en.blogs.sorted.freq)
# # Number of words with more frequent usage
# length(en.blogs.sorted.freq[en.blogs.sorted.freq > 20])
# length(en.blogs.sorted.freq[en.blogs.sorted.freq > 50])
# length(en.blogs.sorted.freq[en.blogs.sorted.freq > 100])
# length(en.blogs.sorted.freq[en.blogs.sorted.freq > 1000])
# # Distribution of word frequency
# hist(head(en.blogs.sorted.freq, 50000), xlim=c(100, 2000), breaks=100000)

# Find unique word coverage
word_ct.blogs <- length(en.blogs.vector)
# Find number of top used unique words to cover 50% of all texts
acc_words <- 0
cover_count <- 0
while (acc_words < 0.5*word_ct.blogs) {
    cover_count <- cover_count + 1
    acc_words <- acc_words + en.blogs.sorted.freq[[cover_count]]
}
cover50.blogs <- cover_count
while (acc_words < 0.9*word_ct.blogs) {
    cover_count <- cover_count + 1
    acc_words <- acc_words + en.blogs.sorted.freq[[cover_count]]
}
cover90.blogs <- cover_count


# bigram.blogs <- vapply(ngrams(en.blogs.vector, n = 2), paste, "", collapse = " ")
# bigram.blogs_freq <- table(bigram.blogs)
# bigram.blogs_freq_sorted <- sort(bigram.blogs_freq, decreasing = TRUE)

df_unigram.blogs <- data.frame(word = names(en.blogs.sorted.freq),
                               frequency = en.blogs.sorted.freq,
                               row.names = NULL)
# df_bigram.blogs <- data.frame(word = names(bigram.blogs_freq_sorted),
#                               frequency = bigram.blogs_freq_sorted,
#                               row.names = NULL)
pal <- brewer.pal(8, "Dark2")
wordcloud(df_unigram.blogs$word, df_unigram.blogs$frequency, 
          scale=c(3.5,0.7), min.freq=100, max.words = 100,
          colors=pal, random.color = FALSE, ordered.colors = FALSE)
