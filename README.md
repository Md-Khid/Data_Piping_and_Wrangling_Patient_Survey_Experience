# Project Overview

## Introduction
This project aims to demonstrate the transferring of data between Python, SQL and R for proficient data preparation, including merging data sets. It focuses on cleansing and structuring data related to inpatient ward experiences with healthcare providers, showcasing how these tools can be effectively employed to extract valuable insights from the collected survey data. Additionally, it will exhibit the creation of a simple Linear Model to predict patients' overall experience and the design of a performance-impact chart using basic R functions.

## Dataset Information

### Data Variables
The survey dataset for the entire year is stored in twelve separate Microsoft Excel documents, one for each calendar month. The significant part of the survey focuses on the experiences of warded patients with their doctors, including aspects such as respect, competency, empathy and listening skills. [Dataset](https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/tree/main/survey)
      
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

1. A Python dictionary named "db_config" is defined to store the configuration details required for connecting to a database. This dictionary serves the purpose of defining a configuration that can be utilised later in the code to establish a connection to the designated database.     
```
db_config = {
    "user": "root",
    "password": "",
    "host": "localhost",
    "port": 3306,  # Default MySQL port
    "database": "survey"
}
```
2. Next, an "SQLAlchemy" database engine is created using the provided configuration information. The "create_engine" function combines all these elements into a connection string and employs it to establish an SQLAlchemy engine. This engine can be utilised to execute SQL queries and interact with the specified MySQL database using the provided connection details.

After executing these Python codes, the following outputs will be obtained from the Python environment and the MySQL database "survey". 

#### Python (Jupyter Notebook Environment)
![1](https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/31189075-2ea7-4b64-b1fd-d03cce28330b)

#### MySQL Database
<img width="960" alt="1" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/91ccf0f2-cd9d-479c-831c-fe12feaa9ce2">

## Constructing 'Doc Survey' Table with SQL: Data Consolidation and Transformation
The project will begin constructing a "doc survey" table, consolidating all records from each of the twelve tables. Following this, it will proceed to convert all missing or non-valid values such as '99' to NULL. Additionally, it will transform all data types into integers (specifically TINYINT) for all numeric variables found within the "doc_survey" table to enhance storage efficiency (for values ranging from 1 to 99). To create the new table named "doc_survey", the project will use a stored procedure within the MySQL query. This procedure will include loop functions for executing iterative tasks and conditional logic, serving as a container for the entire process. It will involve actions such as combining data from multiple tables, renaming columns, altering data types and updating values. 

Following the execution of the MySQL query, the "doc_survey" table comprising 17,708 rows and the stored procedure function "UnionAllTablesAndModify" will be created in the MySQL survey database.

#### MySQL Database (updated)
<img width="960" alt="2" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/cc0756a6-1e19-40e5-92de-e24b6b44c54b">

#### Modified “doc_survey” columns and data type 
<img width="960" alt="3" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/467e019d-a1f6-46cd-bc47-24228798aa18">


## Uploading "doc_survey" data from MySQL to R

1. To read the "doc_survey" MySQL table and save it as an R data.frame, the following code must be executed in an R environment.

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
2. After saving the "doc_survey" MySQL table as an R data.frame, it is important to inspect the structure of the retrieved data table. This step enables the project to gain an understanding of the characteristics of the data stored in the R environment. It is noted that all the variables stored in the data are integers. Therefore, the project can proceed to create a Simple Linear Regression model based on the doc_survey data in R.

```
# Check the structure of the retrieved data table. This code is used to examine the structure of the data table that has been retrieved.
str(data.frame)
```
<img width="529" alt="4" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/22d7a2c1-7d71-4446-a044-e9aa1d42cec9">

3. In this R code, a linear regression analysis is conducted on a dataset with the aim of examining the relationship between the dependent variable "overall_sat" and all other columns treated as independent variables.

```
# A linear regression model (model) is created using the "lm" function, which regresses the "overall_sat" variable against all other columns in the dataset (data.frame).
# The model's purpose is to elucidate how variations in the independent variables affect "overall_sat".

model1 <- lm(overall_sat ~ ., data = data.frame)

```
4. The results of the linear regression model are summarised using the "summary" function. The summary output reveals an R-squared value of 0.8071. This value indicates that around 80.71% of the variability in "overall_sat" can be attributed to the independent variables. This suggests that the model accounts for about 80.71% of the variability in "overall_sat," leaving roughly 19.29% of the variability unexplained. The unexplained variability may be due to unconsidered factors or random variation. Additionally, it is noted that the "age_bracket" and "sex" variables have high p-values (0.5970 and 0.7646, respectively), suggesting that they are not statistically significant in explaining the variation in "overall_sat". Consequently, it might be advantageous to contemplate the removal of "age_bracket" and "sex" to simplify the model and enhance its interpretability.

```
summary(model1)

```

<img width="527" alt="5" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/0efb94aa-f4ff-443a-9760-67599106388c">

5. Another simplified linear regression model (model2) is fitted without the "age_bracket" and "sex" variables. This streamlined model maintains the same coefficient of determination (R-squared) and the Adjusted R-squared as the initial model. While the values for these statistical measures in the second regression model remain consistent as in the first, this approach effectively simplifies the regression model by utilising fewer variables to predict 'overall_sat', thus exemplifying the principle of parsimony.
```
# Fit another linear regression model with 'overall_sat' as the dependent variable and all other columns as independent variables
model2 <- lm(overall_sat ~ . - age_bracket - sex, data = data.frame)
```
```
# Summarise the simplified linear regression model
summary(model2)
```
<img width="535" alt="6" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/e64f326f-2269-4fa9-a4ca-1fb99b06f3d3">

6. Additionally, it is  good practice to examine multicollinearity in a regression model. Multicollinearity arises when the independent variables within a regression model exhibit strong correlations with one another potentially causing complications in model interpretation and influencing the dependability of the estimated coefficients. The results indicate that there is a moderate level of multicollinearity and may not necessarily cause severe problems to the model. 

```
# In this line of code, the "car" package is loaded, offering a comprehensive array of functions and datasets tailored for statistical analyses, with a particular focus on regression and various other model types.
library(car)

# In this line of code, the Variance Inflation Factor (VIF) is computed for the independent variables within the "model2."
vif_model2 <- vif(model2)

# This line prints the VIF values to the console using the "print" function.
# Based on the results, the independent variables used in "model2" contained Variance Inflation Factor (VIF) values less than 10. 
print(vif_model2)
```

<img width="500" alt="Capture" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_Patient_Survey_Experience/assets/160820522/ee5bf25b-2219-4dfb-b5f0-8f02fab1925d">

7. To gain a deeper understanding of the model, the project will print out the regression formula. This formula can be utilised to evaluate patient overall satisfaction scores based on future survey data.

```
#  This code illustrates the process of fitting and evaluating a linear regression model with the goal of understanding and potentially simplifying the relationship between the dependent variable "overall_sat" and the independent variables.
cat(paste("overall_sat =", round(coef(model2)[1], 4), "+", paste(names(coef(model2))[-1], "*", round(coef(model2)[-1], 4), collapse = " + ")))
```
<img width="527" alt="8" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/17fb670d-b498-4dcd-8c6d-598752560ed1">

8. To create a performance-impact chart using the basic R visualisation functions: plot(), points(), text(), axis() and abline(), a data table should be generated for storing the coefficients of model2 and the means of its variables.
   
```
# Here, a data frame named "data_table" is created to store the intended information and display it in a tabular format.
data_table <- data.frame(

  # In this line, the "Variable" column in the data frame is populated with the names of the variables from the "model2" coefficients.
  # The coef(model2) function returns the coefficients of the linear regression model. names(coef(model2))[-1] is used to exclude the first element, which is typically the intercept.
  Variable = names(coef(model2))[-1],
  
  # The "Mean_Value" column is filled with the mean values of the variables.
  # The sapply function is used to apply a function to each variable name (excluding the intercept) in "model2".
  # For each variable, it calculates the mean value using the mean() function.
  # The data.frame[[var_name]] extracts the specific variable from the "doc_survey" data frame and na.rm = TRUE ensures that any missing values are ignored in the mean calculation.
  Mean_Value = sapply(names(coef(model2))[-1], function(var_name) {
    mean(data.frame[[var_name]], na.rm = TRUE)
  }),
  
  # The "Coefficient" column is populated with the coefficients of the variables from "model2," excluding the intercept.
  # This is achieved using coef(model2)[-1].
  Coefficient = coef(model2)[-1]  
)

# This visually inspect and explore the information in tabular form, this  code prints the "data_table" to the console displaying the contents of the data frame which includes the variable names, mean values and coefficients.
print(data_table)
```
<img width="579" alt="9" src="https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/3ffc9480-cbd6-4060-8072-aea307eb3ebf">


9. After storing the model2 variables' coefficients and means, the following codes will be executed to create the performance impact chart.
```
# In this line of the code, the mean of the "Mean_Value" column in the "data_table" is calculated, and the result is stored in the variable "mean_mean_value.
mean_mean_value <- mean(data_table$Mean_Value)
```
```
# In this line of the code, the mean of the "Coefficient" column in the "data_table" is calculated and saved in the variable "mean_coefficient."
mean_coefficient <- mean(data_table$Coefficient)
```
```
# In this line of the code, a scatter plot is created using data from the "data_table".
# The x-axis represents "Coefficient * 100" and the y-axis represents "Mean_Value".
# The "type = 'n'" argument specifies an empty plot with no data points initially.
# The "xlim" and "ylim" arguments set the limits for the x and y axes while "xlab" and "ylab" label the x and y axes, and "main" provides a title for the plot.

plot(data_table$Coefficient * 100, data_table$Mean_Value, type = "n", xlim = c(-10, 40),
     ylim = c(2, 5), xlab = "Satisfaction Impact (%)", ylab = "Average Performance Rating",
     main = "Patient Satisfaction and Performance Metrics")

# In this line of the code, a data frame named "offsets" is created.  It contains three columns: "Variable," "x_offset," and "y_offset".
# "Variable" lists category names, "x_offset" stores customized x-coordinate offsets and "y_offset" stores customized y-coordinate offsets for each category.

offsets <- data.frame(
  Variable = c("respectful", "seems_competent", "emphasises_well", "listens_well", "explains_and_updates_well", "ward_type"),
  x_offset = c(0.5, 0.5, -0.5, -0.5, 0.5, -0.5), 
  y_offset = c(0.1, 0.1, -0.1, -0.1, 0.1, -0.1) 
)

# In this line of the code, the "offsets" data frame is merged with the "data_table" based on the common column "Variable".
# This operation effectively adds the "x_offset" and "y_offset" values to the "data_table."

data_table <- merge(data_table, offsets, by = "Variable")

# In this block of code, operations are performed within the context of the "data_table" data frame. The "points" function adds data points to the scatter plot.
# The x and y coordinates are determined by "Coefficient * 100" and "Mean_Value" respectively.
# The color and shape of the points are set based on the "Variable" column, with red points used for "ward_type" and black points for other categories.
# The "text" function adds text labels to the data points with customized offsets.

with(data_table, {
  points(Coefficient * 100, Mean_Value, col = ifelse(Variable == "ward_type", "red", "black"), pch = 21, bg = ifelse(Variable == "ward_type", "red", "black"))
  text(Coefficient * 100 + x_offset, Mean_Value + y_offset, labels = Variable)
})

# In this line of the code, horizontal and vertical dashed lines are added to the plot.
# The horizontal line is drawn at the level of "mean_mean_value" on the y-axis representing the mean of the "Mean_Value" column.
# The line is colored red and has a dashed pattern specified by "lty = 2".
# The vertical line is drawn at a position calculated from "mean_coefficient" multiplied by 100 on the x-axis. This line is also coloured red and has a dashed pattern.

abline(h = mean_mean_value, v = mean_coefficient * 100, col = "red", lty = 2)
```

![Patient and Satisfaction Performance Metrics](https://github.com/Md-Khid/Data_Piping_and_Wrangling_for_Patient_Survey_Experience/assets/160820522/56a0f74c-81bd-4556-83d1-31cfcd02273b)

### Insights and Recommendations for Management Consideration

Based on the performance metrics chart created, it is recommended that the management focus on improving the “ward type”. This is because it has the lowest average performance rating and the highest negative impact on patient satisfaction. Improving the conditions or processes related to the ward type could potentially lead to increased patient satisfaction.  

Patient Comfort: The category of the ward assigned to a patient can significantly impact their comfort levels. This includes factors such as the level of privacy provided, ambient noise and the overall ward environment. In cases where patients find their assigned wards uncomfortable, there is a likelihood of lower satisfaction scores.

Quality of Care: The care provided to patients may vary depending on the ward category. For example, in a shared ward, nurses may have limited time available for individual patient care compared to a private ward. This, in turn, could influence the patient's perception of the care received.

Perceived Value: Patients often associate their ward category with the perceived value of their investment. If they find themselves in a ward they consider of lower quality, they may perceive that they are not receiving good value for their expenditure, potentially affecting their satisfaction.

## Conclusion

In summary, this project exemplifies the effective utilisation of Python, SQL and R platforms in managing and analysing healthcare data to derive actionable insights. These platforms serve as powerful tools enabling analysts to adeptly handle extensive datasets and uncover significant patterns crucial for informed decision-making. Together, Python, SQL and R constitute an important toolkit for healthcare analytics, with each platform contributing its unique strengths to the data analysis workflow. Python manages data preprocessing and modelling tasks, SQL oversees data storage and retrieval from databases while R conducts advanced statistical analysis and visualisation. By harnessing the complementary features of these platforms, analysts can efficiently extract insights from data, inform evidence-based decision-making and drive continuous improvement in patient care and operational efficiency.







