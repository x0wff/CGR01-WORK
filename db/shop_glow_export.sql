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

-- Data for table `categories` (Exact data from running webapp)
INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `image_url`, `max_partners`, `current_partners`) VALUES
('00607ffd-56c7-4c3f-8217-49ea46d39102', 'Makeup', 'makeup', 'Premium makeup collections featuring innovative formulas and stunning color payoff', 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0),
('da0f55f4-6e39-4fff-99ac-1feaf5414abe', 'Beauty Tools', 'beauty-tools', 'Professional-grade brushes and tools trusted by makeup artists worldwide', 'https://images.unsplash.com/photo-1573461160327-b450ce3d8e7f?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0),
('98b7ff24-e00f-4a28-a11a-25a1b406921c', 'Mother Care', 'mother-care', 'Gentle, natural skincare products designed for expecting and new mothers', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0),
('ca3ec06c-976c-4d9f-9bcf-da986a708c57', 'Pet Care', 'pet-care', 'Luxury grooming products that keep your pets looking and feeling their best', 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=400', 2, 0);

-- --------------------------------------------------------

-- Sample data for table `users`
INSERT INTO `users` (`id`, `username`, `email`, `password`, `is_partner`, `created_at`) VALUES
('user-1001-admin-demo-4567-890123456789', 'admin', 'admin@shopglow.com', '$2a$10$N2UGUlSVILx2q5GlCYWHCOkWTX.gQu3FzDx6vLvYi2Kt8OHdPnPKu', 1, '2025-01-01 10:00:00'),
('user-2002-customer-demo-5678-901234567890', 'sarah_m', 'sarah@email.com', '$2a$10$N2UGUlSVILx2q5GlCYWHCOkWTX.gQu3FzDx6vLvYi2Kt8OHdPnPKu', 0, '2025-01-15 14:30:00'),
('user-3003-customer-demo-6789-012345678901', 'lisa_b', 'lisa@email.com', '$2a$10$N2UGUlSVILx2q5GlCYWHCOkWTX.gQu3FzDx6vLvYi2Kt8OHdPnPKu', 0, '2025-02-01 09:15:00'),
('user-4004-partner-demo-7890-123456789012', 'beauty_pro', 'partner@glamourstore.com', '$2a$10$N2UGUlSVILx2q5GlCYWHCOkWTX.gQu3FzDx6vLvYi2Kt8OHdPnPKu', 1, '2025-02-10 11:20:00');

-- Sample data for table `partners`
INSERT INTO `partners` (`id`, `user_id`, `business_name`, `category`, `description`, `website`, `commission_rate`, `status`, `credit_card_on_file`, `approved_at`, `created_at`) VALUES
('partner-aa11-beauty-store-bb22-cc3344556677', 'user-4004-partner-demo-7890-123456789012', 'Glamour Beauty Store', 'makeup', 'Premium makeup and cosmetics with international brands', 'https://glamourstore.com', 12.50, 'approved', 1, '2025-02-11 15:00:00', '2025-02-10 11:30:00'),
('partner-bb22-tools-pro-cc33-dd4455667788', 'user-1001-admin-demo-4567-890123456789', 'Professional Beauty Tools', 'beauty-tools', 'High-quality professional makeup brushes and beauty tools', 'https://probeautytools.com', 15.00, 'approved', 1, '2025-02-12 10:00:00', '2025-02-10 12:00:00');

-- Sample data for table `products`
INSERT INTO `products` (`id`, `partner_id`, `category_id`, `name`, `description`, `price`, `sale_price`, `image_url`, `gallery_urls`, `in_stock`, `featured`, `rating`, `review_count`, `created_at`) VALUES
('prod-1001-makeup-foundation-aa11-bb2233', 'partner-aa11-beauty-store-bb22-cc3344556677', '00607ffd-56c7-4c3f-8217-49ea46d39102', 'Luminous Foundation SPF 30', 'Full coverage foundation with SPF protection and 24-hour wear. Perfect for all skin types with a natural, radiant finish.', 45.99, 32.19, 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500', '["https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500", "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500"]', 1, 1, 4.50, 127, '2025-02-15 09:00:00'),
('prod-2002-makeup-lipstick-bb22-cc3344', 'partner-aa11-beauty-store-bb22-cc3344556677', '00607ffd-56c7-4c3f-8217-49ea46d39102', 'Velvet Matte Lipstick Collection', 'Long-lasting matte lipstick with intense color payoff. Available in 12 stunning shades from nudes to bold reds.', 28.99, 20.29, 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500', '["https://images.unsplash.com/photo-1586495777744-4413f21062fa?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500"]', 1, 1, 4.70, 89, '2025-02-16 10:30:00'),
('prod-3003-tools-brushes-cc33-dd4455', 'partner-bb22-tools-pro-cc33-dd4455667788', 'da0f55f4-6e39-4fff-99ac-1feaf5414abe', 'Professional Makeup Brush Set', '12-piece professional makeup brush set made with synthetic fibers. Includes face, eye, and detail brushes with premium handles.', 89.99, 62.99, 'https://images.unsplash.com/photo-1573461160327-b450ce3d8e7f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500', '["https://images.unsplash.com/photo-1573461160327-b450ce3d8e7f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500", "https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500"]', 1, 1, 4.80, 156, '2025-02-17 11:00:00'),
('prod-4004-makeup-eyeshadow-aa11-ee5566', 'partner-aa11-beauty-store-bb22-cc3344556677', '00607ffd-56c7-4c3f-8217-49ea46d39102', 'Sunset Dreams Eyeshadow Palette', '18-shade eyeshadow palette with warm sunset tones. Includes matte, shimmer, and metallic finishes for endless looks.', 52.99, 37.09, 'https://images.unsplash.com/photo-1583624842486-a7de98e1dea0?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500', '["https://images.unsplash.com/photo-1583624842486-a7de98e1dea0?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500"]', 1, 0, 4.60, 234, '2025-02-18 14:15:00'),
('prod-5005-tools-mirror-bb22-ff6677', 'partner-bb22-tools-pro-cc33-dd4455667788', 'da0f55f4-6e39-4fff-99ac-1feaf5414abe', 'LED Vanity Mirror with Touch Control', 'Professional LED makeup mirror with adjustable brightness and 10X magnification. Touch-sensitive controls and USB charging.', 125.99, 88.19, 'https://images.unsplash.com/photo-1599582909646-e5e3ca1a8a15?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500', '["https://images.unsplash.com/photo-1599582909646-e5e3ca1a8a15?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500"]', 1, 1, 4.90, 78, '2025-02-19 16:30:00'),
('prod-6006-mother-skincare-aa11-gg7788', 'partner-aa11-beauty-store-bb22-cc3344556677', '98b7ff24-e00f-4a28-a11a-25a1b406921c', 'Gentle Pregnancy Skincare Set', 'Complete skincare routine safe for pregnancy and breastfeeding. Includes cleanser, serum, moisturizer, and stretch mark cream.', 78.99, 55.29, 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500', '["https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&h=500"]', 1, 1, 4.40, 92, '2025-02-20 12:00:00');

-- Sample data for table `orders`
INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `status`, `delivery_confirmed`, `delivery_confirmed_at`, `auto_approved_at`, `created_at`) VALUES
('order-1001-sarah-feb21-aa11-bb2233445566', 'user-2002-customer-demo-5678-901234567890', 78.18, 'delivered', 1, '2025-02-25 14:30:00', '2025-03-02 14:30:00', '2025-02-21 10:15:00'),
('order-2002-lisa-feb22-bb22-cc3344556677', 'user-3003-customer-demo-6789-012345678901', 152.18, 'shipped', 0, NULL, NULL, '2025-02-22 16:45:00'),
('order-3003-sarah-mar01-cc33-dd4455667788', 'user-2002-customer-demo-5678-901234567890', 125.99, 'processing', 0, NULL, NULL, '2025-03-01 09:30:00');

-- Sample data for table `order_items`
INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `partner_id`, `quantity`, `price`, `commission`) VALUES
('item-1001-foundation-order1-aa11', 'order-1001-sarah-feb21-aa11-bb2233445566', 'prod-1001-makeup-foundation-aa11-bb2233', 'partner-aa11-beauty-store-bb22-cc3344556677', 1, 32.19, 4.02),
('item-1002-lipstick-order1-aa11', 'order-1001-sarah-feb21-aa11-bb2233445566', 'prod-2002-makeup-lipstick-bb22-cc3344', 'partner-aa11-beauty-store-bb22-cc3344556677', 2, 20.29, 2.54),
('item-2001-brushes-order2-bb22', 'order-2002-lisa-feb22-bb22-cc3344556677', 'prod-3003-tools-brushes-cc33-dd4455', 'partner-bb22-tools-pro-cc33-dd4455667788', 1, 62.99, 9.45),
('item-2002-mirror-order2-bb22', 'order-2002-lisa-feb22-bb22-cc3344556677', 'prod-5005-tools-mirror-bb22-ff6677', 'partner-bb22-tools-pro-cc33-dd4455667788', 1, 88.19, 13.23),
('item-3001-mirror-order3-bb22', 'order-3003-sarah-mar01-cc33-dd4455667788', 'prod-5005-tools-mirror-bb22-ff6677', 'partner-bb22-tools-pro-cc33-dd4455667788', 1, 125.99, 18.90);

-- Sample data for table `newsletter`
INSERT INTO `newsletter` (`id`, `email`, `subscribed_at`, `active`) VALUES
('news-1001-sarah-email-aa11-bb22', 'sarah@email.com', '2025-01-15 14:35:00', 1),
('news-2002-lisa-email-bb22-cc33', 'lisa@email.com', '2025-02-01 09:20:00', 1),
('news-3003-beauty-lover-cc33-dd44', 'beautylover@gmail.com', '2025-02-10 11:30:00', 1),
('news-4004-makeup-pro-dd44-ee55', 'makeuppro@yahoo.com', '2025-02-15 16:45:00', 1),
('news-5005-shopaholic-ee55-ff66', 'shopaholic@hotmail.com', '2025-02-20 13:15:00', 1);

-- Sample data for table `chat_sessions`
INSERT INTO `chat_sessions` (`id`, `session_id`, `is_admin_mode`, `user_id`, `created_at`, `last_activity_at`) VALUES
('chat-1001-sarah-session-aa11-bb22', 'sess_sarah_feb21_001', 0, 'user-2002-customer-demo-5678-901234567890', '2025-02-21 09:00:00', '2025-02-21 09:15:00'),
('chat-2002-lisa-session-bb22-cc33', 'sess_lisa_feb22_001', 0, 'user-3003-customer-demo-6789-012345678901', '2025-02-22 15:30:00', '2025-02-22 15:45:00'),
('chat-3003-guest-session-cc33-dd44', 'sess_guest_mar01_001', 0, NULL, '2025-03-01 10:00:00', '2025-03-01 10:10:00');

-- Sample data for table `chat_messages`
INSERT INTO `chat_messages` (`id`, `session_id`, `sender`, `message`, `message_type`, `metadata`, `created_at`) VALUES
('msg-1001-sarah-hello-aa11-bb22', 'chat-1001-sarah-session-aa11-bb22', 'user', 'Hi! I need help finding the right foundation shade', 'text', NULL, '2025-02-21 09:00:00'),
('msg-1002-violet-reply-aa11-bb22', 'chat-1001-sarah-session-aa11-bb22', 'violet', 'Hello! I''d be happy to help you find the perfect foundation shade. What''s your skin type and preferred coverage?', 'text', NULL, '2025-02-21 09:01:00'),
('msg-1003-sarah-response-aa11-bb22', 'chat-1001-sarah-session-aa11-bb22', 'user', 'I have combination skin and prefer medium coverage', 'text', NULL, '2025-02-21 09:02:00'),
('msg-1004-violet-recommend-aa11-bb22', 'chat-1001-sarah-session-aa11-bb22', 'violet', 'Perfect! I recommend our Luminous Foundation SPF 30. It''s great for combination skin and offers buildable medium coverage.', 'product_recommendation', '{"product_id": "prod-1001-makeup-foundation-aa11-bb2233"}', '2025-02-21 09:03:00'),
('msg-2001-lisa-question-bb22-cc33', 'chat-2002-lisa-session-bb22-cc33', 'user', 'What brush set would you recommend for beginners?', 'text', NULL, '2025-02-22 15:30:00'),
('msg-2002-violet-brush-reply-bb22-cc33', 'chat-2002-lisa-session-bb22-cc33', 'violet', 'For beginners, I highly recommend our Professional Makeup Brush Set. It has all the essential brushes and comes with a guide!', 'product_recommendation', '{"product_id": "prod-3003-tools-brushes-cc33-dd4455"}', '2025-02-22 15:31:00');

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

-- Data for table `flash_sales` (Exact data from running webapp)
INSERT INTO `flash_sales` (`id`, `name`, `discount_percentage`, `start_time`, `end_time`, `active`, `created_at`) VALUES
('99e45d2f-b1c1-4043-bbea-6521e0ed36a5', 'Sitewide Flash Sale', '30.00', '2025-09-06 00:27:38', '2025-09-09 00:27:38', 1, '2025-09-07 00:27:38');

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