CREATE PROCEDURE [dbo].[sp_get_Availability]
	@BranchID int,
	@FromDate DateTime,
	@ToDate	 DateTime,
	@IncludePartner BIT = 1,
	@RoomType INT = NULL
AS
	DECLARE @OverLoadPercent INT = 0
	SELECT @OverLoadPercent = ISNULL (c.Value, 0) 
	FROM Configurations c
	Where c.Name = 'OverLoadPercent'

	DECLARE @MinRoomsAvailable TABLE (RoomTypeID INT, RoomsAvailable INT)

	--Get Minimum available rooms after checking accessability
	INSERT INTO @MinRoomsAvailable
	SELECT RT.RoomTypeID, MIN((RTA.NoOfRooms + (RTA.NoOfRooms * (@OverLoadPercent * 0.01)))) as RoomsAvailable
	from RoomTypes RT
	Inner Join RoomTypeAccessability RTA
		On  RT.RoomTypeID = RTA.RoomTypeID
	WHERE RT.BranchID = @BranchID
		AND	(@FromDate Between RTA.FromDate  and RTA.ToDate 
				OR @ToDate Between RTA.FromDate  and RTA.ToDate)
	Group BY RT.RoomTypeID
	
	-- Get Maximum rooms booked during the time period
	DECLARE @MaxRoomsBlocked TABLE (RoomTypeID INT, RoomsBlocked INT)
	INSERT INTO @MaxRoomsBlocked
	SELECT RT.RoomTypeID, MAX(RTA.NoOfRoomBlocked) as RoomsBlocked
	from RoomTypes RT
	Inner Join RoomTypeAvailability RTA
		On  RT.RoomTypeID = RTA.RoomTypeID
	WHERE RT.BranchID = @BranchID
		AND	RTA.ForDate Between @FromDate and @ToDate 
	Group BY RT.RoomTypeID

	

	-- Get Available rooms types.
	Select RT.RoomTypeID, RT.TypeName, RT.Facilities, 0 as ReturnType
	from RoomTypes RT
		Inner Join @MinRoomsAvailable RTA
			On  RT.RoomTypeID = RTA.RoomTypeID
		left Join @MaxRoomsBlocked RTAv
			On RTA.RoomTypeID = RTAv.RoomTypeID
	WHERE RTAv.RoomsBlocked < RTA.RoomsAvailable
		AND (@RoomType IS NULL OR RT.RoomTypeID = @RoomType)
		
	UNION

	Select HP.PartnerID, Hp.URL, Hp.Details, 1 as ReturnType
	from HotelPartners HP
	WHERE HP.BranchID = @BranchID
		AND @IncludePartner  = 1