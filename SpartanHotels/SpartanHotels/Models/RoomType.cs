//------------------------------------------------------------------------------
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
    using System.Collections.Generic;
    
    public partial class RoomType
    {
        public RoomType()
        {
            this.RoomTypeAccessabilities = new HashSet<RoomTypeAccessability>();
            this.RoomTypePrices = new HashSet<RoomTypePrice>();
        }
    
        public int RoomTypeID { get; set; }
        public string TypeName { get; set; }
        public Nullable<int> BranchId { get; set; }
        public string Details { get; set; }
        public string Facilities { get; set; }
        public Nullable<int> MaxAdults { get; set; }
        public Nullable<int> MaxChildren { get; set; }
    
        public virtual HotelBranch HotelBranch { get; set; }
        public virtual ICollection<RoomTypeAccessability> RoomTypeAccessabilities { get; set; }
        public virtual ICollection<RoomTypePrice> RoomTypePrices { get; set; }
    }
}