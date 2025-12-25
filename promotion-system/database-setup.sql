-- Promotion Management System Database Setup
-- Run this script in MySQL to create the database

CREATE DATABASE IF NOT EXISTS promotion_db;
USE promotion_db;

-- Note: Tables will be automatically created by Spring Boot JPA
-- when you run the application with:
-- spring.jpa.hibernate.ddl-auto=update

-- The following tables will be created automatically:
-- - users (for user accounts)
-- - promotions (for promotion data)

-- Default users will be created automatically by DataInitializer:
-- Admin: username='admin', password='admin123'
-- User: username='user', password='user123'

