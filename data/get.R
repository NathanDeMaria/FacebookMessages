
library(httr)
library(data.table)
library(dplyr)
library(lubridate)

get_comments <- function(db_file='data/comments.db') {
	# if db_file already exists, appends to that db
	# otherwise, creates a new one
	
	source('config/app_config.R', local = T)
	source('data/sqlite.R', local = T)
	
	sqlite <- create_sqlite_accessor(db_file)
	
	# do me/inbox
	base_url <- 'https://graph.facebook.com'
	query <- '/me/inbox'
	
	url <- paste0(base_url, query, '?access_token=', get_config('token'))
	rsp <- content(GET(url))
	
	if (!is.null(rsp$error)) {
		stop(rsp$error)
	}
	
	datas <- rsp$data
	the_convo <- datas[[which(sapply(datas, function(dat) {dat$id == get_config('conversation_id')}))]]
	comments_list <- the_convo$comments
	
	parse_comment <- function(comment) {
		message <- comment$message
		if (is.null(message)) {
			message <- ''
		}
		data.frame(
				id = comment$id,
				name = comment$from$name,
				text = message,
				time = comment$created_time,
				stringsAsFactors = F
			)
	}
	
	list_to_df <- function(comments_list) {
		comments_frames <- lapply(comments_list$data, parse_comment)
		data.table(rbind_all(comments_frames))
	}
	
	comments_dt <- list_to_df(comments_list)
	
	if (file.exists(db_file)) {
		sqlite$append_table(comments_dt, table_name = 'comment')
	} else {
		sqlite$create_table(comments_dt, table_name = 'comment', id = 'id')
	}
	num_added <- nrow(comments_dt)
	
	i <- 1
	while (!is.null(comments_list$paging$`next`) && num_added > 0) {
		comments_list <- content(GET(comments_list$paging$`next`))
		Sys.sleep(2)
		if (!is.null(comments_list$error)) {
			warning(paste(comments_list$error$message, "\nYou probably did not get all the messages"))
		}
		comments_dt <- list_to_df(comments_list)
		if (nrow(comments_dt) > 0) {
			num_added <- sqlite$append_table(comments_dt, table_name = 'comment')
		}
		cat(sprintf('Round %i\n', i))
		i <- i + 1
	}
	
	comments <- data.table(sqlite$read_table('comment'))
	setkey(comments, 'id')
	comments
}