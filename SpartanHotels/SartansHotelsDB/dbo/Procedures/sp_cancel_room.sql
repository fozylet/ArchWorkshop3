CREATE PROCEDURE [dbo].[sp_cancel_room]
		@ReservationNumber uniqueidentifier,
		@CancellationRemarks VARCHAR(300)
AS
	
	IF NOT EXISTS (SELECT 1 FROM Reservation WHERE ReservationNumber = @ReservationNumber and CancellationStatus = 0)
		RETURN -1
		
	BEGIN TRAN

	Update [Reservation]
		SET [CancellationStatus] = 1,
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
