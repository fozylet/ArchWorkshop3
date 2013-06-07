using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using UX.Models;

namespace UX.Controllers
{
    public class SearchController : ApiController
    {
        public IEnumerable<AvailableRoom> Get(BookingDetails details)
        {
            var availableRooms = new List<AvailableRoom>() {
                   new AvailableRoom() { Description = "Minimalist room for the economist traveller.", Name = "Sleep Dorm", Id = "1" },
                    new AvailableRoom() { Description = "Just the basics - bed and bathroom with shower.", Name = "RnR", Id = "2" },
                    new AvailableRoom() { Description = "Bedroom with workspace for the business traveller.", Name = "Working Suite", Id = "3" },
                    new AvailableRoom() { Description = "Private office space with minimalist sleeping quarters.", Name = "Office Away", Id = "4" },
                    new AvailableRoom() { Description = "Sleeping, living and dining accomodations.", Name = "Home Away", Id = "5" }};


            return availableRooms;
        }
    }

}
