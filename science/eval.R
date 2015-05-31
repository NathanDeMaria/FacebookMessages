
create_train_test <- function(comments, min_messages=250, balance=F) {
	train_prop <- 0.8
	
	# find people who have sent the minimum number of messages
	candidates <- comments[,list(count = length(text)), by = name][count > min_messages]$name

	
	if (balance) {
		# all people have the same proportions in the train and test sets
		top_ind <- floor(min_messages * train_prop)
		
		ind_groups <- sapply(candidates, function(candidate) {
			inds <- which(candidate == comments$name)
			inds <- sample(inds)
			list(train = inds[1:top_ind],
				 test = inds[(top_ind + 1):min_messages])
		})
		
		sets <- list(train = comments[unlist(ind_groups['train',]),], 
					 test = comments[unlist(ind_groups['test',]),])
	} else {
		# people have the same proportion of messages in the train 
		# and test sets as they as they do in the real dataset
		valid <- comments[name %in% candidates]
		valid <- valid[sample(1:nrow(valid)),]
		top_ind <- floor(train_prop * nrow(valid))
		sets <- list(train = valid[1:top_ind,], 
					 test = valid[(top_ind + 1):nrow(valid)])
	}
	
	sets
}

evaluate <- function(model_generator, min_messages = 250, balance=F, even_weighted=T, verbose=F, ...) {
	tt <- create_train_test(comments, min_messages = min_messages, balance = balance)
	predictor <- model_generator(tt$train, ...)
	tt$test$prediction <- predictor(tt$test)

	if (verbose) {
		# print confusion matrix
		print(table(tt$test$prediction, tt$test$name))
	}
	
	if (even_weighted) {
		# final accuracy is reported as proportion correct if each person was equally weighted
		scores <- tt$test[,list(score = mean(name == prediction, na.rm = T)), by = name]
		mean(scores$score)
	} else {
		# final accuracy is just proportion of total correct
		mean(tt$test$prediction == tt$test$name, na.rm = T)
	}
}