source('data/load.R')
source('science/eval.R')

source('science/models/textcat.R')
source('science/models/random_forest.R')


textcat_score <- evaluate(textcat_model, min_messages = 0)
small_forest <- evaluate(random_forest_model, n = 25, min_messages = 0)
large_forest <- evaluate(random_forest_model, n = 50, min_messages = 0)
largest_forest <- evaluate(random_forest_model, n = 100, min_messages = 0)