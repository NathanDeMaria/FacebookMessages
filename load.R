library(RSQLite)

conn <- dbConnect(SQLite(), "comments.db")
comments <- data.table(dbReadTable(conn, "comments"))
dbDisconnect(conn)
rm(conn)