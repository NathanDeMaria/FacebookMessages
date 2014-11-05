
library(httr)
library(data.table)
library(dplyr)

source('app_settings.R')

# do me/inbox
base_url <- 'https://graph.facebook.com'
query <- '/me/inbox'

url <- paste0(base_url, query, '?access_token=', app_settings['token']$value)
rsp <- content(GET(url))

datas <- rsp$data
the_convo <- datas[[which(sapply(datas, function(dat) {dat$id == app_settings['conversation_id']$value}))]]
comments_list <- the_convo$comments

parse_comment <- function(comment) {
	message <- comment$message
	if(is.null(message)){
		message <- ''
	}
	data.frame(
			id = comment$id,
			name = comment$from$name,
			text = message,
			time = comment$created_time,
			stringsAsFactors=F
		)
}

comments_frames <- lapply(comments_list$data, parse_comment)

while(!is.null(comments_list$paging$`next`)) {
	comments_list <- content(GET(comments_list$paging$`next`))
	comments_frames <- c(comments_frames, lapply(comments_list$data, parse_comment))
}

comments <- data.table(rbind_all(comments_frames))
comments[,time:=ymd_hms(time)]





