library(randomForest)

random_forest_model <- function(train, n=50) {
	source('science/create_features.R', local = T)
	feature_matrix <- create_features(train, n)
	forrest <- randomForest(key_name ~ ., data = feature_matrix)
	function(test) {
		test_features <- create_features(test, n)
		predict(forrest, newdata = test_features)
	}
}
