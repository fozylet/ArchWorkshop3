CREATE TABLE [dbo].[RoomOccupancy] (
    [ID]               INT        NOT NULL Identity(1,1),
    [RoomNumber]       INT        NOT NULL,
    [ForDate]          DATETIME   NOT NULL,
    [BranchId] INT NOT NULL, 
	[RoomTypeID] INT        NOT NULL,
    [OccupiedAt]       DATETIME   NULL,
    [Remarks]          NCHAR (10) NULL,
    [ReservationID]    INT        NULL,
    [Hierarchy] INT NOT NULL, 
    
    [IsOccupied] BIT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_Rooms] PRIMARY KEY CLUSTERED ([RoomNumber] ASC, [ForDate] ASC),
    CONSTRAINT [FK_RoomOccupancy_Reservation] FOREIGN KEY ([ReservationID]) REFERENCES [dbo].[Reservation] ([ReservationID]),
    CONSTRAINT [FK_Rooms_RoomType] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID]),
	CONSTRAINT [FK_Rooms_HotelBranch] FOREIGN KEY ([BranchID]) REFERENCES [dbo].[HotelBranches] ([BranchId]),
);

