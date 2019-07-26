
## Load necessary packages
library(rvest)
library(plyr)
library(data.table)

## Set path of folders for data reading & consolidation loops
folders <- list.files("./Team Data")
advancedpath <- paste0("./Team Data/",folders[1])
gamepath <- paste0("./Team Data/",folders[2])
oppgamepath <- paste0("./Team Data/",folders[3])

### If .csv files already exist in directory, DELETE and REFRESH w/ empty files. 
### Otherwise, create empty .csv files for use in data reading & consolidation. 
for(n in 1:length(folders)){
      if(file.exists(paste0("./",folders[n],".csv"))){
            file.remove(paste0("./",folders[n],".csv"))
            file.create(paste0("./",folders[n],".csv"))
      } else {
            file.create(paste0("./",folders[n],".csv"))
      }
      
}

## For each file in advancedpath, read & write to existing csv.
for(i in 1:length(list.files(advancedpath))){
      file <- list.files(advancedpath)[i]
      
      parsed_file <- read_html(paste0(advancedpath,"/",file))
      
      tab <- html_node(parsed_file, "table")  %>% html_table() %>% tibble::as_tibble(.name_repair = "unique")
      names(tab) <- tab[1,]
      tab <- tab[-1,]
      tab[-c(2,3,4)] <- sapply(tab[-c(2,3,4)], as.numeric)
      tab <- as.data.table(tab)
      
      ## Write each file's data into existing .csv.
      ## If existing .csv is empty, then INCLUDE HEADERS when appending data with col.names = TRUE. Otherwise, don't append header. 
      write.table(tab, 
                  file = paste0("./",folders[1],".csv"), 
                  append = TRUE, 
                  col.names = if(file.info(paste0("./",folders[1],".csv"))$size == 0) {TRUE} else {FALSE}
      )
}

## For each file in gamepath, read & write to existing csv.
for(i in 1:length(list.files(gamepath))){
      file <- list.files(gamepath)[i]
      
      parsed_file <- read_html(paste0(gamepath,"/",file))
      
      tab <- html_node(parsed_file, "table")  %>% html_table() %>% tibble::as_tibble(.name_repair = "unique")
      names(tab) <- tab[1,]
      tab <- tab[-1,]
      tab[-c(2,3,4)] <- sapply(tab[-c(2,3,4)], as.numeric)
      tab <- as.data.table(tab)
      
      ## Write each file's data into existing .csv.
      ## If existing .csv is empty, then INCLUDE HEADERS when appending data with col.names = TRUE. Otherwise, don't append header. 
      write.table(tab, 
                  file = paste0("./",folders[2],".csv"), 
                  append = TRUE, 
                  col.names = if(file.info(paste0("./",folders[2],".csv"))$size == 0) {TRUE} else {FALSE}
      )
}

## For each file in oppgamepath, read & write to existing csv.
for(i in 1:length(list.files(oppgamepath))){
      file <- list.files(oppgamepath)[i]
      
      parsed_file <- read_html(paste0(oppgamepath,"/",file))
      
      tab <- html_node(parsed_file, "table")  %>% html_table() %>% tibble::as_tibble(.name_repair = "unique")
      names(tab) <- tab[1,]
      tab <- tab[-1,]
      tab[-c(2,3,4)] <- sapply(tab[-c(2,3,4)], as.numeric)
      tab <- as.data.table(tab)
      
      ## Write each file's data into existing .csv.
      ## If existing .csv is empty, then INCLUDE HEADERS when appending data with col.names = TRUE. Otherwise, don't append header. 
      write.table(tab, 
                  file = paste0("./",folders[3],".csv"), 
                  append = TRUE, 
                  col.names = if(file.info(paste0("./",folders[3],".csv"))$size == 0) {TRUE} else {FALSE}
      )
}

## List of NBA Champions by year to be inserted in final data set (for use in exploratory analysis).
seasons <- mapply(paste0, 2000:2018,"-", 2001:2019); seasons <- sub("-20","-",seasons)
champs <- data.frame(season = seasons, champs = c("LAL","LAL","SAS","DET","SAS","MIA","SAS","BOS","LAL","LAL","DAL","MIA","MIA","SAS","GSW","CLE","GSW","GSW","TOR"));
      champs$key <- paste0(champs$champs,".",champs$season)

## Read .csv files ; replace "\\*" with "" in team names $Tm
adv <- fread("./Team by Season by Advanced.csv");
      adv <- adv[,playoffs:= grepl("\\*",adv$Tm)] 
      adv$Tm <- gsub("\\*","",adv$Tm)
      
game <- fread("./Team by Season by Game Stats.csv"); 
      game <- game[,playoffs:= grepl("\\*",game$Tm)]
      game <- game[,-c("MP")];
      game$Tm <- gsub("\\*","",game$Tm); 

opp <- fread("./Team by Season by Opp Game Stats.csv"); 
      opp <- opp[,playoffs:= grepl("\\*",opp$Tm)]
      opp$Tm <- gsub("\\*","",opp$Tm);
      names(opp) <- paste0("OPP.",names(opp)) 

## Set keys for joining datasets & join
adv$key <- paste0(adv$Tm,".",adv$Season); adv <- data.table(adv$key,adv[,-c("key")]); names(adv)[1] <- "key"
      adv <- adv[,champs:= is.element(adv$key,champs$key)]
game$key <- paste0(game$Tm,".",game$Season); game <- data.table(game$key, game[,-c("key")]); names(game)[1] <- "key"
opp$key <- paste0(opp$OPP.Tm,".",opp$OPP.Season); opp <- data.table(opp$key, opp[,-c("key")]); names(opp)[1] <- "key"

data <- join_all(list(adv,game,opp),"key")

## Removing duplicate keys within the data, as well as unnecessary columns and rows with NA values from joining
uniqueindex <- match(unique(data$key), data$key)
data <- data[uniqueindex,]
data <- data[,-c("V1","Rk","Lg","OPP.V1","OPP.Rk","OPP.Season","OPP.Tm","OPP.Lg")]
data <- data[,-c(24,25,26,27,28,29,47,48,49,50,51,69)]
data$Season <- substr(data$key,5,11)
data <- na.omit(data)

## Write final data to .csv
write.table(data, file = "NBA Data by Team and Season.csv", row.names = FALSE, sep = ",")

