package com.example.orderservice.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/orders")
public class OrderController {
    
    @Value("${PRODUCT_SERVICE_URL}")
    private String productServiceUrl;
    
    private final RestTemplate restTemplate;
    
    public OrderController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    @GetMapping("/{orderId}")
    public ResponseEntity<String> getOrder(@PathVariable String orderId) {
        return ResponseEntity.ok("Order " + orderId + " details");
    }
    
    @GetMapping("/checkproduct/{productId}")
    public ResponseEntity<?> checkProduct(@PathVariable int productId) {
        try {
            ResponseEntity<?> response = restTemplate.getForEntity(
                productServiceUrl + "/api/products/" + productId,
                Object.class
            );
            return response;
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
}