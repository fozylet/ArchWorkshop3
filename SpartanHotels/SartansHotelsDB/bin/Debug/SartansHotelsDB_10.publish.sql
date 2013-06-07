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
		
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK
			RETURN -1
		END

		-- Update Availability
		Update RoomTypeAvailability
		SET NoOfRoomBlocked = NoOfRoomBlocked + 1
		WHERE ForDate between @FromDate and @ToDate
			AND RoomTypeID = @RoomTypeID

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK
			RETURN -1
		END


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

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK
		RETURN -1
	END

	-- Update Availability
	Update RoomTypeAvailability 
	SET NoOfRoomBlocked = NoOfRoomBlocked - 1
	FROM Reservation R
		INNER JOIN  RoomTypeAvailability RTA
			ON RTA.ForDate between R.FromDate and R.ToDate
				AND RTA.RoomTypeID = R.RoomTypeID
	WHERE R.ReservationNumber = @ReservationNumber

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK
		RETURN -1
	END


	COMMIT
	RETURN 0
GO
PRINT N'Update complete.'
GO
