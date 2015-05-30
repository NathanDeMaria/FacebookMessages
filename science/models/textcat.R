library(textcat)

textcat_model <- function(training) {
	profile_db <- textcat_profile_db(x = training$text, id = training$name)
	function(test) {
		textcat(test$text, profile_db)
	}
}