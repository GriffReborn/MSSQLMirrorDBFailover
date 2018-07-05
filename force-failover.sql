-- MSSQL Mirror DB Failover Script
-- from https://github.com/GriffReborn/MSSQLMirrorDBFailover
-- Copyright (C) 2015 - Richard Griffiths
-- Free to use, share and modify as long as my copyright notice is maintained.
--- 
USE master;
DECLARE @dbname sysname;

WHILE exists
  (SELECT TOP (1) name
   FROM sys.database_mirroring m
   JOIN sys.databases db ON db.database_id = m.database_id
   WHERE mirroring_role_desc =N'PRINCIPAL'
   AND mirroring_state_desc =N'SYNCHRONIZED')
      
BEGIN
       SET @dbname =
              (SELECT TOP (1) name
              FROM sys.database_mirroring m
              JOIN sys.databases db ON db.database_id = m.database_id
              WHERE mirroring_role_desc =N'PRINCIPAL'
              AND mirroring_state_desc =N'SYNCHRONIZED');
       EXEC('ALTER DATABASE "' + @dbname + '" SET PARTNER FAILOVER')
END
