source('data/load.R')
source('science/eval.R')

source('science/models/textcat.R')
source('science/models/random_forest.R')

models <- list(
	list(model_generator = textcat_model),
	list(model_generator = random_forest_model, n = 25),
	list(model_generator = random_forest_model, n = 50),
	list(model_generator = random_forest_model, n = 100)
)

df <- data.frame(t(sapply(models, function(args) {
	do.call(evaluate, c(args, min_messages = 500))
})))

df$model <- models
