package com.example.promotion_system.config;

import com.example.promotion_system.entity.User;
import com.example.promotion_system.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

  @Autowired
  private UserRepository userRepository;

  @Autowired
  private PasswordEncoder passwordEncoder;

  @Override
  public void run(String... args) throws Exception {
    // Create admin user if not exists
    if (!userRepository.existsByUsername("admin")) {
      User admin = new User();
      admin.setUsername("admin");
      admin.setPassword(passwordEncoder.encode("admin123"));
      admin.setEmail("admin@promotionsystem.com");
      admin.setRole("ADMIN");
      admin.setIsActive(true);
      userRepository.save(admin);
      System.out.println("Admin user created: username=admin, password=admin123");
    }

    // Create regular user if not exists
    if (!userRepository.existsByUsername("user")) {
      User user = new User();
      user.setUsername("user");
      user.setPassword(passwordEncoder.encode("user123"));
      user.setEmail("user@promotionsystem.com");
      user.setRole("USER");
      user.setIsActive(true);
      userRepository.save(user);
      System.out.println("Regular user created: username=user, password=user123");
    }
  }
}
