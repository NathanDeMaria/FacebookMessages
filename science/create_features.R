library(stringr)
library(magrittr)

create_features <- function(dataset, n) {
	# find the top n words
	top_n <- function(n) {
		words <- unlist(str_split(dataset$text, ' '))
		word_counts <- table(words)
		word_dt <- data.table(word = names(word_counts), count = as.numeric(word_counts))
		tops <- word_dt[order(count, decreasing = T)[seq_len(n)]]
		tops$word
	}
	
	create_top_words_matrix <- function(top_words) {
		top_matrix <- dataset[,sapply(top_words, function(word) {
			regex_safe <- str_replace_all(word, "(\\W)", "\\\\\\1")
			grepl(pattern = regex_safe, x = text)
		})]
		top_matrix <- data.table(top_matrix)
		
		# clean the names
		setnames(top_matrix, paste0('col_', as.character(seq_along(top_words))))
		
		# 1 or 0 instead of T/F
		top_matrix[,colnames(top_matrix) := lapply(.SD, as.numeric), .SDcols = seq_along(top_words)]
		
		top_matrix[,key_name := factor(dataset$name)]
		top_matrix	
	}
	
	more_features <- function(messages) {
		words <- str_split(messages, ' ')
		
		num_words <- sapply(words, length)
		
		word_length <- sapply(words, function(x) {mean(nchar(x))})
		
		non_alnums <- sapply(messages, function(message) {
			# find message without alphanumeric chars
			less <- gsub('[a-zA-Z0-9 ]', '', message)
			nchar(less)
		})
		
		capitals <- sapply(messages, function(message) {
			# find message without alphanumeric chars
			less <- gsub('[A-Z]', '', message)
			nchar(message) - nchar(less)
		})
		
		list(num_words, word_length, non_alnums, capitals)
	}

	top_words <- top_n(n)
	top_matrix <- create_top_words_matrix(top_words)
	top_matrix[,c('num_words', 'word_length', 'non_alnums', 'capitals') := more_features(dataset$text)]
	top_matrix	
}