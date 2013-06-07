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
    
    public partial class RoomOccupancy
    {
        public int ID { get; set; }
        public int RoomNumber { get; set; }
        public System.DateTime ForDate { get; set; }
        public int RoomTypeAccessabilityID { get; set; }
        public Nullable<System.DateTime> OccupiedAt { get; set; }
        public string Remarks { get; set; }
        public int ReservationID { get; set; }
    
        public virtual RoomTypeAccessability RoomTypeAccessability { get; set; }
    }
}
