who_said <- function(regular_expr, by_pct=T) {
	post_counts <- comments[,length(text),by=name]
	match_counts <- comments[grep(regular_expr, text)][,length(text),by=name]
	setnames(post_counts, c('name', 'count'))
	setnames(match_counts, c('name', 'match_count'))
	setkey(post_counts, 'name')
	setkey(match_counts, 'name')
	merged <- merge(post_counts, match_counts)
	
	if(by_pct) {
		return(merged[,pct_match:=match_count/count][order(pct_match)])
	} else {
		return(merged[,pct_match:=match_count/count][order(match_count)])
	}	
}
