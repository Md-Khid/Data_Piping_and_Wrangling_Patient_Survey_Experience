# Project Overview

## Introduction
This project aims to demonstrate the transferring of data between Python, SQL and R for proficient data preparation, including merging data sets. It focuses on cleansing and structuring data related to inpatient ward experiences with healthcare providers, showcasing how these tools can be effectively employed to extract valuable insights from the collected survey data. Additionally, it will exhibit the creation of a simple Linear Model to predict patients' overall experience and the design of a performance-impact chart using R.

## Dataset Information

### Data Variables
The survey dataset for the entire year is stored in twelve separate Microsoft Excel documents, one for each calendar month. The significant part of the survey focuses on the experiences of warded patients with their doctors, including aspects such as respect, competency, empathy and listening skills.[Dataset](https://github.com/Md-Khid/Data_Wrangling_Patient_Survey_Experience/tree/main/Survey%20Data).
      
### Data Dictionary

| Column Name       | Field Name             | Description of Question                                   |
|-------------------------|------------------------|--------------------------------------------------------------------------------------------------------------|
| X1                      | respectful             | "How courteous and respectful the doctors were (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X2                      | seems_competent        | "How well the doctors displayed professional knowledge and skills (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X3                      | emphathises_well       | "How well the doctors showed care and concern (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X4                      | listens_well           | "How well the doctors understood your concerns (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| X5                      | explains_and_updates_well | How well the doctors provided clear explanation and updates on care and treatment (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA) |
| Y                       | overall_sat            | "How satisfied you were with the medical treatment you received (1=Very Poor; 2=Poor; 3=Satisfactory; 4=Good; 5=Excellent; 99=NA)" |
| AGE                     | age_bracket            | "Age bracket (1/2/3=[17,29]; 4=[30,39]; 5=[40,49]; 6=[50,59]; 7=[60,64]; 8=[65,inf]; 99=NA)"                |
| GENDER                  | sex                    | "Gender (1=M; 2=F)"                                                                                          |
| WTYPE                   | ward_type              | "Ward type (1=A1; 2=B1; 3=B2; 4=C)"                                                                         |


### Software Platform

This project will utilise:

- Python Jupyter Notebook version 6.5.4
  
- RStudio platform version 2023.06.1, Build 524
  
- MySQL Server version 8.1.0
  
- Tableplus version 1
        
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
    "database": "anl503-eca"
}
```
Next, an "SQLAlchemy" database engine is created using the provided configuration information. The "create_engine" function combines all these elements into a connection string and employs it to establish an SQLAlchemy engine. This engine can be utilised to execute SQL queries and interact with the specified MySQL database using the provided connection details.

```
engine = create_engine(f"mysql+mysqlconnector://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}")
```
It then specifies the location of the folder where the Excel files to be processed by the program are stored.

```
folder_path = 'raw/'
```
It then defines a list named "keywords" that includes specific words or terms of interest named on the Excel sheets. This list enables the identification and matching of these keywords within the code later. It accommodates variations in capitalisation, ensuring that the code matches these keywords regardless of their case.
```
keywords = ["inpatient", "warded", "ip", "inp", "in"]
```
A list named "month_order" is created, which contains abbreviated month names in a specific order. This list is designed to hold abbreviated month names in a specific sequence, likely to match the ordering of months used in data files or databases where the code processes or organises data. 
```
month_order = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
```



