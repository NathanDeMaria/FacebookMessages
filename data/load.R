library(RSQLite)
library(data.table)

comments <- (function() {
	conn <- dbConnect(SQLite(), "data/comments.db")
	comments <- data.table(dbReadTable(conn, "comment"))
	dbDisconnect(conn)
	rm(conn)
	comments
})()