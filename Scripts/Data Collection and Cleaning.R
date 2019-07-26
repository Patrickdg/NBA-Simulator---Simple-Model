
for(n in 1:length(list.files("./Team Data"))){
      list <- list.files("./Team Data")
      
      for(i in 1:length(list)){
            
            folder <- list[i]
            file_list <- list.files(paste0("./Team Data/",folder))
            number_of_files <- length(file_list)
            
            if(!file.exists(paste0("./",folder,".csv"))){
                  file.create(paste0("./",folder,".csv"))
            }
            
            for(m in 1:number_of_files){
                  file_to_read <- paste0("./Team Data/",folder,"/",file_list[m])
            
                  file_to_read <- file_to_read
                  library(rvest)
                  parsed_file <- read_html(file_to_read)
                  
                  tab <- html_node(parsed_file, "table") %>% html_table() %>% tibble::as_tibble(.name_repair = "unique")
                  names(tab) <-tab[1,]
                  tab <- tab[-1,]
                  tab[-c(2,3,4)] <- sapply(tab[-c(2,3,4)], as.numeric)
                  tab <- as.data.table(tab)
                  }
          
                  write.table(tab, file = paste0("./",folder,".csv"), append = TRUE, col.names = FALSE)
           }
      }

