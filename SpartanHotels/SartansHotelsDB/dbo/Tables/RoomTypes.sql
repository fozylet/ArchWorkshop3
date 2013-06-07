CREATE TABLE [dbo].[RoomTypes] (
    [RoomTypeID]  INT             NOT NULL,
    [TypeName]    NVARCHAR (100)  NOT NULL,
    [BranchId]    INT             NULL,
    [Details]     NVARCHAR (2000) NULL,
    [Facilities]  NVARCHAR (2000) NULL,
    [MaxAdults]   INT             NULL,
    [MaxChildren] INT             NULL,
    [Hierarchy] INT NULL, 
    CONSTRAINT [PK_RoomTypes] PRIMARY KEY CLUSTERED ([RoomTypeID] ASC),
    CONSTRAINT [FK_RoomTypes_HotelBranches] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[HotelBranches] ([BranchId])
);

