using Microsoft.AspNetCore.Mvc;
using ProductService.Models;

namespace ProductService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductController : ControllerBase
{
    private readonly IConfiguration _configuration;
    private readonly HttpClient _httpClient;

    public ProductController(IConfiguration configuration)
    {
        _configuration = configuration;
        _httpClient = new HttpClient();
    }

    [HttpGet]
    public IActionResult GetProducts()
    {
        var products = new List<Product>
        {
            new Product { Id = 1, Name = "Product 1", Price = 10.99M },
            new Product { Id = 2, Name = "Product 2", Price = 20.99M }
        };
        return Ok(products);
    }

    [HttpGet("checkorder/{orderId}")]
    public async Task<IActionResult> CheckOrder(string orderId)
    {
        var orderServiceUrl = _configuration["OrderServiceUrl"];
        var response = await _httpClient.GetAsync($"{orderServiceUrl}/api/orders/{orderId}");
        
        if (response.IsSuccessStatusCode)
        {
            var order = await response.Content.ReadAsStringAsync();
            return Ok(order);
        }
        return NotFound();
    }
}