CREATE TABLE [dbo].[HotelBranches] (
    [BranchId] INT             NOT NULL,
    [Name]     NVARCHAR (250)  NOT NULL,
    [Details]  NVARCHAR (3000) NULL,
    [City]     NVARCHAR (100)  NULL,
    [Address]  NVARCHAR (1000) NULL,
    CONSTRAINT [PK_HotelBranches] PRIMARY KEY CLUSTERED ([BranchId] ASC)
);

