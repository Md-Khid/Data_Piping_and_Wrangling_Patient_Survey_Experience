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