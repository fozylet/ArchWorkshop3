CREATE TABLE [dbo].[RoomTypeAccessability] (
    [RoomTypeAccessabilityID] INT      NOT NULL,
    [RoomTypeID]              INT      NOT NULL,
    [NoOfRooms]               INT      NOT NULL,
    [FromDate]                DATETIME NOT NULL,
    [ToDate]                  DATETIME NOT NULL,
    CONSTRAINT [PK_RoomTypeDetails] PRIMARY KEY CLUSTERED ([RoomTypeAccessabilityID] ASC),
    CONSTRAINT [FK_RoomTypeDetails_RoomTypes] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID])
);

