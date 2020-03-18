using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MVC_K8S.Data;
using MVC_K8S.Models;

namespace MVC_K8S.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly ApplicationDbContext context;
        private readonly IConfiguration _config;


        public HomeController(ILogger<HomeController> logger, ApplicationDbContext context, IConfiguration config)
        {
            _logger = logger;
            this.context = context;
            this._config = config;
        }

        public IActionResult Index()
        {
            return View();
        }
        public string Con()
        {
            return _config.GetConnectionString("DefaultConnection");
        }

        public string Setup()
        {
            context.Database.Migrate();
            return "Done";
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
