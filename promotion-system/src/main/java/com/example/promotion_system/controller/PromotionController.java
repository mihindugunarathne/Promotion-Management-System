package com.example.promotion_system.controller;

import com.example.promotion_system.dto.PromotionRequest;
import com.example.promotion_system.entity.Promotion;
import com.example.promotion_system.service.PromotionService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/promotions")
@CrossOrigin(origins = "*", maxAge = 3600)
public class PromotionController {

    @Autowired
    private PromotionService promotionService;

    @Autowired
    private ObjectMapper objectMapper;

    @PostMapping
    public ResponseEntity<?> createPromotion(
            @RequestParam("promotion") String promotionJson,
            @RequestParam(value = "file", required = false) MultipartFile file) {
        try {
            PromotionRequest request = objectMapper.readValue(promotionJson, PromotionRequest.class);
            Promotion promotion = promotionService.createPromotion(request, file);
            return ResponseEntity.status(HttpStatus.CREATED).body(promotion);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<List<Promotion>> getAllPromotions() {
        List<Promotion> promotions = promotionService.getAllPromotions();
        return ResponseEntity.ok(promotions);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPromotionById(@PathVariable Long id) {
        try {
            Promotion promotion = promotionService.getPromotionById(id);
            return ResponseEntity.ok(promotion);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePromotion(
            @PathVariable Long id,
            @RequestParam("promotion") String promotionJson,
            @RequestParam(value = "file", required = false) MultipartFile file) {
        try {
            PromotionRequest request = objectMapper.readValue(promotionJson, PromotionRequest.class);
            Promotion promotion = promotionService.updatePromotion(id, request, file);
            return ResponseEntity.ok(promotion);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePromotion(@PathVariable Long id) {
        try {
            promotionService.deletePromotion(id);
            return ResponseEntity.ok("Promotion deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error: " + e.getMessage());
        }
    }
}