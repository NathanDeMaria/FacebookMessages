
create_train_test <- function(comments, min_messages=250, balance=F) {
	train_prop <- 0.8
	
	candidates <- comments[,list(count = length(text)), by = name][count > min_messages]$name

	
	if (balance) {
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
		valid <- comments[name %in% candidates]
		valid <- valid[sample(1:nrow(valid)),]
		top_ind <- floor(train_prop * nrow(valid))
		sets <- list(train = valid[1:top_ind,], 
					 test = valid[(top_ind + 1):nrow(valid)])
	}
	
	sets
}

evaluate <- function(model_generator, balance=F, verbose=F, ...) {
	tt <- create_train_test(comments, balance = balance)
	predictor <- model_generator(tt$train, ...)
	predictions <- predictor(tt$test)
	
	if (verbose) {
		# print confusion matrix
		print(table(predictions, tt$test$name))
	}
	
	mean(predictions == tt$test$name, na.rm = T)
}