/*
===============================================================================
Create Database and Schemas
===============================================================================
Script Purpose:
  This script creates a new database named 'DataWarehouse' after checking if it already exists.
  If the databse exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold.

WARNING:
      Running this script will drop the entire 'DataWarehouse' database if exits.
      All data in the databse will permanently deleted. Proceed with caution and 
      ensure you have proper backups before running this script.  
*/

USE master; 
GO

-- Drop and recreate the 'DataWarehouse' databse
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DatabaseWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

