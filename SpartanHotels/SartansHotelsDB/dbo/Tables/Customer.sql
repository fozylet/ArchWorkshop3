CREATE TABLE [dbo].[Customer] (
    [CustomerId]    INT             NOT NULL,
    [CustomerName]  NVARCHAR (100)  NULL,
    [Address]       NVARCHAR (1000) NULL,
    [ContactNumber] NVARCHAR (50)   NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);

