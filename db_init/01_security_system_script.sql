CREATE DATABASE  IF NOT EXISTS `Security_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `Security_system`;
-- MySQL dump 10.13  Distrib 8.0.43, for macos15 (x86_64)
--
-- Host: 127.0.0.1    Database: Security_system
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `notification_settings`
--

DROP TABLE IF EXISTS `notification_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `object_id` int NOT NULL,
  `notification_type` varchar(50) NOT NULL,
  ` delivery_method` varchar(45) NOT NULL,
  `is_enabled` tinyint NOT NULL,
  `min_severity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_10_idx` (`user_id`),
  KEY `fk_11_idx` (`object_id`),
  CONSTRAINT `fk_10` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_11` FOREIGN KEY (`object_id`) REFERENCES `objects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_settings`
--

LOCK TABLES `notification_settings` WRITE;
/*!40000 ALTER TABLE `notification_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objects`
--

DROP TABLE IF EXISTS `objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objects` (
  `id` int NOT NULL AUTO_INCREMENT,
  ` name` varchar(45) NOT NULL,
  `address` varchar(45) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objects`
--

LOCK TABLES `objects` WRITE;
/*!40000 ALTER TABLE `objects` DISABLE KEYS */;
INSERT INTO `objects` VALUES (3,'Office A','Kyiv, Shevchenko 10','Head office'),(4,'Warehouse B','Lviv, Franka 22','Storage facility'),(5,'Factory C','Dnipro, Haharina 101','Production plant'),(6,'Data Center D','Kharkiv, Sumska 55','Critical IT infrastructure'),(7,'Store E','Odesa, Deribasivska 12','Retail store');
/*!40000 ALTER TABLE `objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zone_id` int NOT NULL,
  `name` varchar(70) NOT NULL,
  `room_type` varchar(45) DEFAULT NULL,
  `floor_number` int NOT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_6_idx` (`zone_id`),
  CONSTRAINT `fk_5` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (24,1,'Reception Desk','Office',1,'2025-10-08 18:23:54'),(25,1,'Waiting Area','Lobby',1,'2025-10-08 18:23:54'),(26,2,'Server Rack A','Server',-1,'2025-10-08 18:23:54'),(27,2,'Server Rack B','Server',-1,'2025-10-08 18:23:54'),(28,3,'Dock 1','Cargo',0,'2025-10-08 18:23:54'),(29,3,'Dock 2','Cargo',0,'2025-10-08 18:23:54'),(30,4,'Storage A1','Warehouse',1,'2025-10-08 18:23:54'),(31,4,'Storage A2','Warehouse',1,'2025-10-08 18:23:54'),(32,5,'Assembly Hall A','Industrial',2,'2025-10-08 18:23:54'),(33,6,'Packaging Hall B','Industrial',2,'2025-10-08 18:23:54');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensor_notifications`
--

DROP TABLE IF EXISTS `sensor_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensor_notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sensor_id` int NOT NULL,
  `notification_type` varchar(45) NOT NULL,
  ` severity` int NOT NULL,
  `message` varchar(100) NOT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_2_idx` (`sensor_id`),
  KEY `created_1` (`created`),
  CONSTRAINT `fk_2` FOREIGN KEY (`sensor_id`) REFERENCES `sensors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor_notifications`
--

LOCK TABLES `sensor_notifications` WRITE;
/*!40000 ALTER TABLE `sensor_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `sensor_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensor_settings`
--

DROP TABLE IF EXISTS `sensor_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensor_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sensor_id` int NOT NULL,
  `parameter_name` varchar(45) NOT NULL,
  `parameter_value` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_idx` (`sensor_id`),
  CONSTRAINT `fk_12` FOREIGN KEY (`sensor_id`) REFERENCES `sensors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor_settings`
--

LOCK TABLES `sensor_settings` WRITE;
/*!40000 ALTER TABLE `sensor_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `sensor_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensor_types`
--

DROP TABLE IF EXISTS `sensor_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensor_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor_types`
--

LOCK TABLES `sensor_types` WRITE;
/*!40000 ALTER TABLE `sensor_types` DISABLE KEYS */;
INSERT INTO `sensor_types` VALUES (7,'Motion Sensor','Detects movements'),(8,'Smoke Detector','Detects smoke and fire'),(9,'Temperature Sensor','Monitors temperature'),(10,'Access Card Reader','Controls access with cards'),(11,'CCTV Camera','Video surveillance'),(12,'Gas Sensor','Detects hazardous gases'),(13,'Glass Break Sensor','Detects window breakage');
/*!40000 ALTER TABLE `sensor_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensors`
--

DROP TABLE IF EXISTS `sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sensor_type_id` int NOT NULL,
  `room_id` int NOT NULL,
  `name` varchar(30) NOT NULL,
  `last_maintenance` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sensor_type_id_idx` (`sensor_type_id`),
  KEY `fk_8_idx` (`room_id`),
  KEY `fk_9_idx` (`room_id`),
  CONSTRAINT `fk_0` FOREIGN KEY (`sensor_type_id`) REFERENCES `sensor_types` (`id`),
  CONSTRAINT `fk_9` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensors`
--

LOCK TABLES `sensors` WRITE;
/*!40000 ALTER TABLE `sensors` DISABLE KEYS */;
INSERT INTO `sensors` VALUES (12,1,1,'Motion-01','2025-01-10'),(13,2,3,'Smoke-01','2025-02-15'),(14,3,5,'Temp-01','2025-03-01'),(15,4,1,'Reader-01','2025-01-20'),(16,5,2,'CCTV-01','2025-04-01'),(17,6,7,'Gas-01','2025-02-25'),(18,7,10,'Glass-01','2025-03-18'),(19,1,8,'Motion-02','2025-03-05'),(20,2,4,'Smoke-02','2025-02-10'),(21,3,9,'Temp-02','2025-03-22');
/*!40000 ALTER TABLE `sensors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_notifications`
--

DROP TABLE IF EXISTS `system_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `object_id` int NOT NULL,
  ` title` varchar(45) NOT NULL,
  `message` varchar(45) NOT NULL,
  `notification_type` varchar(45) NOT NULL,
  `severity` int NOT NULL,
  `delivery_method` varchar(45) DEFAULT NULL,
  `delivery_status` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created` (`created_at`),
  KEY `fk_13_idx` (`user_id`),
  KEY `fk_14_idx` (`object_id`),
  CONSTRAINT `fk_13` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_14` FOREIGN KEY (`object_id`) REFERENCES `objects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_notifications`
--

LOCK TABLES `system_notifications` WRITE;
/*!40000 ALTER TABLE `system_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_object_access`
--

DROP TABLE IF EXISTS `user_object_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_object_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `object_id` int NOT NULL,
  `access_level` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_7_idx` (`user_id`),
  KEY `fk_8_idx` (`object_id`),
  CONSTRAINT `fk_7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_8` FOREIGN KEY (`object_id`) REFERENCES `objects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_object_access`
--

LOCK TABLES `user_object_access` WRITE;
/*!40000 ALTER TABLE `user_object_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_object_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `email` varchar(87) NOT NULL,
  `password_hash` varchar(45) NOT NULL,
  `full_name` varchar(160) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `role` varchar(60) DEFAULT 'user',
  `is_active` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (6,'admin01','admin01@mail.com','hash123','John Smith','+380501112233','admin',1),(7,'operator01','op01@mail.com','hash124','Alice Johnson','+380502223344','operator',1),(8,'user01','user01@mail.com','hash125','Bob Brown','+380503334455','user',1),(9,'user02','user02@mail.com','hash126','Charlie Davis','+380504445566','user',0),(10,'user03','user03@mail.com','hash127','Eva Green','+380505556677','user',1),(11,'operator02','op02@mail.com','hash128','Michael White','+380506667788','operator',1),(12,'admin02','admin02@mail.com','hash129','Sarah Parker','+380507778899','admin',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zones`
--

DROP TABLE IF EXISTS `zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `object_id` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `access_level` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_4_idx` (`object_id`),
  CONSTRAINT `fk_4` FOREIGN KEY (`object_id`) REFERENCES `objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zones`
--

LOCK TABLES `zones` WRITE;
/*!40000 ALTER TABLE `zones` DISABLE KEYS */;
INSERT INTO `zones` VALUES (8,1,'Reception','Main entrance zone',1),(9,1,'Server Room','Critical servers',5),(10,2,'Loading Dock','Cargo zone',2),(11,2,'Storage Hall','Warehouse main area',3),(12,3,'Production Line 1','Assembly area',2),(13,3,'Production Line 2','Packaging area',2),(14,4,'Control Room','Network monitoring',5),(15,5,'Sales Floor','Open area for customers',1);
/*!40000 ALTER TABLE `zones` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-12 16:26:33
