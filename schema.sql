-- ========================================================
-- Vehicle Rental Management System
-- Database Schema for MySQL 8.0+ / 9.0+
-- Database: vehicle_rental
-- ========================================================

CREATE DATABASE IF NOT EXISTS `vehicle_rental`
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `vehicle_rental`;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(15) DEFAULT NULL,
  `address` VARCHAR(255) DEFAULT NULL,
  `role` ENUM('CUSTOMER', 'ADMIN', 'STAFF') DEFAULT 'CUSTOMER',
  `status` ENUM('ACTIVE', 'BLOCKED') DEFAULT 'ACTIVE',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Vehicles Table
CREATE TABLE IF NOT EXISTS `vehicles` (
  `vehicle_id` INT NOT NULL AUTO_INCREMENT,
  `vehicle_number` VARCHAR(20) NOT NULL,
  `brand` VARCHAR(50) NOT NULL,
  `model` VARCHAR(50) NOT NULL,
  `vehicle_type` ENUM('CAR', 'BIKE', 'SCOOTER') NOT NULL,
  `category` VARCHAR(50) DEFAULT NULL,
  `fuel_type` ENUM('PETROL', 'DIESEL', 'ELECTRIC') NOT NULL,
  `transmission` ENUM('MANUAL', 'AUTOMATIC') NOT NULL,
  `seats` INT NOT NULL,
  `price_per_day` DECIMAL(10,2) NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `status` ENUM('AVAILABLE', 'BOOKED', 'RENTED', 'MAINTENANCE') DEFAULT 'AVAILABLE',
  `image_path` VARCHAR(500) DEFAULT NULL,
  `description` TEXT,
  PRIMARY KEY (`vehicle_id`),
  UNIQUE KEY `uq_vehicles_number` (`vehicle_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bookings Table
CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `vehicle_id` INT NOT NULL,
  `pickup_date` DATE NOT NULL,
  `return_date` DATE NOT NULL,
  `pickup_location` VARCHAR(100) NOT NULL,
  `drop_location` VARCHAR(100) DEFAULT NULL,
  `rental_days` INT NOT NULL,
  `price_per_day` DECIMAL(10,2) NOT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `booking_status` ENUM('PENDING', 'CONFIRMED', 'REJECTED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
  `booking_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `idx_bookings_user` (`user_id`),
  KEY `idx_bookings_vehicle` (`vehicle_id`),
  CONSTRAINT `fk_bookings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_bookings_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Payments Table
CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `booking_id` INT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `payment_method` ENUM('UPI', 'CARD', 'CASH') NOT NULL,
  `payment_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `payment_status` ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
  `transaction_reference` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `idx_payments_booking` (`booking_id`),
  CONSTRAINT `fk_payments_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Rental Returns Table
CREATE TABLE IF NOT EXISTS `rental_returns` (
  `return_id` INT NOT NULL AUTO_INCREMENT,
  `booking_id` INT NOT NULL,
  `actual_return_date` DATE NOT NULL,
  `vehicle_condition` VARCHAR(100) DEFAULT NULL,
  `late_days` INT DEFAULT 0,
  `late_fee` DECIMAL(10,2) DEFAULT 0.00,
  `damage_charge` DECIMAL(10,2) DEFAULT 0.00,
  `final_amount` DECIMAL(10,2) NOT NULL,
  `remarks` TEXT,
  `processed_by` INT DEFAULT NULL,
  PRIMARY KEY (`return_id`),
  UNIQUE KEY `uq_rental_returns_booking` (`booking_id`),
  KEY `idx_returns_processed_by` (`processed_by`),
  CONSTRAINT `fk_returns_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_returns_processor` FOREIGN KEY (`processed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Maintenance Table
CREATE TABLE IF NOT EXISTS `maintenance` (
  `maintenance_id` INT NOT NULL AUTO_INCREMENT,
  `vehicle_id` INT NOT NULL,
  `reported_by` INT DEFAULT NULL,
  `problem_description` TEXT NOT NULL,
  `maintenance_date` DATE NOT NULL,
  `completion_date` DATE DEFAULT NULL,
  `cost` DECIMAL(10,2) DEFAULT 0.00,
  `status` ENUM('REPORTED', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'REPORTED',
  `remarks` TEXT,
  PRIMARY KEY (`maintenance_id`),
  KEY `idx_maintenance_vehicle` (`vehicle_id`),
  KEY `idx_maintenance_reported_by` (`reported_by`),
  CONSTRAINT `fk_maintenance_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_maintenance_reporter` FOREIGN KEY (`reported_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Reviews Table
CREATE TABLE IF NOT EXISTS `reviews` (
  `review_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `vehicle_id` INT NOT NULL,
  `booking_id` INT NOT NULL,
  `rating` INT NOT NULL,
  `comment` TEXT,
  `review_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `idx_reviews_user` (`user_id`),
  KEY `idx_reviews_vehicle` (`vehicle_id`),
  KEY `idx_reviews_booking` (`booking_id`),
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_reviews_rating` CHECK (`rating` BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Notifications Table
CREATE TABLE IF NOT EXISTS `notifications` (
  `notification_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `message` VARCHAR(500) NOT NULL,
  `notification_type` VARCHAR(50) DEFAULT NULL,
  `is_read` TINYINT(1) DEFAULT 0,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_notifications_user` (`user_id`),
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
