##  NBA SIMULATOR (SIMPLE MODEL) - DATA LOADING, CLEANING, AND COMPILING
## Author: Patrick de Guzman

## The following script loads, cleans, and compiles the NBA stat data found within the 
## 'Team Data' folder. 
## Final output will be a single .csv file titled 'NBA Data by Team and Season.csv'.

# Load required packages
library(rvest)
library(plyr)
library(data.table)

# Set path of folders for data reading & consolidation loops
folders <- list.files("./Team Data")
advancedpath <- paste0("./Team Data/",folders[1])
gamepath <- paste0("./Team Data/",folders[2])
oppgamepath <- paste0("./Team Data/",folders[3])


# FROM THE 3 TYPES OF DATA FOUND WITHIN THE 'TEAM DATA' FOLDER, 3 SEPARATE CSV FILES 
# WILL BE CREATED AND EVENTUALLY MERGED INTO 1 CSV.
## If .csv files already exist in directory, DELETE and REFRESH w/ empty files. 
## Otherwise, create empty .csv files for use in data reading & consolidation. 
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
      ## If existing .csv is empty, then INCLUDE HEADERS when appending data with 
      ##col.names = TRUE. Otherwise, don't append header. 
      write.table(tab, 
                  file = paste0("./",folders[1],".csv"), 
                  append = TRUE, 
                  col.names = if(file.info(paste0("./",folders[1],".csv"))$size == 0) 
                        {TRUE} else {FALSE}
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
      ## If existing .csv is empty, then INCLUDE HEADERS when appending data with 
      ## col.names = TRUE. Otherwise, don't append header. 
      write.table(tab, 
                  file = paste0("./",folders[2],".csv"), 
                  append = TRUE, 
                  col.names = if(file.info(paste0("./",folders[2],".csv"))$size == 0) 
                        {TRUE} else {FALSE}
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
      ## If existing .csv is empty, then INCLUDE HEADERS when appending data with 
      # col.names = TRUE. Otherwise, don't append header. 
      write.table(tab, 
                  file = paste0("./",folders[3],".csv"), 
                  append = TRUE, 
                  col.names = if(file.info(paste0("./",folders[3],".csv"))$size == 0) 
                        {TRUE} else {FALSE}
      )
}

# Create list of NBA Champions by year to be inserted in final data set 
# (for use in exploratory analysis).
seasons <- mapply(paste0, 1979:2018,"-", 1980:2019)
champs <- data.frame(season = seasons, champs = c("LAL","BOS","LAL","PHI","BOS","LAL",
                                                  "BOS","LAL","LAL","DET","DET","CHI",
                                                  "CHI","CHI","HOU","HOU","CHI","CHI",
                                                  "CHI","SAS","LAL","LAL","LAL","SAS",
                                                  "DET","SAS", "MIA","SAS","BOS","LAL",
                                                  "LAL","DAL","MIA","MIA","SAS","GSW",
                                                  "CLE","GSW","GSW","TOR"));
## Create 'key' column which will be used to merge 'champs' data frame to final set.       
champs$key <- paste0(champs$champs,".",substr(champs$season,1,5),substr(champs$season,8,9))

# Read .csv files ; 
# Create $playoffs logical column to denote teams that made playoffs within seasons ; 
# Remove asterisk "\\*" in team names.
adv <- fread("./Team by Season by Advanced.csv");
      adv <- adv[,playoffs:= grepl("\\*",adv$Tm)]
      adv$Tm <- gsub("\\*","",adv$Tm)
      
game <- fread("./Team by Season by Game Stats.csv"); 
      game <- game[,playoffs:= grepl("\\*",game$Tm)]
      game$Tm <- gsub("\\*","",game$Tm)

opp <- fread("./Team by Season by Opp Game Stats.csv"); 
      opp <- opp[,playoffs:= grepl("\\*",opp$Tm)]
      opp$Tm <- gsub("\\*","",opp$Tm)

# Set keys for joining datasets & join into final set 'data' 
## ADVANCED STATS
      ### Key is set as new column "TeamName.Season" 
      adv$key <- paste0(adv$Tm,".",adv$Season) 
      ### Change names to start with "ADV." 
      names(adv) <- paste0("ADV.",names(adv))
      ### set $key as first column in dataset and set name of first column to 'key'
      adv <- data.table(adv$ADV.key,adv[,-c("ADV.key")]); names(adv)[1] <- "key" 
      ### Create T/F $champs column by checking if $Tm is an element in 'champs' dataframe.
      adv <- adv[,champs:= is.element(adv$key,champs$key)]
      ### Rename duplicates of columns to denote opponent team advanced stats.
      ### make.unique adds ".1" to end of duplicates, then gsub() used to substitute
      ### to ".OPP"
      names(adv) <- make.unique(names(adv))
      names(adv) <- gsub("\\.1$",".OPP",names(adv))
      
      
## TEAM GAME STATS
      ### Key is set as new column "TeamName.Season" 
      game$key <- paste0(game$Tm,".",game$Season)
      ### Change names to start with "TM." to denote team vs. opponent team stats. 
      names(game) <- paste0("TM.",names(game)) 
      ### set $key as first column in dataset and set name of first column to 'key'
      game <- data.table(game$TM.key, game[,-c("TM.key")]); names(game)[1] <- "key"

## OPPONENT GAME STATS
      ### Key is set as new column "TeamName.Season" 
      opp$key <- paste0(opp$Tm,".",opp$Season)
      ### Change names to start with "OPP." to denote team vs. opponent team stats. 
      names(opp) <- paste0("OPP.",names(opp)) 
      ### set $key as first column in dataset and set name of first column to 'key'
      opp <- data.table(opp$OPP.key, opp[,-c("OPP.key")]); names(opp)[1] <- "key"

data <- join_all(list(adv,game,opp),"key")

# Removing duplicate keys within the data, as well as unnecessary columns and 
# rows with NA values from joining.
uniqueindex <- match(unique(data$key), data$key)
data <- data[uniqueindex,]

## These columns being removed are redundant and/or unnecessary for our analysis.
data <- data[,-c("ADV.V1","ADV.Rk","ADV.Lg","TM.V1","TM.Rk","TM.Season",
                 "TM.Tm","TM.Lg","TM.G","TM.W","TM.L","TM.W/L%","TM.MP",
                 "TM.playoffs","OPP.V1","OPP.Rk","OPP.Season","OPP.Tm",
                 "OPP.Lg","OPP.G","OPP.W","OPP.L","OPP.W/L%","OPP.playoffs")]
names(data) <- make.names(names(data))
data <- na.omit(data)

# Write final data to .csv
write.table(data, file = "NBA Data by Team and Season.csv", row.names = FALSE, sep = ",")

