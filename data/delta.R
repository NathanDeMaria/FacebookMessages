run_delta <- function() {
	library(RSQLite)
	
	source('data/get.R', local=T)
	conn <- dbConnect(SQLite(), "data/comments.db")
	max_seconds <- dbGetQuery(conn, "SELECT MAX(time) FROM comments")
	max_date_time <- as.POSIXct(max_seconds[1,1], origin='1970/01/01')
	
	new_comments <- get_comments(max_date_time)
	delta <- new_comments[max_date_time < time]
	
	dbWriteTable(conn, "comments", delta, append=T)
	dbDisconnect(conn)
}