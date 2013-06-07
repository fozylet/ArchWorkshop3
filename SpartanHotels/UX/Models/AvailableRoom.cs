using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UX.Models
{
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
    }
}