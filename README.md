# Facebook Message Analysis

This is an R project for gathering and analyzing Facebook group messages.

## Data Gathering

This project lets you save Facebook group messages in a SQLite database. To do so, a few configuration things need to be set up first.

### Configuration
See the README.md in `config/` for detailed instructions on setting up configuration. Basically, you put a `config.xml` file in that folder, using the same format as `sample_config.xml` and fill in values for `token` and `conversation_id`.

### Getting Data
Source the `data/get.R` script to load the `get_comments` function. Running `get_comments()` will trace backward through the conversation specified in `config.xml` and save messages in `data/comments.db` by default. The Facebook API traces back through pages of around 25 messages at a time. The `get_comments` function will update the database by tracing back through these pages until it hits messages that have already been stored in the database.

You can then run `data/load.R` to load the default database into a `data.table` named `comments`.

## Analysis
In the `science/` directory, there are some scripts for analyzing the `comments` data.table.  The `analyses.R` has some basic functions for counting who said what.

### Classification
The rest of the scripts in the `science/` directory are for creating classifiers that predict who said a message. A few simple classifiers can be found in `science/models`. They both follow the same format: take in a training set as a parameter, and return a function that gives predictions from new input messages.

The `eval.R` script has methods for creating training and tests sets, and evaluating how a classifier trained on the training set performs on a the test set. The `compare.R` script uses these methods to compare how different classifiers do.
