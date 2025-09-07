import mysql from 'mysql2/promise';
import { randomUUID } from 'crypto';
import { type User, type InsertUser, type Partner, type InsertPartner, type Category, type Product, type InsertProduct, type Order, type InsertOrder, type OrderItem, type Dispute, type FlashSale, type Newsletter, type InsertNewsletter, type ChatSession, type InsertChatSession, type ChatMessage, type InsertChatMessage } from "@shared/schema";
import { IStorage } from './storage';

const pool = mysql.createPool({
  host: "localhost",                // cPanel DB host
  user: "shopilrh_CGR01u",          // cPanel DB user
  password: "JOXXj4CwhHlr",         // cPanel DB password
  database: "shopilrh_CGR01",       // cPanel DB name
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

export class MySQLStorage implements IStorage {
  // Users
  async getUser(id: string): Promise<User | undefined> {
    const [rows] = await pool.execute('SELECT * FROM users WHERE id = ?', [id]);
    const users = rows as User[];
    return users[0];
  }

  async getUserByEmail(email: string): Promise<User | undefined> {
    const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [email]);
    const users = rows as User[];
    return users[0];
  }

  async createUser(user: InsertUser): Promise<User> {
    const id = randomUUID();
    await pool.execute(
      'INSERT INTO users (id, username, email, password, is_partner, created_at) VALUES (?, ?, ?, ?, ?, NOW())',
      [id, user.username, user.email, user.password, user.isPartner || false]
    );
    return { ...user, id, isPartner: user.isPartner || false, createdAt: new Date() };
  }

  // Partners
  async getPartner(id: string): Promise<Partner | undefined> {
    const [rows] = await pool.execute('SELECT * FROM partners WHERE id = ?', [id]);
    const partners = rows as Partner[];
    return partners[0];
  }

  async getPartnersByCategory(category: string): Promise<Partner[]> {
    const [rows] = await pool.execute('SELECT * FROM partners WHERE category = ? AND status = "approved"', [category]);
    return rows as Partner[];
  }

  async createPartner(partner: InsertPartner): Promise<Partner> {
    const id = randomUUID();
    await pool.execute(
      'INSERT INTO partners (id, user_id, business_name, category, description, website, commission_rate, status, credit_card_on_file, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, "pending", 0, NOW())',
      [id, partner.userId, partner.businessName, partner.category, partner.description, partner.website || null, partner.commissionRate]
    );
    return { 
      ...partner, 
      id, 
      website: partner.website || null,
      status: "pending", 
      creditCardOnFile: false, 
      approvedAt: null, 
      createdAt: new Date() 
    };
  }

  async approvePartner(id: string): Promise<Partner | undefined> {
    await pool.execute('UPDATE partners SET status = "approved", approved_at = NOW() WHERE id = ?', [id]);
    return this.getPartner(id);
  }

  // Categories
  async getCategories(): Promise<Category[]> {
    const [rows] = await pool.execute('SELECT * FROM categories');
    return rows as Category[];
  }

  async getCategory(id: string): Promise<Category | undefined> {
    const [rows] = await pool.execute('SELECT * FROM categories WHERE id = ?', [id]);
    const categories = rows as Category[];
    return categories[0];
  }

  async getCategoryBySlug(slug: string): Promise<Category | undefined> {
    const [rows] = await pool.execute('SELECT * FROM categories WHERE slug = ?', [slug]);
    const categories = rows as Category[];
    return categories[0];
  }

  // Products
  async getProducts(limit = 20, category?: string, featured?: boolean): Promise<Product[]> {
    let query = 'SELECT p.* FROM products p';
    const params: any[] = [];

    if (category) {
      query += ' JOIN categories c ON p.category_id = c.id WHERE c.slug = ?';
      params.push(category);
    }

    if (featured !== undefined) {
      query += category ? ' AND' : ' WHERE';
      query += ' p.featured = ?';
      params.push(featured);
    }

    query += ' LIMIT ?';
    params.push(limit);

    const [rows] = await pool.execute(query, params);
    return rows as Product[];
  }

  async getProduct(id: string): Promise<Product | undefined> {
    const [rows] = await pool.execute('SELECT * FROM products WHERE id = ?', [id]);
    const products = rows as Product[];
    return products[0];
  }

  async getProductsByPartner(partnerId: string): Promise<Product[]> {
    const [rows] = await pool.execute('SELECT * FROM products WHERE partner_id = ?', [partnerId]);
    return rows as Product[];
  }

  async createProduct(product: InsertProduct): Promise<Product> {
    const id = randomUUID();
    await pool.execute(
      'INSERT INTO products (id, partner_id, category_id, name, description, price, sale_price, image_url, gallery_urls, in_stock, featured, rating, review_count, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "0.00", 0, NOW())',
      [
        id, product.partnerId, product.categoryId, product.name, product.description,
        product.price, product.salePrice || null, product.imageUrl,
        product.galleryUrls ? JSON.stringify(product.galleryUrls) : null,
        product.inStock !== undefined ? product.inStock : true,
        product.featured || false
      ]
    );
    return { 
      ...product, 
      id,
      salePrice: product.salePrice || null,
      galleryUrls: product.galleryUrls || null,
      inStock: product.inStock !== undefined ? product.inStock : null,
      featured: product.featured || null,
      rating: "0.00", 
      reviewCount: 0, 
      createdAt: new Date() 
    };
  }

  // Orders
  async getOrder(id: string): Promise<Order | undefined> {
    const [rows] = await pool.execute('SELECT * FROM orders WHERE id = ?', [id]);
    const orders = rows as Order[];
    return orders[0];
  }

  async getUserOrders(userId: string): Promise<Order[]> {
    const [rows] = await pool.execute('SELECT * FROM orders WHERE user_id = ?', [userId]);
    return rows as Order[];
  }

  async createOrder(order: InsertOrder): Promise<Order> {
    const id = randomUUID();
    await pool.execute(
      'INSERT INTO orders (id, user_id, total_amount, status, delivery_confirmed, created_at) VALUES (?, ?, ?, "pending", 0, NOW())',
      [id, order.userId, order.totalAmount]
    );
    return { 
      ...order, 
      id, 
      status: "pending", 
      deliveryConfirmed: false, 
      deliveryConfirmedAt: null, 
      autoApprovedAt: null, 
      createdAt: new Date() 
    };
  }

  // Newsletter
  async subscribeNewsletter(newsletter: InsertNewsletter): Promise<Newsletter> {
    const id = randomUUID();
    await pool.execute(
      'INSERT INTO newsletter (id, email, subscribed_at, active) VALUES (?, ?, NOW(), 1)',
      [id, newsletter.email]
    );
    return { ...newsletter, id, subscribedAt: new Date(), active: true };
  }

  // Flash Sales
  async getActiveFlashSale(): Promise<FlashSale | undefined> {
    const [rows] = await pool.execute('SELECT * FROM flash_sales WHERE active = 1 AND start_time <= NOW() AND end_time >= NOW() LIMIT 1');
    const flashSales = rows as FlashSale[];
    return flashSales[0];
  }

  // Chat
  async createChatSession(session: InsertChatSession): Promise<ChatSession> {
    const id = randomUUID();
    await pool.execute(
      'INSERT INTO chat_sessions (id, session_id, is_admin_mode, user_id, created_at, last_activity_at) VALUES (?, ?, ?, ?, NOW(), NOW())',
      [id, session.sessionId, session.isAdminMode || false, session.userId || null]
    );
    return {
      ...session,
      id,
      userId: session.userId || null,
      isAdminMode: session.isAdminMode || false,
      createdAt: new Date(),
      lastActivityAt: new Date()
    };
  }

  async getChatSession(sessionId: string): Promise<ChatSession | undefined> {
    const [rows] = await pool.execute('SELECT * FROM chat_sessions WHERE session_id = ?', [sessionId]);
    const sessions = rows as ChatSession[];
    return sessions[0];
  }

  async updateChatSessionAdminMode(sessionId: string, isAdminMode: boolean): Promise<void> {
    await pool.execute('UPDATE chat_sessions SET is_admin_mode = ?, last_activity_at = NOW() WHERE session_id = ?', [isAdminMode, sessionId]);
  }

  async createChatMessage(message: InsertChatMessage): Promise<ChatMessage> {
    const id = randomUUID();
    await pool.execute(
      'INSERT INTO chat_messages (id, session_id, sender, message, message_type, metadata, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())',
      [id, message.sessionId, message.sender, message.message, message.messageType || 'text', message.metadata || null]
    );
    
    // Update session activity
    await this.updateChatSessionActivity(message.sessionId);
    
    return {
      ...message,
      id,
      messageType: message.messageType || 'text',
      metadata: message.metadata || null,
      createdAt: new Date()
    };
  }

  async getChatMessages(sessionId: string, limit: number = 50): Promise<ChatMessage[]> {
    const [rows] = await pool.execute(
      'SELECT * FROM chat_messages WHERE session_id = ? ORDER BY created_at ASC LIMIT ?',
      [sessionId, limit]
    );
    return rows as ChatMessage[];
  }

  async updateChatSessionActivity(sessionId: string): Promise<void> {
    await pool.execute('UPDATE chat_sessions SET last_activity_at = NOW() WHERE id = ?', [sessionId]);
  }
}

export const mysqlStorage = new MySQLStorage();
export { pool };