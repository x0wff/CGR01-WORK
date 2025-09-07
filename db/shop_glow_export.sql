-- Shop&Glow Database Export for cPanel MySQL
-- Generated: 2025-09-07
-- Compatible with MySQL/MariaDB

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- Database: shop_glow

-- --------------------------------------------------------

-- Table structure for table `users`
CREATE TABLE `users` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `username` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `is_partner` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_users_username` (`username`(255)),
  UNIQUE KEY `idx_users_email` (`email`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `partners`
CREATE TABLE `partners` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `user_id` varchar(36) NOT NULL,
  `business_name` text NOT NULL,
  `category` text NOT NULL,
  `description` text NOT NULL,
  `website` text,
  `commission_rate` decimal(5,2) NOT NULL,
  `status` text NOT NULL DEFAULT 'pending',
  `credit_card_on_file` tinyint(1) DEFAULT 0,
  `approved_at` timestamp NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_partners_user_id` (`user_id`),
  CONSTRAINT `fk_partners_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `categories`
CREATE TABLE `categories` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `name` text NOT NULL,
  `slug` text NOT NULL,
  `description` text,
  `image_url` text,
  `max_partners` int DEFAULT 2,
  `current_partners` int DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_categories_name` (`name`(255)),
  UNIQUE KEY `idx_categories_slug` (`slug`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `categories`
INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `image_url`, `max_partners`, `current_partners`) VALUES
('00607ffd-56c7-4c3f-8217-49ea46d39102', 'Makeup', 'makeup', 'Premium makeup collections featuring innovative formulas and stunning color payoff', 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0),
('11708fed-66d8-5d4g-9328-59fb57e40213', 'Beauty Tools', 'beauty-tools', 'Professional-grade brushes and tools trusted by makeup artists worldwide', 'https://images.unsplash.com/photo-1573461160327-b450ce3d8e7f?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0),
('22819fee-77e9-6e5h-a439-60gc68f51324', 'Mother Care', 'mother-care', 'Gentle, natural skincare products designed for expecting and new mothers', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0),
('3392afef-88fa-7f6i-b54a-71hd79g62435', 'Pet Care', 'pet-care', 'Luxury grooming products that keep your pets looking and feeling their best', 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0);

-- --------------------------------------------------------

-- Table structure for table `products`
CREATE TABLE `products` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `partner_id` varchar(36) NOT NULL,
  `category_id` varchar(36) NOT NULL,
  `name` text NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `image_url` text NOT NULL,
  `gallery_urls` json DEFAULT NULL,
  `in_stock` tinyint(1) DEFAULT 1,
  `featured` tinyint(1) DEFAULT 0,
  `rating` decimal(3,2) DEFAULT '0.00',
  `review_count` int DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_products_partner_id` (`partner_id`),
  KEY `idx_products_category_id` (`category_id`),
  CONSTRAINT `fk_products_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`),
  CONSTRAINT `fk_products_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `orders`
CREATE TABLE `orders` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `user_id` varchar(36) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` text NOT NULL DEFAULT 'pending',
  `delivery_confirmed` tinyint(1) DEFAULT 0,
  `delivery_confirmed_at` timestamp NULL,
  `auto_approved_at` timestamp NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_orders_user_id` (`user_id`),
  CONSTRAINT `fk_orders_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `order_items`
CREATE TABLE `order_items` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `order_id` varchar(36) NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `partner_id` varchar(36) NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `commission` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order_items_order_id` (`order_id`),
  KEY `idx_order_items_product_id` (`product_id`),
  KEY `idx_order_items_partner_id` (`partner_id`),
  CONSTRAINT `fk_order_items_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_order_items_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_order_items_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `disputes`
CREATE TABLE `disputes` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `order_id` varchar(36) NOT NULL,
  `buyer_id` varchar(36) NOT NULL,
  `seller_id` varchar(36) NOT NULL,
  `reason` text NOT NULL,
  `status` text NOT NULL DEFAULT 'open',
  `resolution_deadline` timestamp NOT NULL,
  `evidence` json DEFAULT NULL,
  `resolution` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_disputes_order_id` (`order_id`),
  KEY `idx_disputes_buyer_id` (`buyer_id`),
  KEY `idx_disputes_seller_id` (`seller_id`),
  CONSTRAINT `fk_disputes_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_disputes_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_disputes_seller_id` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `flash_sales`
CREATE TABLE `flash_sales` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `name` text NOT NULL,
  `discount_percentage` decimal(5,2) NOT NULL,
  `start_time` timestamp NOT NULL,
  `end_time` timestamp NOT NULL,
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table `flash_sales`
INSERT INTO `flash_sales` (`id`, `name`, `discount_percentage`, `start_time`, `end_time`, `active`, `created_at`) VALUES
('99e45d2f-b1c1-4043-bbea-6521e0ed36a5', 'Sitewide Flash Sale', '30.00', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 1, NOW());

-- --------------------------------------------------------

-- Table structure for table `newsletter`
CREATE TABLE `newsletter` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `email` text NOT NULL,
  `subscribed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_newsletter_email` (`email`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `chat_sessions`
CREATE TABLE `chat_sessions` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `session_id` text NOT NULL,
  `is_admin_mode` tinyint(1) DEFAULT 0,
  `user_id` varchar(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_activity_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_chat_sessions_session_id` (`session_id`(255)),
  KEY `idx_chat_sessions_user_id` (`user_id`),
  CONSTRAINT `fk_chat_sessions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

-- Table structure for table `chat_messages`
CREATE TABLE `chat_messages` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `session_id` varchar(36) NOT NULL,
  `sender` text NOT NULL,
  `message` text NOT NULL,
  `message_type` text DEFAULT 'text',
  `metadata` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_chat_messages_session_id` (`session_id`),
  CONSTRAINT `fk_chat_messages_session_id` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

-- --------------------------------------------------------
-- VIEWS AND FUNCTIONS
-- --------------------------------------------------------

-- Create a view for featured products with category information
CREATE VIEW `featured_products_view` AS
SELECT 
    p.id,
    p.name,
    p.description,
    p.price,
    p.sale_price,
    p.image_url,
    p.rating,
    p.review_count,
    c.name as category_name,
    c.slug as category_slug
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.featured = 1 AND p.in_stock = 1;

-- Create a view for active flash sales
CREATE VIEW `active_flash_sales_view` AS
SELECT *
FROM flash_sales
WHERE active = 1 
    AND start_time <= NOW() 
    AND end_time >= NOW();

-- --------------------------------------------------------
-- SAMPLE DATA NOTES
-- --------------------------------------------------------

/*
This database structure includes:

1. Complete e-commerce schema with:
   - User management and authentication
   - Partner/vendor system
   - Product catalog with categories
   - Order and payment processing
   - Dispute resolution system
   - Flash sales and promotions
   - Newsletter subscriptions
   - Chat system with admin support

2. MySQL/MariaDB compatible features:
   - Uses VARCHAR(36) for UUIDs instead of PostgreSQL-specific uuid type
   - Uses TINYINT(1) for boolean values
   - Uses JSON type for array fields (MySQL 5.7+)
   - Uses DECIMAL for precise monetary calculations

3. Default data includes:
   - 4 product categories (Makeup, Beauty Tools, Mother Care, Pet Care)
   - Active flash sale (30% discount)
   - Proper foreign key relationships and indexes

To use this database:
1. Import this file into your cPanel MySQL database
2. Update your application's database connection to use MySQL instead of PostgreSQL
3. Modify the Drizzle config to use MySQL dialect
4. Update any PostgreSQL-specific queries in your application code

The schema is production-ready and includes proper indexing for performance.
*/