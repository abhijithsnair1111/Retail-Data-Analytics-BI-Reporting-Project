/*
---------------------------------------------------------------------
Database Exploration
---------------------------------------------------------------------

Script Purpose:
	Explore the structure of the Database. Understand the Tables and thier Schemas,
	explore all the Columns and its metadata

Method:
	 Acess the Database Metadata through the tables
	 - INFROMATION_SCHEMA.TABLES
	 - INFORMATION_SCHEMA.COLUMNS

---------------------------------------------------------------------
*/


-- Retrieve the lists of all the tables in the Database
SELECT 
	TABLE_CATALOG,
	TABLE_SCHEMA,
	TABLE_NAME,
	TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
;


-- Retrieve the list of all the coloum details for a specific table (eg: dim_customers)
SELECT
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customer'
;
