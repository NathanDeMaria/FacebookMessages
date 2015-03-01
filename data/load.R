library(RSQLite)

conn <- dbConnect(SQLite(), "data/comments.db")
comments <- data.table(dbReadTable(conn, "comments"))
dbDisconnect(conn)
rm(conn)