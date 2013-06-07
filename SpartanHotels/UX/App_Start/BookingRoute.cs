using System.Web.Routing;
using NavigationRoutes;
using UX.Controllers;

namespace BootstrapMvcSample
{
    public class BookingRoute
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.MapNavigationRoute<HomeController>("Home", c => c.Index());
           //routes.MapNavigationRoute<BookingCentralController>("Reservations", c => c.Index());
            routes.MapNavigationRoute<BookingCentralController>(" Hotel->FrontDesk", c => c.CheckinList());

        }
    }
}