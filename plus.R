# lots of half done stuff about +1 and ++'s

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

# people who have given +1's
plus_ones <- table(comments[regexpr('\\+1', text) > 0, name])
plus_ones[order(plus_ones, decreasing = T)]


comments[,pure_plusone:=regexpr('^\\+1$', text) > 0]

find_plusone_source <- function(index) {
	non_plusones <- which(!comments$pure_plusone)
	max(non_plusones[non_plusones < index])
}

plus_one_indices <- which(comments$pure_plusone)
plus_one_recipients <- sapply(plus_one_indices, find_plusone_source)
recipients <- table(comments$name[plus_one_recipients])
print(recipients[order(recipients, decreasing = T)])
