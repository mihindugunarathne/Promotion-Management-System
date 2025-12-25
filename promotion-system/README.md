# Promotion Management System - Backend

Spring Boot backend for the Promotion Management System.

## Technology Stack

- **Backend**: Spring Boot 3.2.0
- **Java**: 17
- **Database**: MySQL 8.0
- **Security**: Spring Security with JWT
- **ORM**: Spring Data JPA (Hibernate)
- **Build Tool**: Maven

## Prerequisites

- Java 17 or later
- Maven 3.6+
- MySQL 8.0 or later
- IntelliJ IDEA (recommended) or any Java IDE

## Database Setup

1. Create a MySQL database:
```sql
CREATE DATABASE promotion_db;
```

2. Update database credentials in `src/main/resources/application.properties`:
```properties
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
```

## Running the Application

### Option 1: Using IntelliJ IDEA

1. Open IntelliJ IDEA
2. File → Open → Select the `promotion-system` folder
3. Wait for Maven to download dependencies
4. Run `PromotionSystemApplication.java` (right-click → Run)
5. Application will start on `http://localhost:8080`

### Option 2: Using Maven Command Line

```bash
cd promotion-system
mvn spring-boot:run
```

### Option 3: Using Maven Wrapper

```bash
cd promotion-system
./mvnw spring-boot:run
```

## Default Credentials

The following users are automatically created when the application starts:

### Admin User
- **Username**: `admin`
- **Password**: `admin123`
- **Email**: `admin@promotionsystem.com`
- **Role**: ADMIN

### Regular User
- **Username**: `user`
- **Password**: `user123`
- **Email**: `user@promotionsystem.com`
- **Role**: USER

## API Endpoints

### Base URL
```
http://localhost:8080/api
```

### Authentication
- **POST** `/api/auth/login` - Login and get JWT token

### User Management (Admin Only)
- **GET** `/api/admin/users` - Get all users
- **POST** `/api/admin/users` - Create user
- **GET** `/api/admin/users/{id}` - Get user by ID
- **PUT** `/api/admin/users/{id}` - Update user
- **DELETE** `/api/admin/users/{id}` - Delete user

### Promotion Management
- **GET** `/api/promotions` - Get all promotions
- **POST** `/api/promotions` - Create promotion (multipart/form-data)
- **GET** `/api/promotions/{id}` - Get promotion by ID
- **PUT** `/api/promotions/{id}` - Update promotion
- **DELETE** `/api/promotions/{id}` - Delete promotion

### File Access
- **GET** `/uploads/{filename}` - Access uploaded banner images

## API Request Examples

### Login
```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

### Create Promotion (with file upload)
```bash
POST http://localhost:8080/api/promotions
Authorization: Bearer <token>
Content-Type: multipart/form-data

promotion: {
  "name": "Summer Sale",
  "startDate": "2024-06-01",
  "endDate": "2024-08-31"
}
file: [image file]
```

## Configuration

Key configuration in `application.properties`:

- **Server Port**: 8080
- **Database**: MySQL (promotion_db)
- **JWT Secret**: Configured in application.properties
- **JWT Expiration**: 24 hours (86400000 ms)
- **File Upload**: Max 10MB, stored in `uploads/banners/`
- **JPA**: Auto-create/update database schema
- **CORS**: Enabled for `http://localhost:3000` (React frontend)

## Project Structure

```
promotion-system/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/promotion_system/
│   │   │       ├── config/          # Security, JWT, Web config
│   │   │       ├── controller/      # REST controllers
│   │   │       ├── dto/             # Data Transfer Objects
│   │   │       ├── entity/          # JPA entities
│   │   │       ├── repository/     # Spring Data JPA repositories
│   │   │       └── service/         # Business logic
│   │   └── resources/
│   │       └── application.properties
│   └── test/
└── pom.xml
```

## Building the Project

```bash
mvn clean install
```

## Troubleshooting

1. **Database Connection Error**: Ensure MySQL is running and credentials are correct
2. **Port Already in Use**: Change `server.port` in application.properties
3. **File Upload Issues**: Ensure the uploads directory has write permissions
4. **CORS Errors**: Make sure frontend is running on `http://localhost:3000`

## Frontend Integration

The backend is configured to work with the React frontend running on `http://localhost:3000`.

To start the frontend separately:
```bash
cd ../frontend
npm install
npm start
```

## License

This project is developed as an assignment submission.
