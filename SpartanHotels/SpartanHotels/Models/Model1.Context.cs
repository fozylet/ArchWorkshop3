﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SpartanHotels.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class SpartanHotelsEntities1 : DbContext
    {
        public SpartanHotelsEntities1()
            : base("name=SpartanHotelsEntities1")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<Customer> Customers { get; set; }
        public DbSet<HotelBranch> HotelBranches { get; set; }
        public DbSet<HotelPartner> HotelPartners { get; set; }
        public DbSet<RoomOccupancy> RoomOccupancies { get; set; }
        public DbSet<RoomTypeAccessability> RoomTypeAccessabilities { get; set; }
        public DbSet<RoomTypeAvailability> RoomTypeAvailabilities { get; set; }
        public DbSet<RoomTypePrice> RoomTypePrices { get; set; }
        public DbSet<RoomType> RoomTypes { get; set; }
    }
}