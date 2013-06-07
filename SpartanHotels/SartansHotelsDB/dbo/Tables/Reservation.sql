CREATE TABLE [dbo].[Reservation] (
    [ReservationID]       INT              NOT NULL IDENTITY (1,1),
    [ReservationNumber]   UNIQUEIDENTIFIER NOT NULL,
    [FromDate]            DATETIME         NOT NULL,
    [ToDate]              DATETIME         NOT NULL,
    [CustomerId]          INT              NOT NULL,
    [RoomTypeID]   INT              NOT NULL,
    [PaymentMode]         NVARCHAR (50)    NULL,
    [PaymentSuccess]      BIT              NULL,
    [CancellationStatus]  BIT              NULL,
    [CancelledAt]         DATETIME         NULL,
    [CancellationRemarks] NVARCHAR (2000)  NULL,
    CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED ([ReservationID] ASC),
    CONSTRAINT [FK_Reservation_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]),
    CONSTRAINT [FK_Reservation_RoomTypes] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID])
);

