CREATE TABLE [dbo].[RoomTypePrice] (
    [RoomTypePriceId] INT      NOT NULL,
    [Price]           MONEY    NOT NULL,
    [FromDate]        DATETIME NOT NULL,
    [ToDate]          DATETIME NOT NULL,
    [RoomTypeId]      INT      NOT NULL,
    CONSTRAINT [PK_RoomTypePrice] PRIMARY KEY CLUSTERED ([RoomTypePriceId] ASC),
    CONSTRAINT [FK_RoomTypePrice_RoomTypes] FOREIGN KEY ([RoomTypeId]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID])
);

