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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [dbo].[Customer]...';


GO
CREATE TABLE [dbo].[Customer] (
    [CustomerId]    INT             NOT NULL,
    [CustomerName]  NVARCHAR (100)  NULL,
    [Address]       NVARCHAR (1000) NULL,
    [ContactNumber] NVARCHAR (50)   NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);


GO
PRINT N'Creating [dbo].[HotelBranches]...';


GO
CREATE TABLE [dbo].[HotelBranches] (
    [BranchId] INT             NOT NULL,
    [Name]     NVARCHAR (250)  NOT NULL,
    [Details]  NVARCHAR (3000) NULL,
    [City]     NVARCHAR (100)  NULL,
    [Address]  NVARCHAR (1000) NULL,
    CONSTRAINT [PK_HotelBranches] PRIMARY KEY CLUSTERED ([BranchId] ASC)
);


GO
PRINT N'Creating [dbo].[HotelPartners]...';


GO
CREATE TABLE [dbo].[HotelPartners] (
    [PartnerID]  INT             NOT NULL,
    [BranchId]   INT             NOT NULL,
    [URL]        NVARCHAR (300)  NULL,
    [Details]    NVARCHAR (3000) NULL,
    [CouponCode] NVARCHAR (50)   NULL,
    CONSTRAINT [PK_HotelPartners] PRIMARY KEY CLUSTERED ([PartnerID] ASC)
);


GO
PRINT N'Creating [dbo].[Reservation]...';


GO
CREATE TABLE [dbo].[Reservation] (
    [ReservationID]       INT              NOT NULL,
    [ReservationNumber]   UNIQUEIDENTIFIER NOT NULL,
    [FromDate]            DATETIME         NOT NULL,
    [ToDate]              DATETIME         NOT NULL,
    [CustomerId]          INT              NOT NULL,
    [RoomTypeDetailsID]   INT              NOT NULL,
    [PaymentMode]         NVARCHAR (50)    NULL,
    [PaymentSuccess]      BIT              NULL,
    [CancellationStatus]  BIT              NULL,
    [CancelledAt]         DATETIME         NULL,
    [CancellationRemarks] NVARCHAR (2000)  NULL,
    CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED ([ReservationID] ASC)
);


GO
PRINT N'Creating [dbo].[RoomOccupancy]...';


GO
CREATE TABLE [dbo].[RoomOccupancy] (
    [ID]               INT        NOT NULL,
    [RoomNumber]       INT        NOT NULL,
    [ForDate]          DATETIME   NOT NULL,
    [RoomTypeDetailID] INT        NOT NULL,
    [OccupiedAt]       DATETIME   NULL,
    [Remarks]          NCHAR (10) NULL,
    [ReservationID]    INT        NOT NULL,
    CONSTRAINT [PK_Rooms] PRIMARY KEY CLUSTERED ([RoomNumber] ASC, [ForDate] ASC)
);


GO
PRINT N'Creating [dbo].[RoomTypeAccessability]...';


GO
CREATE TABLE [dbo].[RoomTypeAccessability] (
    [RoomTypeAccessabilityID] INT      NOT NULL,
    [RoomTypeID]              INT      NOT NULL,
    [NoOfRooms]               INT      NOT NULL,
    [FromDate]                DATETIME NOT NULL,
    [ToDate]                  DATETIME NOT NULL,
    CONSTRAINT [PK_RoomTypeDetails] PRIMARY KEY CLUSTERED ([RoomTypeAccessabilityID] ASC)
);


GO
PRINT N'Creating [dbo].[RoomTypeAvailability]...';


GO
CREATE TABLE [dbo].[RoomTypeAvailability] (
    [ID]                      INT      NOT NULL,
    [RoomTypeAccessabilityID] INT      NOT NULL,
    [ForDate]                 DATETIME NOT NULL,
    [NoOfRoomBlocked]         INT      NOT NULL
);


GO
PRINT N'Creating [dbo].[RoomTypePrice]...';


GO
CREATE TABLE [dbo].[RoomTypePrice] (
    [RoomTypePriceId] INT      NOT NULL,
    [Price]           MONEY    NOT NULL,
    [FromDate]        DATETIME NOT NULL,
    [ToDate]          DATETIME NOT NULL,
    [RoomTypeId]      INT      NOT NULL,
    CONSTRAINT [PK_RoomTypePrice] PRIMARY KEY CLUSTERED ([RoomTypePriceId] ASC)
);


GO
PRINT N'Creating [dbo].[RoomTypes]...';


GO
CREATE TABLE [dbo].[RoomTypes] (
    [RoomTypeID]  INT             NOT NULL,
    [TypeName]    NVARCHAR (100)  NOT NULL,
    [BranchId]    INT             NULL,
    [Details]     NVARCHAR (2000) NULL,
    [Facilities]  NVARCHAR (2000) NULL,
    [MaxAdults]   INT             NULL,
    [MaxChildren] INT             NULL,
    CONSTRAINT [PK_RoomTypes] PRIMARY KEY CLUSTERED ([RoomTypeID] ASC)
);


GO
PRINT N'Creating FK_HotelPartners_HotelBranches...';


GO
ALTER TABLE [dbo].[HotelPartners]
    ADD CONSTRAINT [FK_HotelPartners_HotelBranches] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[HotelBranches] ([BranchId]);


GO
PRINT N'Creating FK_Reservation_Customer...';


GO
ALTER TABLE [dbo].[Reservation]
    ADD CONSTRAINT [FK_Reservation_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);


GO
PRINT N'Creating FK_Reservation_RoomTypeAccessability...';


GO
ALTER TABLE [dbo].[Reservation]
    ADD CONSTRAINT [FK_Reservation_RoomTypeAccessability] FOREIGN KEY ([RoomTypeDetailsID]) REFERENCES [dbo].[RoomTypeAccessability] ([RoomTypeAccessabilityID]);


GO
PRINT N'Creating FK_RoomOccupancy_Reservation...';


GO
ALTER TABLE [dbo].[RoomOccupancy]
    ADD CONSTRAINT [FK_RoomOccupancy_Reservation] FOREIGN KEY ([ReservationID]) REFERENCES [dbo].[Reservation] ([ReservationID]);


GO
PRINT N'Creating FK_Rooms_RoomTypeDetails...';


GO
ALTER TABLE [dbo].[RoomOccupancy]
    ADD CONSTRAINT [FK_Rooms_RoomTypeDetails] FOREIGN KEY ([RoomTypeDetailID]) REFERENCES [dbo].[RoomTypeAccessability] ([RoomTypeAccessabilityID]);


GO
PRINT N'Creating FK_RoomTypeDetails_RoomTypes...';


GO
ALTER TABLE [dbo].[RoomTypeAccessability]
    ADD CONSTRAINT [FK_RoomTypeDetails_RoomTypes] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID]);


GO
PRINT N'Creating FK_RoomTypeAvailability_RoomTypeDetails...';


GO
ALTER TABLE [dbo].[RoomTypeAvailability]
    ADD CONSTRAINT [FK_RoomTypeAvailability_RoomTypeDetails] FOREIGN KEY ([RoomTypeAccessabilityID]) REFERENCES [dbo].[RoomTypeAccessability] ([RoomTypeAccessabilityID]);


GO
PRINT N'Creating FK_RoomTypePrice_RoomTypes...';


GO
ALTER TABLE [dbo].[RoomTypePrice]
    ADD CONSTRAINT [FK_RoomTypePrice_RoomTypes] FOREIGN KEY ([RoomTypeId]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID]);


GO
PRINT N'Creating FK_RoomTypes_HotelBranches...';


GO
ALTER TABLE [dbo].[RoomTypes]
    ADD CONSTRAINT [FK_RoomTypes_HotelBranches] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[HotelBranches] ([BranchId]);


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f41392c3-4b75-43c9-9f93-79c800ad6e14')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f41392c3-4b75-43c9-9f93-79c800ad6e14')

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.'
GO
