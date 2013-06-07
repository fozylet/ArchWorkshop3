CREATE TABLE [dbo].[RoomTypeAvailability] (
    [ID]                INT      NOT NULL Primary KEy IdENTITY (1,1),
	[RoomTypeID]		INT		NOT NULL,
    [RoomTypeAccessabilityID] INT      NOT NULL,
    [ForDate]           DATETIME NOT NULL,
    [NoOfRoomBlocked]   INT      NOT NULL,
    CONSTRAINT [FK_RoomTypeAvailability_RoomTypeDetails] FOREIGN KEY ([RoomTypeAccessabilityID]) REFERENCES [dbo].[RoomTypeAccessability] ([RoomTypeAccessabilityID]),
	CONSTRAINT [FK_RoomTypeAvailability_RoomType] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID])
);

