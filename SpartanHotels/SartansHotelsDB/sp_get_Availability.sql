CREATE PROCEDURE [dbo].[sp_get_Availability]
	@BranchID int,
	@FromDate DateTime,
	@ToDate	 DateTime,
	@IncludePartner BIT = 1
AS
	DECLARE @OverLoadPercent INT
	SELECT @OverLoadPercent = ISNULL (c.Value, 0) 
	FROM Configurations c
	Where c.Name = 'OverLoadPercent'


	Select RT.RoomTypeID, RT.TypeName, RT.Facilities, 0 as ReturnType
	from RoomTypes RT
		Inner Join RoomTypeAccessability RTA
			On  RT.RoomTypeID = RTA.RoomTypeID
		Left Join RoomTypeAvailability RTAv
			On RTA.RoomTypeAccessabilityID = RTAv.RoomTypeAccessabilityID
				AND RTAv.FORDATE between @FromDate and @ToDate

	WHERE RT.BranchID = @BranchID
		AND	(RTA.FromDate Between @FromDate and @ToDate 
				OR RTA.ToDate Between @FromDate and @ToDate)
		AND RTAv.NoOfRoomBlocked < (RTA.NoOfRooms + (RTA.NoOfRooms * (@OverLoadPercent * 0.01))) 
		
	UNION

	Select HP.PartnerID, Hp.URL, Hp.Details, 1 as ReturnType
	from HotelPartners HP
	WHERE HP.BranchID = @BranchID
		AND @IncludePartner  = 1