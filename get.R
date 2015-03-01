
library(httr)
library(data.table)
library(dplyr)
library(lubridate)

get_comments <- function(max_date=NULL) {
	source('app_settings.R', local=T)
	
	# do me/inbox
	base_url <- 'https://graph.facebook.com'
	query <- '/me/inbox'
	
	url <- paste0(base_url, query, '?access_token=', app_settings['token']$value)
	rsp <- content(GET(url))
	
	if(!is.null(rsp$error)) {
		stop(rsp$error)
	}
	
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
	
	date_ok <- function() {
		if(is.null(max_date)) {
			return(T)
		}
		last_frame <- comments_frames[[length(comments_frames)]]
		times <- ymd_hms(last_frame$time)
		min(times) > max_date - days(1) # extra day of overlap just in case
	}
	
	comments_frames <- lapply(comments_list$data, parse_comment)
	i <- 1
	while(!is.null(comments_list$paging$`next`) && date_ok()) {
		comments_list <- content(GET(comments_list$paging$`next`))
		Sys.sleep(2)
		if(!is.null(comments_list$error)) {
			warning(paste(comments_list$error$message, "\nYou probably did not get all the messages"))
		}
		comments_frames <- c(comments_frames, lapply(comments_list$data, parse_comment))
		cat(sprintf('Round %i\n', i))
		i <- i + 1
	}
	
	comments <- data.table(rbind_all(comments_frames))
	comments[,time:=ymd_hms(time)]
	setkey(comments, id)
	comments
}