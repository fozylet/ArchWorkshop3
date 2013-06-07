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
/*
The column [dbo].[Reservation].[RoomTypeDetailsID] is being dropped, data loss could occur.

The column [dbo].[Reservation].[RoomTypeID] on table [dbo].[Reservation] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Reservation])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping FK_Reservation_Customer...';


GO
ALTER TABLE [dbo].[Reservation] DROP CONSTRAINT [FK_Reservation_Customer];


GO
PRINT N'Dropping FK_Reservation_RoomTypeAccessability...';


GO
ALTER TABLE [dbo].[Reservation] DROP CONSTRAINT [FK_Reservation_RoomTypeAccessability];


GO
PRINT N'Dropping FK_RoomOccupancy_Reservation...';


GO
ALTER TABLE [dbo].[RoomOccupancy] DROP CONSTRAINT [FK_RoomOccupancy_Reservation];


GO
PRINT N'Starting rebuilding table [dbo].[Reservation]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Reservation] (
    [ReservationID]       INT              NOT NULL,
    [ReservationNumber]   UNIQUEIDENTIFIER NOT NULL,
    [FromDate]            DATETIME         NOT NULL,
    [ToDate]              DATETIME         NOT NULL,
    [CustomerId]          INT              NOT NULL,
    [RoomTypeID]          INT              NOT NULL,
    [PaymentMode]         NVARCHAR (50)    NULL,
    [PaymentSuccess]      BIT              NULL,
    [CancellationStatus]  BIT              NULL,
    [CancelledAt]         DATETIME         NULL,
    [CancellationRemarks] NVARCHAR (2000)  NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Reservation] PRIMARY KEY CLUSTERED ([ReservationID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Reservation])
    BEGIN
        
        INSERT INTO [dbo].[tmp_ms_xx_Reservation] ([ReservationID], [ReservationNumber], [FromDate], [ToDate], [CustomerId], [PaymentMode], [PaymentSuccess], [CancellationStatus], [CancelledAt], [CancellationRemarks])
        SELECT   [ReservationID],
                 [ReservationNumber],
                 [FromDate],
                 [ToDate],
                 [CustomerId],
                 [PaymentMode],
                 [PaymentSuccess],
                 [CancellationStatus],
                 [CancelledAt],
                 [CancellationRemarks]
        FROM     [dbo].[Reservation]
        ORDER BY [ReservationID] ASC;
        
    END

DROP TABLE [dbo].[Reservation];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Reservation]', N'Reservation';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Reservation]', N'PK_Reservation', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating FK_Reservation_Customer...';


GO
ALTER TABLE [dbo].[Reservation] WITH NOCHECK
    ADD CONSTRAINT [FK_Reservation_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);


GO
PRINT N'Creating FK_RoomOccupancy_Reservation...';


GO
ALTER TABLE [dbo].[RoomOccupancy] WITH NOCHECK
    ADD CONSTRAINT [FK_RoomOccupancy_Reservation] FOREIGN KEY ([ReservationID]) REFERENCES [dbo].[Reservation] ([ReservationID]);


GO
PRINT N'Creating FK_Reservation_RoomTypes...';


GO
ALTER TABLE [dbo].[Reservation] WITH NOCHECK
    ADD CONSTRAINT [FK_Reservation_RoomTypes] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID]);


GO
PRINT N'Altering [dbo].[sp_book_room]...';


GO
ALTER PROCEDURE [dbo].[sp_book_room]
	@BranchID INT,
	@ReservationNumber uniqueidentifier,
	@RoomTypeID INT,
	@FromDate DateTime,
	@ToDate DateTime,
	@CustomerId INT
AS
	
	IF NOT EXISTS ( SELECT 1 from RoomTypeAvailability 
		WHERE RoomTypeID = @RoomTypeID
			AND ForDate in (@FromDate, @ToDate))

			RETURN -1

			
	DECLARE @TempTable TABLE (RoomTypeID INT, TypeName Varchar(50), Facilities VARCHAR(300), ReturnType INT)
	INSERT INTO @TempTable
	exec [sp_get_Availability] @BranchId, @FromDate, @ToDate, 0, @RoomTypeID

	IF EXISTS (SELECT 1 from @TempTable)
	BEGIN

		BEGIN TRAN
		--Insert REservation
	
		INSERT INTO [dbo].[Reservation]
			   ([ReservationNumber]
			   ,[FromDate]
			   ,[ToDate]
			   ,[CustomerId]
			   ,[RoomTypeID]
			   ,[PaymentMode]
			   ,[PaymentSuccess]
			   ,[CancellationStatus]
			   ,[CancelledAt]
			   ,[CancellationRemarks])
		 SELECT 
			   @ReservationNumber
			   ,@FromDate
			   ,@ToDate
			   ,@CustomerId
			   ,@RoomTypeID
			   ,NULL
			   ,1
			   ,0
			   ,NULL
			   ,NULL
		

		-- Update Availability
		Update RoomTypeAvailability
		SET NoOfRoomBlocked = NoOfRoomBlocked + 1
		WHERE ForDate between @FromDate and @ToDate
			AND RoomTypeID = @RoomTypeID

		COMMIT 
		RETURN 0
	END
	ELSE 
		RETURN -2
GO
PRINT N'Altering [dbo].[sp_cancel_room]...';


GO
ALTER PROCEDURE [dbo].[sp_cancel_room]
		@ReservationNumber uniqueidentifier,
		@CancellationRemarks VARCHAR(300)
AS
	
	IF NOT EXISTS (SELECT 1 FROM Reservation WHERE ReservationNumber = @ReservationNumber and CancellationStatus = 0)
		RETURN -1
		
	BEGIN TRAN

	Update [Reservation]
	SET [CancellationStatus] = 0,
				[CancelledAt] = GETDATE(),
			   [CancellationRemarks] = @CancellationRemarks
	WHERE ReservationNumber = @ReservationNumber

	-- Update Availability
	Update RoomTypeAvailability 
	SET NoOfRoomBlocked = NoOfRoomBlocked - 1
	FROM Reservation R
		INNER JOIN  RoomTypeAvailability RTA
			ON RTA.ForDate between R.FromDate and R.ToDate
				AND RTA.RoomTypeID = R.RoomTypeID
	WHERE R.ReservationNumber = @ReservationNumber

	COMMIT
	RETURN 0
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Reservation] WITH CHECK CHECK CONSTRAINT [FK_Reservation_Customer];

ALTER TABLE [dbo].[RoomOccupancy] WITH CHECK CHECK CONSTRAINT [FK_RoomOccupancy_Reservation];

ALTER TABLE [dbo].[Reservation] WITH CHECK CHECK CONSTRAINT [FK_Reservation_RoomTypes];


GO
PRINT N'Update complete.'
GO
