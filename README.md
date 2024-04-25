# Project Overview

## Introduction
This project aims to demonstrate the transferring of data between Python, SQL and R for proficient data preparation, including merging data sets. It focuses on cleansing and structuring data related to inpatient ward experiences with healthcare providers, showcasing how these tools can be effectively employed to extract valuable insights from the collected survey data. Additionally, it will exhibit the creation of a simple Linear Model to predict patients' overall experience and the design of a performance-impact chart using R.

## Dataset Information

### Data Variables
The survey dataset for the entire year is stored in twelve separate Microsoft Excel documents, one for each calendar month. The significant part of the survey focuses on the experiences of warded patients with their doctors, including aspects such as respect, competency, empathy and listening skills. [Dataset](https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/tree/main/survey)
      
### Data Dictionary

| Column Name       | Field Name             | Description of Question                                   |
|-------------------------|------------------------|--------------------------------------------------------------------------------------------------------------|
| X1                      | respectful             | "How courteous and respectful the doctors were (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X2                      | seems_competent        | "How well the doctors displayed professional knowledge and skills (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X3                      | emphathises_well       | "How well the doctors showed care and concern (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X4                      | listens_well           | "How well the doctors understood your concerns (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X5                      | explains_and_updates_well | How well the doctors provided clear explanation and updates on care and treatment (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA) |
| Y                       | overall_sat            | "How satisfied you were with the medical treatment you received (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| AGE                     | age_bracket            | "Age bracket (1/2/3=[17,29]; 4=[30,39]; 5=[40,49]; 6=[50,59]; 7=[60,64]; 8=[65,inf]; 99=RF)"                |
| GENDER                  | sex                    | "Gender (1=M; 2=F)"                                                                                          |
| WTYPE                   | ward_type              | "Ward type (1=A1; 2=B1; 3=B2; 4=C)"                                                                         |


### Software Platform

This project will utilise:

- Python Jupyter Notebook version 6.5.4
  
- RStudio platform version 2023.06.1, Build 524
  
- MySQL Server version 8.1.0
  
- TablePlus version 1
        
## Uploading Excel Documents to MySQL with Python
To construct a data flow, the project will use a Python program to extract data from the twelve Excel documents and subsequently transfer it to the MySQL database, following the specified naming convention:

| Excel filename | MySQL table name |
|----------------|------------------|
| Jan.xlsx       | in01             |
| Feb.xlsx       | in02             |
| Mar.xlsx       | in03             |
| Apr.xlsx       | in04             |
| May.xlsx       | in05             |
| Jun.xlsx       | in06             |
| Jul.xlsx       | in07             |
| Aug.xlsx       | in08             |
| Sep.xlsx       | in09             |
| Oct.xlsx       | in10             |

The code begins by importing necessary libraries and the "create_engine" function from the "sqlalchemy" module. Initially, it imports "pandas" and assigns it the alias "pd" for data manipulation. Subsequently, the complete "sqlalchemy" library, primarily used for managing relational databases, is imported. The "os" library follows, which facilitates file and directory operations. Lastly, "re" is imported from Python's standard library, enabling string manipulation through pattern matching. Lastly, "create_engine" is imported from "sqlalchemy" to create a database engine for connecting to relational databases.

```
import pandas as pd, sqlalchemy, os, re
from sqlalchemy import create_engine
```
A Python dictionary named "db_config" is defined to store the configuration details required for connecting to a database. This dictionary serves the purpose of defining a configuration that can be utilised later in the code to establish a connection to the designated database.     
```
db_config = {
    "user": "root",
    "password": "",
    "host": "localhost",
    "port": 3306,  # Default MySQL port
    "database": "survey"
}
```
Next, an "SQLAlchemy" database engine is created using the provided configuration information. The "create_engine" function combines all these elements into a connection string and employs it to establish an SQLAlchemy engine. This engine can be utilised to execute SQL queries and interact with the specified MySQL database using the provided connection details.

```
engine = create_engine(f"mysql+mysqlconnector://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}")
```
It then specifies the location of the folder where the Excel files to be processed by the program are stored.

```
folder_path = 'survey/'
```
It then defines a list named "keywords" that includes specific words or terms of interest named on the Excel sheets. This list enables the identification and matching of these keywords within the code later. It accommodates variations in capitalisation, ensuring that the code matches these keywords regardless of their case.
```
keywords = ["inpatient", "warded", "ip", "inp", "in"]
```
A list named "month_order" is created, which contains abbreviated month names in a specific order. This list is designed to hold abbreviated month names in a specific sequence, likely to match the ordering of months used in data files or databases where the code processes or organises data. 
```
month_order = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
```
The code begins by iterating through files in the directory specified by "folder_path".
```
for filename in os.listdir(folder_path):

# It checks if the current file being iterated has the '.xlsx' file extension using "filename.endswith('.xlsx')" condition.
    if filename.endswith('.xlsx'):

# If the file has a valid Excel extension, it attempts to extract the month name from the filename using a regular expression (re.match).
# This extraction is done to identify the relevant month for the data in the file.
        month_match = re.match(r'([A-Za-z]+)\.xlsx', filename)

# If a month name is successfully extracted from the filename and it matches one of the months in the month_order list, the code proceeds to the next step.
        if month_match:
            month_name = month_match.group(1)
            if month_name in month_order:
          
# The code reads the Excel file into a dictionary of data frames using Pandas (pd.read_excel).
# Each sheet in the Excel file becomes a data frame within the dictionary.
                excel_data = pd.read_excel(os.path.join(folder_path, filename), sheet_name=None)
                
# The code then iterates through each sheet and data frame in the dictionary.
                for sheet_name, data_frame in excel_data.items():
                    
# For each sheet, it checks if any of the keywords in the "keywords" list can be found in the sheet name. The check is case-insensitive.
                    if any(keyword in sheet_name.lower() for keyword in keywords):
                        
# If a keyword is found in the sheet name, it constructs a table name based on the month's position in the month_order list.
# It uses this table name to store the data from the current sheet.
                        table_name = f"in{month_order.index(month_name) + 1:02d}"
                        
# The data from the sheet is written to a MySQL database table using the "to_sql" method, and any existing table with the same name is replaced.
                        data_frame.to_sql(table_name, con=engine, if_exists="replace", index=False)        
# A message is generated to confirm the successful upload of information from the current file to the corresponding table.
                        print(f"Data from '{filename}' has been successfully uploaded to the '{table_name}' table.")

# After processing all Excel files, a final message is generated to indicate that all data frames have been uploaded to the MySQL database as tables in order.
print("All data frames have been uploaded to the MySQL database as tables in order.")
```
After executing these Python codes, the following outputs will be obtained from the Python environment and the MySQL database "survey". 

#### Python
![Screenshot 2024-04-25 at 10-54-25 ANL503-ECA - Jupyter Notebook](https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/31189075-2ea7-4b64-b1fd-d03cce28330b)

#### MySQL
<img width="960" alt="1" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/91ccf0f2-cd9d-479c-831c-fe12feaa9ce2">

## Constructing 'Doc Survey' Table with SQL: Data Consolidation and Transformation
The project will begin constructing a "doc survey" table, consolidating all records from each of the twelve tables. Following this, it will proceed to convert all missing or non-valid values such as '99' to NULL. Additionally, it will transform all data types into integers (specifically TINYINT) for all numeric variables found within the "doc_survey" table to enhance storage efficiency (for values ranging from 1 to 99). To create the new table named "doc_survey," the project will use a stored procedure within the MySQL query. This procedure will include loop functions for executing iterative tasks and conditional logic, serving as a container for the entire process. It will involve actions such as combining data from multiple tables, renaming columns, altering data types and updating values. 
```
DELIMITER $$
CREATE PROCEDURE UnionAllTablesAndModify()
BEGIN

  -- Variable Declaration: Within the procedure, an integer variable named "i" is declared and initialised with the value 1. Additionally, another variable "@sql_text" is declared to store SQL statements in the form of a string.
  DECLARE i INT DEFAULT 1;
  SET @sql_text = '';

-- While Loop: The code proceeds to enter a WHILE loop, which continues as long as the value of "i" remains less than or equal to 12.
  WHILE i <= 12 DO
    SET @table_name = CONCAT('in', LPAD(i, 2, '0'));
    SET @sql_text = CONCAT(@sql_text, ' SELECT * FROM ', @table_name);
    IF i < 12 THEN
      SET @sql_text = CONCAT(@sql_text, ' UNION ALL');
    END IF;
    SET i = i + 1;
  END WHILE;

 -- SQL Query Construction: Within the loop, an SQL query is constructed using the "CONCAT" function.
 -- It dynamically generates a "UNION ALL" statement to combine data from 12 distinct tables with names such as in01, in02, and so on.
-- Query Preparation and Execution: Subsequently, after the loop, an SQL statement is prepared by concatenating the generated SQL text with a "CREATE TABLE" statement.
-- This statement is then stored in the "@sql_text" variable. The SQL statement is subsequently prepared, executed, and deallocated using the "PREPARE," "EXECUTE," and "DEALLOCATE PREPARE" statements. This culminates in the creation of a new table named "doc_survey," encompassing data from all the specified tables.
  SET @sql_text = CONCAT('CREATE TABLE doc_survey AS ', @sql_text, ';');
  PREPARE stmt FROM @sql_text;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

 -- Table Column Modification: The code subsequently configures the "@sql_text" variable with an SQL query that alters the structure of the "doc_survey" table.
 -- This involves changing the data type of several columns to "TINYINT" and adding comments to elucidate the significance of values within these columns. For this purpose, the "ALTER TABLE" statement is utilised.
-- Preparation and Execution of Column Modification Query: Similar to the previous step, the SQL statement for modifying the table columns is prepared and executed.
-- In this query, the columns are renamed and the data type is changed to "TINYINT" for enhanced storage efficiency (for values range from 1 to 99). Comments have been added for future reference, aiding others in comprehending the data.
  SET @sql_text = '
    ALTER TABLE doc_survey 
      CHANGE X1 respectful TINYINT COMMENT "How courteous and respectful the doctors were  (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)",
      CHANGE X2 seems_competent TINYINT COMMENT "How well the doctors displayed professional knowledge and skills (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)",
      CHANGE X3 emphasises_well TINYINT COMMENT "How well the doctors showed care and concern (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)",
      CHANGE X4 listens_well TINYINT COMMENT "How well the doctors understood your concerns (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)",
      CHANGE X5 explains_and_updates_well TINYINT COMMENT "How well the doctors provided clear explanation and updates on care and treatment (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)",
      CHANGE Y overall_sat TINYINT COMMENT "How satisfied you were with the medical treatment you received (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)",
      CHANGE AGE age_bracket TINYINT COMMENT "Age bracket (1/2/3=[17,29]; 4=[30,39]; 5=[40,49]; 6=[50,59]; 7=[60,64]; 8=[65,inf]; 99=RF)",
      CHANGE GENDER sex TINYINT COMMENT "Gender (1=M; 2=F)",
      CHANGE WTYPE ward_type TINYINT COMMENT "Ward type (1=A1; 2=B1; 3=B2; 4=C)";';                    
  PREPARE stmt FROM @sql_text;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

-- Value Updates: The code subsequently assigns "@sql_text" to another SQL query responsible for updating specific columns within the "doc_survey" table.
-- It replaces values of 99 with NULL in these columns.
-- Preparation and Execution of Update Query: The code prepares and executes this query to update the values in the table.
  SET @sql_text = '
    UPDATE doc_survey 
    SET respectful = IF(respectful=99, NULL, respectful),
        seems_competent = IF(seems_competent=99, NULL, seems_competent),
        emphasises_well = IF(emphasises_well=99, NULL, emphasises_well),
        listens_well = IF(listens_well=99, NULL, listens_well),
        explains_and_updates_well = IF(explains_and_updates_well=99, NULL, explains_and_updates_well),
        overall_sat = IF(overall_sat=99, NULL, overall_sat),
        age_bracket = IF(age_bracket=99, NULL, age_bracket),
        sex = IF(sex=99, NULL, sex),
        ward_type = IF(ward_type=99, NULL, ward_type);';
  PREPARE stmt FROM @sql_text;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

-- Call the Procedure
CALL UnionAllTablesAndModify();
```
Following the execution of the MySQL query, the "doc_survey" table comprising 17,708 rows and the stored procedure function "UnionAllTablesAndModify" will be created in the MySQL survey database.

<img width="960" alt="2" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/cc0756a6-1e19-40e5-92de-e24b6b44c54b">
<img width="960" alt="3" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/467e019d-a1f6-46cd-bc47-24228798aa18">


## Uploading "doc_survey" data from MySQL to R

To read the "doc_survey" MySQL table and save it as an R data.frame, the following code must be executed in an R environment.

```
# Set the working directory 
setwd("")

# Load the RMySQL package. This code checks if the RMySQL package is available and, if not installs and loads it.
if (!require(RMySQL)) {
  install.packages("RMySQL", dependencies = TRUE)
  library(RMySQL)
}

# Establish a database connection. This code initiates the process of establishing a connection to MySQl database.
con <- dbConnect(MySQL(), dbname = "survey", user = "root", password = "")

# Execute a query to fetch data from the table. This code signifies the execution of a database query to retrieve data from a specific table.
suppressWarnings(data.frame <- dbGetQuery(con, "SELECT * FROM doc_survey"))

# Close the database connection. This code signals the intention to close the connection to the database.
dbDisconnect(con)
```

