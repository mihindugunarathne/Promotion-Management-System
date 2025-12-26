-- MySQL dump 10.13  Distrib 9.2.0, for Win64 (x86_64)
--
-- Host: localhost    Database: promotion_db
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `banner_image_path` varchar(500) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` varchar(20) NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user','$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlWacLhDRssBuW','user@promotion.com','USER',_binary '','2025-12-24 15:08:14','2025-12-24 15:08:14'),(2,'updateduser','$2a$10$98imhZx5AysxFeaGQXPBUOgNLCIBWEGULJZz1AJw7usOdDsEhdEAe','updated@example.com','USER',_binary '','2025-12-24 19:21:15','2025-12-24 20:02:43'),(4,'testuser_1779172891','$2a$10$wazbKqT93f8TfX7OtKJ7g.1SukSZlkczeuz1XW6e1.0CGhFf1.tg6','test@example.com','USER',_binary '','2025-12-24 19:32:32','2025-12-24 19:32:32'),(5,'newuser','$2a$10$l9BJyvDR2G/8XNfMuW/B4efG7dKLnIokEST/1.3JDHBO.wX6bqFum','newuser@example.com','USER',_binary '','2025-12-24 19:59:15','2025-12-24 19:59:15'),(6,'admin','$2a$10$hBs.wjQtni2G9gn/LlTkPuZcKCKbW0XJkBKPBTpWq9N.yKrvdPRdC','admin@promotionsystem.com','ADMIN',_binary '','2025-12-24 20:17:37','2025-12-24 20:17:37'),(7,'testUser1','$2a$10$1ZXmki/Xpoz9YYtH2Q2ELOqH8AsccchSVxZ3YwQ6X.MGwEJ6pLIkC','testuser1@gmail.com','USER',_binary '','2025-12-24 21:02:39','2025-12-24 21:02:39'),(8,'testUser2','$2a$10$mhnlQ46tFpOM72QFR84G0exDrULs/SZIrFLBVu49QHRCHZ2iaXYFK','testuser2@example.com','USER',_binary '','2025-12-25 01:28:09','2025-12-25 01:28:09'),(10,'Rathnayaka','$2a$10$wQXbo8cuGjTFUrvPp6FoXeomQchW4BN/AQpo2EOofyfRTI7y0RF5O','sr@gmail.com','ADMIN',_binary '','2025-12-25 23:14:45','2025-12-25 23:14:45');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'promotion_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-26 11:22:50
