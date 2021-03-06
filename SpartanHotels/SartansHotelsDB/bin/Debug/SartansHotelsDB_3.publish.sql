﻿/*
Deployment script for SartansHotelsDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SartansHotelsDB"
:setvar DefaultFilePrefix "SartansHotelsDB"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Dropping FK_RoomTypeAvailability_RoomTypeDetails...';


GO
ALTER TABLE [dbo].[RoomTypeAvailability] DROP CONSTRAINT [FK_RoomTypeAvailability_RoomTypeDetails];


GO
PRINT N'Dropping FK_RoomTypeAvailability_RoomType...';


GO
ALTER TABLE [dbo].[RoomTypeAvailability] DROP CONSTRAINT [FK_RoomTypeAvailability_RoomType];


GO
PRINT N'Starting rebuilding table [dbo].[RoomTypeAvailability]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RoomTypeAvailability] (
    [ID]                      INT      IDENTITY (1, 1) NOT NULL,
    [RoomTypeID]              INT      NOT NULL,
    [RoomTypeAccessabilityID] INT      NOT NULL,
    [ForDate]                 DATETIME NOT NULL,
    [NoOfRoomBlocked]         INT      NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[RoomTypeAvailability])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RoomTypeAvailability] ON;
        INSERT INTO [dbo].[tmp_ms_xx_RoomTypeAvailability] ([ID], [RoomTypeID], [RoomTypeAccessabilityID], [ForDate], [NoOfRoomBlocked])
        SELECT   [ID],
                 [RoomTypeID],
                 [RoomTypeAccessabilityID],
                 [ForDate],
                 [NoOfRoomBlocked]
        FROM     [dbo].[RoomTypeAvailability]
        ORDER BY [ID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RoomTypeAvailability] OFF;
    END

DROP TABLE [dbo].[RoomTypeAvailability];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RoomTypeAvailability]', N'RoomTypeAvailability';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating FK_RoomTypeAvailability_RoomTypeDetails...';


GO
ALTER TABLE [dbo].[RoomTypeAvailability] WITH NOCHECK
    ADD CONSTRAINT [FK_RoomTypeAvailability_RoomTypeDetails] FOREIGN KEY ([RoomTypeAccessabilityID]) REFERENCES [dbo].[RoomTypeAccessability] ([RoomTypeAccessabilityID]);


GO
PRINT N'Creating FK_RoomTypeAvailability_RoomType...';


GO
ALTER TABLE [dbo].[RoomTypeAvailability] WITH NOCHECK
    ADD CONSTRAINT [FK_RoomTypeAvailability_RoomType] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID]);


GO
PRINT N'Creating [dbo].[sp_book_room]...';


GO
CREATE PROCEDURE [dbo].[sp_book_room]
	@BranchID INT,
	@RoomTypeID INT,
	@FromDate DateTime,
	@ToDate DateTime,
	@CustomerId INT
AS
	DECLARE @TempTable TABLE (RoomTypeID INT, TypeName Varchar(50), Facilities VARCHAR(300), ReturnType INT)
	INSERT INTO @TempTable
	exec [sp_get_Availability] @BranchId, @FromDate, @ToDate, 0, @RoomTypeID

	IF EXISTS (SELECT 1 from @TempTable)
		PRINT 'AVAILABLE'


	ELSE 
		PRINT 'NOT AVAILABLE'
GO
PRINT N'Creating [dbo].[sp_cancel_room]...';


GO
CREATE PROCEDURE [dbo].[sp_cancel_room]
	@param1 int = 0,
	@param2 int
AS
	SELECT @param1, @param2
RETURN 0
GO
PRINT N'Refreshing [dbo].[sp_get_Availability]...';


GO
EXECUTE sp_refreshsqlmodule N'dbo.sp_get_Availability';


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[RoomTypeAvailability] WITH CHECK CHECK CONSTRAINT [FK_RoomTypeAvailability_RoomTypeDetails];

ALTER TABLE [dbo].[RoomTypeAvailability] WITH CHECK CHECK CONSTRAINT [FK_RoomTypeAvailability_RoomType];


GO
PRINT N'Update complete.'
GO
