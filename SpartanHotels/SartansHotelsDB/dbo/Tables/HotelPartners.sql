CREATE TABLE [dbo].[HotelPartners] (
    [PartnerID]  INT             NOT NULL,
    [BranchId]   INT             NOT NULL,
    [URL]        NVARCHAR (300)  NULL,
    [Details]    NVARCHAR (3000) NULL,
    [CouponCode] NVARCHAR (50)   NULL,
    CONSTRAINT [PK_HotelPartners] PRIMARY KEY CLUSTERED ([PartnerID] ASC),
    CONSTRAINT [FK_HotelPartners_HotelBranches] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[HotelBranches] ([BranchId])
);

