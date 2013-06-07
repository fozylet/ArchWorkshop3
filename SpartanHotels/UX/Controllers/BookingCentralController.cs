using System.Web.Mvc;
using UX.Models;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Linq;
using System;


namespace UX.Controllers
{
    public class BookingCentralController : Controller
    {

        /// <summary>
        /// Deafult...
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            var model = new Models.InitialBookingViewModel
                {
                    BookingIntroduction =
                        "Welcome to Spartan's online room reservation system.  To researve a room, simply select a city, dates, the number of adults and click the 'show available rooms' button.",
                    Splash = "Room Reservations",
                    Title = "Spartan's Online Room Reservation System",
                };
            return View(model);
        }



        /// <summary>
        /// Called when a SINGLE ROOM IS BOOKED
        /// </summary>
        /// <returns></returns>
        public JsonResult Book(BookingDetails bookingDetails)
        {
            Guid guid = Guid.NewGuid();
            var bookingConfirmationDetails = new Models.BookingConfirmation { BookingId = guid.ToString(), ReservationId = guid.ToString() };
            // BookingDetails bookingDetails = new BookingDetails { CityId = 1, GuestId = "1", CheckinDate = "6/5/2013", CheckoutDate = "6/12/2013", NumberOfAdults = 2, RoomTypeID = "3" };

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["defaultConnection"].ConnectionString);
            SqlCommand cmd = new SqlCommand("sp_book_room", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@BranchID", bookingDetails.CityId);
            cmd.Parameters.AddWithValue("@ReservationNumber", bookingConfirmationDetails.ReservationId);
            cmd.Parameters.AddWithValue("@FromDate", bookingDetails.CheckinDate);
            cmd.Parameters.AddWithValue("@ToDate", bookingDetails.CheckoutDate);
            cmd.Parameters.AddWithValue("@RoomTypeID", int.Parse(bookingDetails.RoomTypeID));
            cmd.Parameters.AddWithValue("@CustomerId", 1);
            SqlParameter param = new SqlParameter("@RtnValue", SqlDbType.Int);
            param.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(param);
            conn.Open();
            cmd.ExecuteScalar();
            conn.Close();
            if ((int)cmd.Parameters["@RtnValue"].Value != 0)
            {
                return null;
            }

            return Json(bookingConfirmationDetails, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// To get a list of cities
        /// </summary>
        /// <returns></returns>
        public JsonResult GetCities()
        {
            Models.SartansHotelsDBEntities hotelBranches = new SartansHotelsDBEntities();
            var theCities = hotelBranches
                .HotelBranches
                .ToList()
                .Select(item => new AvailableCity
                {
                    Description = item.Details,
                    Name = item.Name,
                    Id = item.BranchId.ToString()
                }).ToList();

            return Json(theCities, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// This gives search results
        /// </summary>
        /// <returns></returns>
        public JsonResult GetRooms(BookingDetails bookingDetails)
        {
            // BookingDetails bookingDetails = new BookingDetails { CityId = 1, GuestId = "1", CheckinDate = "6/5/2013", CheckoutDate = "6/12/2013", NumberOfAdults = 2 };

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            SqlCommand cmd = new SqlCommand("sp_get_availability", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@BranchID", bookingDetails.CityId);
            cmd.Parameters.AddWithValue("@FromDate", bookingDetails.CheckinDate);
            cmd.Parameters.AddWithValue("@ToDate", bookingDetails.CheckoutDate);
            cmd.Parameters.AddWithValue("@IncludePartner", 0);
            SqlParameter param = new SqlParameter("@RtnValue", SqlDbType.Int);
            param.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(param);


            SqlDataAdapter adpter = new SqlDataAdapter(cmd);
            DataSet dataSet = new DataSet();
            adpter.Fill(dataSet);

            if ((int)cmd.Parameters["@RtnValue"].Value != 0)
            {
                return null;
            }

            if (dataSet == null || dataSet.Tables == null || dataSet.Tables.Count == 0 || dataSet.Tables[0].Rows == null || dataSet.Tables[0].Rows.Count == 0)
            {
                return null;
            }

            var availableRooms = new List<AvailableRoom>();

            foreach (DataRow dataRow in dataSet.Tables[0].Rows)
            {
                AvailableRoom availableRoom = new AvailableRoom();
                availableRoom.Id = dataRow["RoomTypeID"].ToString();
                availableRoom.Name = dataRow["TypeName"].ToString();
                availableRoom.Description = dataRow["facilities"].ToString();
                availableRooms.Add(availableRoom);
            }

            return Json(availableRooms, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Called with 'CANCEL a reservation'
        /// </summary>
        /// <returns></returns>
        public ActionResult Cancel(BookingCancellation bookingCancellationDetails)
        {
            //var bookingCancellationDetails = new Models.BookingCancellation { BookingId = "A1234", ReservationId = "B1234" };
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["defaultConnection"].ConnectionString);
            SqlCommand cmd = new SqlCommand("sp_cancel_room", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ReservationNumber", bookingCancellationDetails.ReservationId);
            cmd.Parameters.AddWithValue("@CancellationRemarks", string.Empty);
            SqlParameter param = new SqlParameter("@RtnValue", SqlDbType.Int);
            param.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(param);
            conn.Open();
            cmd.ExecuteScalar();
            conn.Close();

            if ((int)cmd.Parameters["@RtnValue"].Value != 0)
            {
                return null;
            }


            return View(bookingCancellationDetails);
        }

        public ActionResult Reservations()
        {
            Models.SartansHotelsDBEntities1 dbEntities = new SartansHotelsDBEntities1();
            // dbEntities.Reservations.ToList();
            return View(dbEntities.Reservations.ToList());
        }

        public ActionResult CheckinList()
        {
            Models.SartansHotelsDBEntities1 dbEntities = new SartansHotelsDBEntities1();
            // dbEntities.Reservations.ToList();
            return View(dbEntities.Reservations.ToList());
        }

        public ActionResult CheckIn(CheckinDetails checkinDetails)
        {
            
            return View(checkinDetails);
        }
    }
}
