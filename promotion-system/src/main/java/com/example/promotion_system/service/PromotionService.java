package com.example.promotion_system.service;

import com.example.promotion_system.dto.PromotionRequest;
import com.example.promotion_system.entity.Promotion;
import com.example.promotion_system.entity.User;
import com.example.promotion_system.repository.PromotionRepository;
import com.example.promotion_system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@Service
public class PromotionService {

    @Autowired
    private PromotionRepository promotionRepository;

    @Autowired
    private UserRepository userRepository;

    @Value("${file.upload-dir}")
    private String uploadDir;

    public Promotion createPromotion(PromotionRequest request, MultipartFile file) throws IOException {
        String username = getCurrentUsername();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Promotion promotion = new Promotion();
        promotion.setName(request.getName());
        promotion.setStartDate(request.getStartDate());
        promotion.setEndDate(request.getEndDate());
        promotion.setCreatedBy(user.getId());

        if (file != null && !file.isEmpty()) {
            String filename = saveFile(file);
            promotion.setBannerImagePath(filename);
        }

        return promotionRepository.save(promotion);
    }

    public List<Promotion> getAllPromotions() {
        return promotionRepository.findAll();
    }

    public Promotion getPromotionById(Long id) {
        return promotionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Promotion not found with id: " + id));
    }

    public Promotion updatePromotion(Long id, PromotionRequest request, MultipartFile file) throws IOException {
        Promotion promotion = getPromotionById(id);
        
        // Check authorization: Admin can edit any promotion, users can only edit their own
        checkAuthorization(promotion);

        promotion.setName(request.getName());
        promotion.setStartDate(request.getStartDate());
        promotion.setEndDate(request.getEndDate());

        if (file != null && !file.isEmpty()) {
            // Delete old file if exists
            if (promotion.getBannerImagePath() != null) {
                deleteFile(promotion.getBannerImagePath());
            }
            String filename = saveFile(file);
            promotion.setBannerImagePath(filename);
        }

        return promotionRepository.save(promotion);
    }

    public void deletePromotion(Long id) {
        Promotion promotion = getPromotionById(id);
        
        // Check authorization: Admin can delete any promotion, users can only delete their own
        checkAuthorization(promotion);

        // Delete banner image if exists
        if (promotion.getBannerImagePath() != null) {
            deleteFile(promotion.getBannerImagePath());
        }

        promotionRepository.delete(promotion);
    }

    private String saveFile(MultipartFile file) throws IOException {
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String filename = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path filePath = uploadPath.resolve(filename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return filename;
    }

    private void deleteFile(String filename) {
        try {
            Path filePath = Paths.get(uploadDir).resolve(filename);
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            // Log error but don't throw exception
            System.err.println("Error deleting file: " + e.getMessage());
        }
    }

    private String getCurrentUsername() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            return ((UserDetails) principal).getUsername();
        }
        return principal.toString();
    }
    
    private User getCurrentUser() {
        String username = getCurrentUsername();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    private boolean isAdmin(User user) {
        return "ADMIN".equalsIgnoreCase(user.getRole());
    }
    
    private boolean isOwner(Promotion promotion, User user) {
        return promotion.getCreatedBy() != null && promotion.getCreatedBy().equals(user.getId());
    }
    
    private void checkAuthorization(Promotion promotion) {
        User currentUser = getCurrentUser();
        
        // Admin can edit/delete any promotion
        if (isAdmin(currentUser)) {
            return;
        }
        
        // Users can only edit/delete promotions they created
        if (!isOwner(promotion, currentUser)) {
            throw new RuntimeException("Unauthorized: You can only edit/delete promotions you created");
        }
    }
}