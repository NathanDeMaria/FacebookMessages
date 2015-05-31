random_model <- function(train) {
	# just guesses someone, weighted by proportion in the training set
	# for use as a baseline to compare models to
	people <- train$name
	function(test) {
		sample(people, nrow(test), replace = T)
	}
}