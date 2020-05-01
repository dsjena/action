library(usethis)
library(jsonlite)
`%>%` <- magrittr::`%>%`

conf_url <- "csv/jhu_time_series_covid19_confirmed_global.csv"
raw_conf <- read.csv(file = conf_url,
                     stringsAsFactors = FALSE)

lapply(1:ncol(raw_conf), function(i){
  if(all(is.na(raw_conf[, i]))){
    raw_conf <<- raw_conf[, -i]
    return(print(paste("Column", names(raw_conf)[i], "is missing", sep = " ")))
  } else {
    return(NULL)
  }
})

df_conf <- raw_conf[, 1:4]

for(i in 5:ncol(raw_conf)){

  raw_conf[,i] <- as.integer(raw_conf[,i])
  # raw_conf[,i] <- ifelse(is.na(raw_conf[, i]), 0 , raw_conf[, i])
  print(names(raw_conf)[i])

  if(i == 5){
    df_conf[[names(raw_conf)[i]]] <- raw_conf[, i]
  } else {
    df_conf[[names(raw_conf)[i]]] <- raw_conf[, i] - raw_conf[, i - 1]
  }


}

head(df_conf)

df_conf1 <-  df_conf %>% tidyr::pivot_longer(cols = dplyr::starts_with("X"),
                                             names_to = "date_temp",
                                             values_to = "cases_temp")

# Parsing the date
df_conf1$month <- sub("X", "",
                      strsplit(df_conf1$date_temp, split = "\\.") %>%
                        purrr::map_chr(~.x[1]) )

df_conf1$day <- strsplit(df_conf1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[2])

df_conf1$date <- as.Date(paste("2020", df_conf1$month, df_conf1$day, sep = "-"))

# Aggregate the data to daily
df_conf2 <- df_conf1 %>%
  dplyr::group_by(Province.State, Country.Region, Lat, Long, date) %>%
  dplyr::summarise(cases = sum(cases_temp)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(type = "confirmed",
                Country.Region = trimws(Country.Region),
                Province.State = trimws(Province.State))


head(df_conf2)
tail(df_conf2)

#--------------------------
death_url <- "csv/jhu_time_series_covid19_deaths_global.csv"
raw_death <- read.csv(file =death_url,
                      stringsAsFactors = FALSE,
                      fill =FALSE)

lapply(1:ncol(raw_death), function(i){
  if(all(is.na(raw_death[, i]))){
    raw_death <<- raw_death[, -i]
    return(print(paste("Column", names(raw_death)[i], "is missing", sep = " ")))
  } else {
    return(NULL)
  }
})

df_death <- raw_death[, 1:4]

for(i in 5:ncol(raw_death)){
  print(i)
  raw_death[,i] <- as.integer(raw_death[,i])
  raw_death[,i] <- ifelse(is.na(raw_death[, i]), 0 , raw_death[, i])

  if(i == 5){
    df_death[[names(raw_death)[i]]] <- raw_death[, i]
  } else {
    df_death[[names(raw_death)[i]]] <- raw_death[, i] - raw_death[, i - 1]
  }
}

df_death1 <-  df_death %>% tidyr::pivot_longer(cols = dplyr::starts_with("X"),
                                               names_to = "date_temp",
                                               values_to = "cases_temp")

# Parsing the date
df_death1$month <- sub("X", "",
                       strsplit(df_death1$date_temp, split = "\\.") %>%
                         purrr::map_chr(~.x[1]) )

df_death1$day <- strsplit(df_death1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[2])


df_death1$date <- as.Date(paste("2020", df_death1$month, df_death1$day, sep = "-"))

# Aggregate the data to daily
df_death2 <- df_death1 %>%
  dplyr::group_by(Province.State, Country.Region, Lat, Long, date) %>%
  dplyr::summarise(cases = sum(cases_temp)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(type = "death",
                Country.Region = trimws(Country.Region),
                Province.State = trimws(Province.State))

head(df_death2)
tail(df_death2)
#============ Recovery =====================
raw_rec <- read.csv(file = "csv/jhu_time_series_covid19_recovered_global.csv",
                    stringsAsFactors = FALSE,
                    fill =FALSE)

lapply(1:ncol(raw_rec), function(i){
  if(all(is.na(raw_rec[, i]))){
    raw_rec <<- raw_rec[, -i]
    return(print(paste("Column", names(raw_rec)[i], "is missing", sep = " ")))
  } else {
    return(NULL)
  }
})
df_rec <- raw_rec[, 1:4]

for(i in 5:ncol(raw_rec)){
  print(i)
  raw_rec[,i] <- as.integer(raw_rec[,i])
  raw_rec[,i] <- ifelse(is.na(raw_rec[, i]), 0 , raw_rec[, i])

  if(i == 5){
    df_rec[[names(raw_rec)[i]]] <- raw_rec[, i]
  } else {
    df_rec[[names(raw_rec)[i]]] <- raw_rec[, i] - raw_rec[, i - 1]
  }
}


df_rec1 <-  df_rec %>% tidyr::pivot_longer(cols = dplyr::starts_with("X"),
                                           names_to = "date_temp",
                                           values_to = "cases_temp")

# Parsing the date
df_rec1$month <- sub("X", "",
                     strsplit(df_rec1$date_temp, split = "\\.") %>%
                       purrr::map_chr(~.x[1]) )

df_rec1$day <- strsplit(df_rec1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[2])


df_rec1$date <- as.Date(paste("2020", df_rec1$month, df_rec1$day, sep = "-"))

# Aggregate the data to daily
df_rec2 <- df_rec1 %>%
  dplyr::group_by(Province.State, Country.Region, Lat, Long, date) %>%
  dplyr::summarise(cases = sum(cases_temp)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(type = "recovered",
                Country.Region = trimws(Country.Region),
                Province.State = trimws(Province.State))

head(df_rec2)
tail(df_rec2)

worlddata <- dplyr::bind_rows(df_conf2, df_death2, df_rec2) %>%
  as.data.frame()

head(worlddata)
tail(worlddata)

#x <- 1
#y <- 2
#use_data(world)
usethis::use_data(worlddata, overwrite = TRUE, compress = "gzip")
write.csv(worlddata, "./data/worlddata.csv", row.names = FALSE)
write_json(worlddata, "./data/worlddata.json")


# --------------------------- India ----------------------------
#
#
#
#
#
#---------------------------------------------------------------

ind_conf <- read.csv(file = "csv/IndianStateTotalR.csv",
                     stringsAsFactors = FALSE)

head(ind_conf)
lapply(1:ncol(ind_conf), function(i){
  if(all(is.na(ind_conf[, i]))){
    ind_conf <<- ind_conf[, -i]
    return(print(paste("Column", names(ind_conf)[i], "is missing", sep = " ")))
  } else {
    return(NULL)
  }
})

dfi_conf <- ind_conf[, 1:4]

for(i in 5:ncol(ind_conf)){

  ind_conf[,i] <- as.integer(ind_conf[,i])
  # raw_conf[,i] <- ifelse(is.na(raw_conf[, i]), 0 , raw_conf[, i])
  print(names(ind_conf)[i])

  if(i == 5){
    dfi_conf[[names(ind_conf)[i]]] <- ind_conf[, i]
  } else {
    dfi_conf[[names(ind_conf)[i]]] <- ind_conf[, i] - ind_conf[, i - 1]
  }


}

head(dfi_conf)


dfi_conf1 <-  dfi_conf %>% tidyr::pivot_longer(cols = dplyr::starts_with("X"),
                                             names_to = "date_temp",
                                             values_to = "cases_temp")

head(dfi_conf1)

# Parsing the date
dfi_conf1$year <- sub("X", "",
                      strsplit(dfi_conf1$date_temp, split = "\\.") %>%
                        purrr::map_chr(~.x[1]) )

dfi_conf1$month <- strsplit(dfi_conf1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[2])

dfi_conf1$day <- strsplit(dfi_conf1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[3])

dfi_conf1$hour <- strsplit(dfi_conf1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[4])

dfi_conf1$min <- strsplit(dfi_conf1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[5])

dfi_conf1$sec <- strsplit(dfi_conf1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[6])

head(dfi_conf1$year)
head(dfi_conf1$month)
head(dfi_conf1$day)
head(dfi_conf1$hour)
head(dfi_conf1$min)
head(dfi_conf1$sec)



dfi_conf1$date <- as.Date(paste(dfi_conf1$year, dfi_conf1$month, dfi_conf1$day, sep = "-"))

head(dfi_conf1$date)
# Aggregate the data to daily
dfi_conf2 <- dfi_conf1 %>%
  dplyr::group_by(State, Code, Latitude, Longitude, date) %>%
  dplyr::summarise(cases = sum(cases_temp)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(type = "confirmed",
                State = trimws(State))


head(dfi_conf2)
tail(dfi_conf2)

#--------------------------

ind_death <- read.csv(file ="csv/IndianStateDeathsR.csv",
                      stringsAsFactors = FALSE,
                      fill =FALSE)

lapply(1:ncol(ind_death), function(i){
  if(all(is.na(ind_death[, i]))){
    ind_death <<- ind_death[, -i]
    return(print(paste("Column", names(ind_death)[i], "is missing", sep = " ")))
  } else {
    return(NULL)
  }
})

dfi_death <- ind_death[, 1:4]

for(i in 5:ncol(ind_death)){
  print(i)
  ind_death[,i] <- as.integer(ind_death[,i])
  ind_death[,i] <- ifelse(is.na(ind_death[, i]), 0 , ind_death[, i])

  if(i == 5){
    dfi_death[[names(ind_death)[i]]] <- ind_death[, i]
  } else {
    dfi_death[[names(ind_death)[i]]] <- ind_death[, i] - ind_death[, i - 1]
  }
}

dfi_death1 <-  dfi_death %>% tidyr::pivot_longer(cols = dplyr::starts_with("X"),
                                               names_to = "date_temp",
                                               values_to = "cases_temp")

# Parsing the date
dfi_death1$year <- sub("X", "",
                        strsplit(dfi_death1$date_temp, split = "\\.") %>%
                          purrr::map_chr(~.x[1]) )

dfi_death1$month <- sub("X", "",
                       strsplit(dfi_death1$date_temp, split = "\\.") %>%
                         purrr::map_chr(~.x[2]) )

dfi_death1$day <- strsplit(dfi_death1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[3])


dfi_death1$date <- as.Date(paste(dfi_death1$year, dfi_death1$month, dfi_death1$day, sep = "-"))

# Aggregate the data to daily
dfi_death2 <- dfi_death1 %>%
  dplyr::group_by(State, Code, Latitude, Longitude, date) %>%
  dplyr::summarise(cases = sum(cases_temp)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(type = "death",
                State = trimws(State))

head(dfi_death2)
tail(dfi_death2)
#============ Recovery =====================
ind_rec <- read.csv(file = "csv/IndianStateRecoveredR.csv",
                    stringsAsFactors = FALSE,
                    fill =FALSE)

lapply(1:ncol(ind_rec), function(i){
  if(all(is.na(ind_rec[, i]))){
    ind_rec <<- ind_rec[, -i]
    return(print(paste("Column", names(ind_rec)[i], "is missing", sep = " ")))
  } else {
    return(NULL)
  }
})
dfi_rec <- ind_rec[, 1:4]

for(i in 5:ncol(ind_rec)){
  print(i)
  ind_rec[,i] <- as.integer(ind_rec[,i])
  ind_rec[,i] <- ifelse(is.na(ind_rec[, i]), 0 , ind_rec[, i])

  if(i == 5){
    dfi_rec[[names(ind_rec)[i]]] <- ind_rec[, i]
  } else {
    dfi_rec[[names(ind_rec)[i]]] <- ind_rec[, i] - ind_rec[, i - 1]
  }
}


dfi_rec1 <-  dfi_rec %>% tidyr::pivot_longer(cols = dplyr::starts_with("X"),
                                           names_to = "date_temp",
                                           values_to = "cases_temp")

# Parsing the date
dfi_rec1$year <- sub("X", "",
                      strsplit(dfi_rec1$date_temp, split = "\\.") %>%
                        purrr::map_chr(~.x[1]) )

dfi_rec1$month <- sub("X", "",
                     strsplit(dfi_rec1$date_temp, split = "\\.") %>%
                       purrr::map_chr(~.x[2]) )

dfi_rec1$day <- strsplit(dfi_rec1$date_temp, split = "\\.") %>%
  purrr::map_chr(~.x[3])


dfi_rec1$date <- as.Date(paste(dfi_rec1$year, dfi_rec1$month, dfi_rec1$day, sep = "-"))

# Aggregate the data to daily
dfi_rec2 <- dfi_rec1 %>%
  dplyr::group_by(State, Code, Latitude, Longitude, date) %>%
  dplyr::summarise(cases = sum(cases_temp)) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(type = "recovered",
                State = trimws(State))


head(dfi_rec2)
tail(dfi_rec2)

indiadata <- dplyr::bind_rows(dfi_conf2, dfi_death2, dfi_rec2) %>%
  as.data.frame()

head(indiadata)
tail(indiadata)

#x <- 1
#y <- 2
#use_data(world)
usethis::use_data(indiadata, overwrite = TRUE, compress = "gzip")

write.csv(worlddata, "./data/indiadata.csv", row.names = FALSE)
write_json(worlddata, "./data/indiadata.json")


