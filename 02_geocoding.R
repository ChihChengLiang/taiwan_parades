library(googleway)

parade <- readRDS("data/parade.Rds")
df <- google_geocode(address = "嘉義縣布袋鎮樹林頭樹林小段240地號產業道路", key = key, 
    simplify = TRUE)

