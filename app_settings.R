library(data.table)

app_settings <- fread('appSettings.csv')
setkey(app_settings, 'key')