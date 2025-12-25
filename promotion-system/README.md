# Promotion Management System

A full-stack Promotion Management System built with Spring Boot and MySQL, featuring JWT-based authentication, role-based access control, and file upload capabilities.

## Features

- **Authentication & Authorization**
  - JWT token-based authentication
  - Role-based access control (ADMIN, USER)
  - Secure password encryption using BCrypt

- **User Management (Admin Only)**
  - Create, view, edit, and delete user accounts
  - Admin can manage all user accounts

- **Promotion Management**
  - Create, view, edit, and delete promotions
  - Upload promotion banner images
  - Track promotion start and end dates

## Technology Stack

- **Backend**: Spring Boot 3.2.0
- **Java**: 17
- **Database**: MySQL 8.0
- **Security**: Spring Security with JWT
- **ORM**: Spring Data JPA (Hibernate)
- **Build Tool**: Maven
- **Libraries**: 
  - JWT (jjwt 0.11.5)
  - Lombok
  - Validation

## Prerequisites

- Java 17 or later
- Maven 3.6+
- MySQL 8.0 or later

## Database Setup

1. Create a MySQL database:
```sql
CREATE DATABASE promotion_db;
```

2. Update database credentials in `src/main/resources/application.properties` if needed:
```properties
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
```

## Installation & Setup

1. **Clone the repository** (or extract the project)

2. **Navigate to the project directory**:
```bash
cd promotion-system
```

3. **Build the project**:
```bash
mvn clean install
```

4. **Run the application**:
```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

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

## API Documentation

### Base URL
```
http://localhost:8080
```

### Authentication

#### Login
**POST** `/api/auth/login`

Request Body:
```json
{
  "username": "admin",
  "password": "admin123"
}
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "admin",
  "email": "admin@promotionsystem.com",
  "role": "ADMIN"
}
```

**Note**: Include the token in subsequent requests in the Authorization header:
```
Authorization: Bearer <token>
```

### User Management (Admin Only)

#### Create User
**POST** `/api/admin/users`

Headers: `Authorization: Bearer <token>`

Request Body:
```json
{
  "username": "newuser",
  "password": "password123",
  "email": "newuser@example.com",
  "role": "USER"
}
```

#### Get All Users
**GET** `/api/admin/users`

Headers: `Authorization: Bearer <token>`

#### Get User by ID
**GET** `/api/admin/users/{id}`

Headers: `Authorization: Bearer <token>`

#### Update User
**PUT** `/api/admin/users/{id}`

Headers: `Authorization: Bearer <token>`

Request Body:
```json
{
  "username": "updateduser",
  "password": "newpassword123",
  "email": "updated@example.com",
  "role": "USER"
}
```

#### Delete User
**DELETE** `/api/admin/users/{id}`

Headers: `Authorization: Bearer <token>`

### Promotion Management

#### Create Promotion
**POST** `/api/promotions`

Headers: `Authorization: Bearer <token>`

Request: `multipart/form-data`
- `promotion`: JSON string
  ```json
  {
    "name": "Summer Sale",
    "startDate": "2024-06-01",
    "endDate": "2024-08-31"
  }
  ```
- `file`: (optional) Image file (max 10MB)

#### Get All Promotions
**GET** `/api/promotions`

Headers: `Authorization: Bearer <token>`

#### Get Promotion by ID
**GET** `/api/promotions/{id}`

Headers: `Authorization: Bearer <token>`

#### Update Promotion
**PUT** `/api/promotions/{id}`

Headers: `Authorization: Bearer <token>`

Request: `multipart/form-data`
- `promotion`: JSON string
- `file`: (optional) New image file

#### Delete Promotion
**DELETE** `/api/promotions/{id}`

Headers: `Authorization: Bearer <token>`

### File Access

Uploaded banner images are accessible at:
```
http://localhost:8080/uploads/{filename}
```

The filename is stored in the `bannerImagePath` field of the promotion object.

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
│   │   │       ├── repository/      # Spring Data JPA repositories
│   │   │       └── service/         # Business logic
│   │   └── resources/
│   │       └── application.properties
│   └── test/
└── pom.xml
```

## Configuration

Key configuration in `application.properties`:

- **Server Port**: 8080
- **Database**: MySQL (promotion_db)
- **JWT Secret**: Configured in application.properties
- **JWT Expiration**: 24 hours (86400000 ms)
- **File Upload**: Max 10MB, stored in `uploads/banners/`
- **JPA**: Auto-create/update database schema

## Security

- All endpoints except `/api/auth/login` require authentication
- Admin endpoints (`/api/admin/**`) require ADMIN role
- JWT tokens expire after 24 hours
- Passwords are encrypted using BCrypt
- CORS enabled for frontend integration (localhost:3000, localhost:5173)

## Frontend Integration

This backend API can be integrated with:
- React (recommended for React apps on port 3000)
- Vue.js (recommended for Vite apps on port 5173)

Example fetch request with JWT:
```javascript
fetch('http://localhost:8080/api/promotions', {
  method: 'GET',
  headers: {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json'
  }
})
```

## Testing the API

You can use tools like:
- Postman
- cURL
- Any REST client

Example cURL for login:
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

Example cURL for getting promotions (with token):
```bash
curl -X GET http://localhost:8080/api/promotions \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Troubleshooting

1. **Database Connection Error**: Ensure MySQL is running and credentials are correct
2. **Port Already in Use**: Change `server.port` in application.properties
3. **File Upload Issues**: Ensure the uploads directory has write permissions
4. **Authentication Fails**: Check that the user exists and password is correct

## License

This project is developed as an assignment submission.

## Author

Promotion Management System - Spring Boot Implementation

