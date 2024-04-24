# Project Overview

## Introduction
This project aims to demonstrate the utilisation of Python, SQL, and R for proficient data preparation. It focuses on cleaning and structuring data to analyse inpatient ward experiences with healthcare providers. The project will demonstrate how these tools can be effectively employed to extract valuable insights from the survey data [collected](https://github.com/Md-Khid/Data_Wrangling_Patient_Survey_Experience/tree/main/Survey%20Data). Additionally, it will exhibit the creation of a simple Linear Model to predict patients' overall experience and the design of a performance-impact chart using only R's plot(), points(), text(), axis(), and abline() functions.

## Dataset Information

### Data Variables
The survey dataset for the entire year is stored in twelve separate Microsoft Excel documents, one for each calendar month. The significant part of the survey focuses on the experiences of warded patients with their doctors, including aspects such as respect, competency, empathy and listening skills.
      
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
  
- MySQL version 8.1.0
  
- Tableplus version 1
        
Uploading Excel Documents to MySQL with Python
          
    

