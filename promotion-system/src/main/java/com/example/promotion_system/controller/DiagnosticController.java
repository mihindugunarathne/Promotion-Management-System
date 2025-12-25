package com.example.promotion_system.controller;

import com.example.promotion_system.entity.User;
import com.example.promotion_system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/diagnostic")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DiagnosticController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/check-user/{username}")
    public ResponseEntity<?> checkUser(@PathVariable String username) {
        Map<String, Object> response = new HashMap<>();
        
        Optional<User> userOpt = userRepository.findByUsername(username);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            response.put("exists", true);
            response.put("username", user.getUsername());
            response.put("email", user.getEmail());
            response.put("role", user.getRole());
            response.put("isActive", user.getIsActive());
            response.put("id", user.getId());
            response.put("hasPassword", user.getPassword() != null && !user.getPassword().isEmpty());
            response.put("passwordLength", user.getPassword() != null ? user.getPassword().length() : 0);
            
            // Test password matching
            if (username.equals("admin")) {
                boolean matches = passwordEncoder.matches("admin123", user.getPassword());
                response.put("passwordMatches_admin123", matches);
            } else if (username.equals("user")) {
                boolean matches = passwordEncoder.matches("user123", user.getPassword());
                response.put("passwordMatches_user123", matches);
            }
            
            return ResponseEntity.ok(response);
        } else {
            response.put("exists", false);
            response.put("message", "User not found");
            return ResponseEntity.ok(response);
        }
    }

    @GetMapping("/all-users")
    public ResponseEntity<?> getAllUsers() {
        return ResponseEntity.ok(userRepository.findAll());
    }
}

