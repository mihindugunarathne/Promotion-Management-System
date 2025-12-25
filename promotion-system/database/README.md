# Database Setup

This folder contains the database schema and setup scripts for the Promotion Management System.

## Files

- `promotion_db.sql` - Complete database schema with default users

## Quick Setup

### Option 1: Using MySQL Command Line

```bash
mysql -u root -p < promotion_db.sql
```

### Option 2: Using MySQL Workbench

1. Open MySQL Workbench
2. File → Open SQL Script
3. Select `promotion_db.sql`
4. Execute the script (⚡ button)

### Option 3: Using IntelliJ IDEA Database Tool

1. Open Database tool window
2. Right-click on your MySQL connection
3. Select "Run SQL Script"
4. Choose `promotion_db.sql`

## What's Included

### Database Schema
- `users` table - User accounts with roles
- `promotions` table - Promotion data with banner images

### Default Users
- **Admin**: username=`admin`, password=`admin123`
- **User**: username=`user`, password=`user123`

**Note**: Passwords are stored as BCrypt hashes for security.

## Alternative: Using JPA Auto-Create

If you prefer, you can let Spring Boot create the tables automatically:

1. Ensure `spring.jpa.hibernate.ddl-auto=update` in `application.properties`
2. Start the application
3. Tables will be created automatically
4. Default users will be created by `DataInitializer.java`

## Verification

After running the SQL script, verify:

```sql
USE promotion_db;
SHOW TABLES;
SELECT * FROM users;
```

You should see:
- 2 tables: `users` and `promotions`
- 2 users: `admin` and `user`

