# NBA Simulator (Simple Model) - Exploratory Analysis & Multivariable Regression Project
### Author: Patrick de Guzman
### Primary Data Source: [Basketball Reference](https://www.basketball-reference.com/)

## Project Components  
This NBA Simulator Project will contain several components:  
- Getting, Wrangling, Compiling, and Cleaning the data ([Github](https://github.com/Patrickdg/NBA-Simulator---Simple-Model/blob/master/Scripts/Data%20Collection%20and%20Cleaning%20V2.R))  
- Exploratory Data Analysis ([Rpubs](http://rpubs.com/patrickdg/NBAPredictorEDA))  
- Multivariable Regression Model to Predict W/L% and 2019-2020 season results ([Rpubs](http://rpubs.com/patrickdg/NBAPredictorRegressionModel))  
- Advanced Model, Interactive Trade System to Incorporate Individual Player Stats (In Progress!)  

The final goal of this project is to develop an advanced regression/ML model with interactivity through a Shiny app to allow for the dynamic movement of NBA players from team to team. By doing this, we can improve our prediction results by incorporating the effect that individual players have on the teams that they play for (since our multivariable model will be shown to base itself on the assumption that teams remain static, i.e., no trades/waivers/injuries/etc. occur throughout the forecast horizon).  

## Synopsis
Data on the National Basketball Association (NBA) seasons from the Basketball Reference website was compiled, cleaned, and merged to create a final dataset of the following variables ([definitions for all variables can be found in the basketball reference glossary](https://www.basketball-reference.com/about/glossary.html)):  
- Team per game statistics (such as points per game, assists per game, etc.)  
- Opponent Team per game statistics (same as above but for opponent teams)  
- Advanced statistics (higher-level stats such as margin-of-victory, strength of schedule, etc.)  

From this compiled data, exploratory data analysis was performed in an attempt to discover the likely traits of 'winning' teams. For the purposes of this project, 'winning' teams are those that qualify for the NBA playoffs and/or win the NBA championships within a given year. 
Trends within the league were also explored, and features within the dataset were identified to correlate with a team's success rate (i.e., their Win/Loss percentages in the regular season). 

The following are included in the repository:  
- Scripts (Folder): Contains Data cleaning & compiling script "Data Collection & Cleaning V2.R" and Exploratory Analysis 'Rmd' file ([click here for the published version](http://rpubs.com/patrickdg/NBAPredictorEDA))  
- Team Data (Folder): Contains 3 types of datasets (team statistics, opponent team statistics, and advanced statistics) for the NBA seasons ranging from 1980-2019 (seasons split into separate files and extracted manually from Basketball Reference).  
- NBA Data by Team and Season.csv : Compiled & cleaned dataset containing all 3 types of data (noted above) for all seasons and all teams in the NBA from 1980-2019.  
- README.md: README file  
- Team by Season by Advanced/Game Stats/Opp Game Stats.csv : Files produced from "Data Collection & Cleaning V2.R" script prior to final consolidation to 'NBA Data by Team and Season.csv' dataset.  

