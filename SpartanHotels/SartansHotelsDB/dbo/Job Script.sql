IF EXISTS (SELECT 1 from @TempTable)
	PRINT 'AVAILABLE'
ELSE 
	PRINT 'NOT AVAILABLE'
	
	--select * from numbers
	
	--drop table numbers
	--TRUNCATE TABLE NUMBERS
	--create table Numbers (number int primary key identity(1,1), a bit)

	--INsert INTO NUMBERS (a) VALUES (0)
	--GO 100
	
	--select *  from NUMBERS

	--select  Convert(varchar,getdate(),101)

	INSERT INTO RoomTypeAvailability  (RoomTypeID, RoomTypeAccessabilityID, ForDate, NoOfRoomBlocked)
	SELECT RT.RoomTypeID, RTA.RoomTypeAccessabilityID, DATEADD(dd,number,Convert(varchar,getdate(),101)) as ForDate, 0 as NoOfRoomsBlocked
	FROM
		Numbers n,
		RoomTypes RT 
		INNER JOIN  RoomTypeAccessability RTA
			ON RTA.RoomTypeID = RT.RoomTypeID
	WHERE DATEADD(dd,number,Convert(varchar,getdate(),101)) NOT IN (SELECT ForDate FROM RoomTypeAvailability RTAc WHERE RTAc.RoomTypeID = RT.RoomTypeID AND RTAc.RoomTypeAccessabilityID = RTA.RoomTypeAccessabilityID)


	INSERT INTO RoomOccupancy(RoomNumber, RoomTypeID, BranchId, ForDate, Hierarchy )
	SELECT (RT.RoomTypeID * 1000 + T.number) as RoomNumber, RT.RoomTypeID, RT.BranchId, DATEADD(dd,n.number,Convert(varchar,getdate(),101)) as ForDate, RT.Hierarchy
	FROM
		Numbers N,
		RoomTypes RT
		INNER JOIN  RoomTypeAccessability RTA
				ON RTA.RoomTypeID = RT.RoomTypeID

		INNER JOIN (SELECT n1.Number, RTA1.RoomTypeID 
				from  
				Numbers N1, 
				RoomTypes RT1
				INNER JOIN  RoomTypeAccessability RTA1
						ON RTA1.RoomTypeID = RT1.RoomTypeID
				WHERE n1.number <= RTA1.NoOfRooms) As T
		ON	T.RoomTypeID = RT.RoomTypeID
	WHERE DATEADD(dd,n.number,Convert(varchar,getdate(),101)) NOT IN (SELECT ForDate FROM RoomOccupancy RO WHERE RO.RoomTypeID = RT.RoomTypeID)
	Order by 2,3,1