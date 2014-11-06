
library(stringr)
source('get.R')

comments <- get_comments()

plussed <- lapply(comments$text, function(message_text) {
	
	# split into words
	words <- unlist(str_split(message_text, '\\s+'))
	
	matches <- words[regexpr('\\+\\+', words) > 0]
	
	matches <- gsub('\\+\\+', '', matches)
	matches <- gsub('[[:punct:]]', '', matches)
	matches <- gsub('[[:cntrl:]]', '', matches)
	matches <- gsub('\\d+', '', matches)
	matches <- iconv(matches, 'ASCII', sub = "byte")
	tolower(matches)
})

plus_table <- table(unlist(plussed))
print(plus_table[order(plus_table, decreasing = T)])
