library(dplyr)
library(lubridate)
library(magrittr)


url <- "http://data.moi.gov.tw/MoiOD/System/DownloadFile.aspx?DATA=39B53D95-8489-4DB3-8F31-1239FDC9ECD4"
download.file(url, destfile = "data/parades.csv")

raw <- read.csv("data/parades.csv", stringsAsFactors = F) %>% slice(2:n())

broken_rows <- raw[raw$actEndTime == "", ]  # some rows look not right
# raw[4267, ]
broken_row_indices <- broken_rows %>% rownames() %>% as.numeric() - 1

fix_broken_row <- function(df, i_row) {
    df[i_row, "placeOrRoute"] <- paste0(df[i_row, "placeOrRoute"], ",", df[i_row, "authorities"])
    df[i_row, "authorities"] <- df[i_row + 1, 1]
    return(df)
}

fixed <- raw
for (i in broken_row_indices) {
    fixed %<>% fix_broken_row(i)
}
fixed %<>% filter(!(row_number() %in% (broken_row_indices + 1)))

encode_utf8 <- function(col) `Encoding<-`(col, "UTF-8")

clean <- fixed %>% mutate_all(funs(encode_utf8)) %>% tbl_df()

parade <- clean %>% mutate_each(funs(ymd_hm), actStTime, actEndTime)

saveRDS(parade, "data/parade.Rds")
