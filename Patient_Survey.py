#!/usr/bin/env python
# coding: utf-8

# In[1]:


# Import necessary libraries
import pandas as pd  # Library for data manipulation and analysis
import sqlalchemy  # Library for interacting with SQL databases
import os  # Library for interacting with the operating system
import re  # Library for regular expressions
from sqlalchemy import create_engine  # Function to create a connection to a SQL database


# In[2]:


db_config = {
    "user": "root",
    "password": " ",
    "host": "localhost",
    "port": 3306,  # Default MySQL port
    "database": "survey"
}


# In[3]:


engine = create_engine(f"mysql+mysqlconnector://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}")


# In[4]:


folder_path = 'survey/'


# In[5]:


keywords = ["inpatient", "warded", "ip", "inp", "in"]


# In[6]:


month_order = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]


# In[7]:


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


# In[ ]:




