/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Medallion' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'Medallion' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'Medallion' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Medallion')
BEGIN
    ALTER DATABASE Medallion SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Medallion;
END;
GO

-- Create the 'Medallion' database
CREATE DATABASE Medallion;
GO

USE Medallion;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO