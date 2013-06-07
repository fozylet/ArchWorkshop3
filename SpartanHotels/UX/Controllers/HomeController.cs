using System.Configuration;
using System.Web.Mvc;
using UX.Models;

namespace UX.Controllers
{
    public class HomeController : Controller
    {
        //
        // GET: /Home/

        public ActionResult Index()
        {
            var model = new HomeViewModel
                {
                    Title = ConfigurationManager.AppSettings["Title"].ToString(),
                    ConvincingMarketingWords = ConfigurationManager.AppSettings["ConvincingMarketingWords"].ToString(),
                    Splash = ConfigurationManager.AppSettings["Splash"].ToString()
                };
            return View(model);
        }

    }
}
