CREATE PROCEDURE [dbo].[sp_book_room]
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

