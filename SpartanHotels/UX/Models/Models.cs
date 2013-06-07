using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UX.Models
{

    public class AvailableCity
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }

    public class AvailableRoom
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }

    public class BookingDetails
    {
        public int NumberOfAdults { get; set; }
        public int CityId { get; set; }
        public string CheckinDate { get; set; }
        public string CheckoutDate { get; set; }
        public string GuestId { get; set; }
        public string IncludePartners { get; set; }
        public string RoomTypeID { get; set; }
    }


    public class BookingConfirmation
    {
        public string BookingId { get; set; }
        public string ReservationId { get; set; }

    }

    public class BookingCancellation
    {
        public string BookingId { get; set; }
        public string ReservationId { get; set; }
        public bool IsRefunded { get; set; }
    }

    public class CheckinDetails
    {
        public string ReservationId { get; set; }
        public int RoomNumber { get; set; }
        public bool IsUpgraded { get; set; }
    }


}