library(RSQLite)

create_sqlite_accessor <- function(db_name) {
	db_operation <- function(func) {
		conn <- dbConnect(SQLite(), db_name)
		tryCatch({
			result <- func(conn = conn)
		}, finally = {
			dbDisconnect(conn)
		})
		result
	}
	
	create_table <- function(dat, table_name, id=NULL) {
		write_table <- function(conn) {
			tryCatch({
				dbWriteTable(conn, table_name, dat)
				if (!is.null(id)) {
					unique_query <- sprintf('CREATE UNIQUE INDEX %s_key on %s(%s)', 
											id, table_name, id)
					result <- dbSendQuery(conn, unique_query)
					dbClearResult(result)
				}
				TRUE
			}, error = function(e) {
				warning(paste('Table not created: ', e$message))
				FALSE
			})
		}
		
		db_operation(write_table)
	}
	
	
	append_table <- function(dat, table_name) {
		tmp_table <- sprintf('%s_tmp', table_name)
		
		merge_from_tmp <- function(conn) {
			
			dbWriteTable(conn, tmp_table, value = dat, row.names = FALSE, overwrite = T)
			db_query_fmt <- '
			INSERT OR IGNORE INTO %s
			SELECT * FROM %s
		'
			db_query <- sprintf(db_query_fmt, table_name, tmp_table)
			
			result <- dbSendQuery(conn, db_query)
			row_change <- dbGetRowsAffected(result)
			dbClearResult(result)
			
			dbRemoveTable(conn, tmp_table)
			row_change
		}
		db_operation(merge_from_tmp)
	}
	
	read_table <- function(table_name) {
		db_operation(function(conn) {
			dbReadTable(conn, table_name)
		})
	}

	list(create_table = create_table, append_table = append_table, read_table = read_table)	
}
