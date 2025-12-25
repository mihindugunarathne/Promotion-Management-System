# Promotion Management System

A full-stack web application for managing promotions with user authentication, role-based access control, and image upload capabilities. Built with Spring Boot backend and React frontend.

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen)
![React](https://img.shields.io/badge/React-18.2.0-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)


## ✨ Features

### Authentication & Authorization

- ✅ JWT token-based authentication
- ✅ Role-based access control (ADMIN, USER)
- ✅ Secure password encryption using BCrypt
- ✅ Session management

### User Management (Admin Only)

- ✅ Create new user accounts
- ✅ View all users
- ✅ Edit user information
- ✅ Delete user accounts
- ✅ User role and status management

### Promotion Management

- ✅ Create promotions with:
  - Name
  - Start Date
  - End Date
  - Banner Image Upload
- ✅ View all promotions
- ✅ Edit existing promotions
- ✅ Delete promotions
- ✅ Image preview and display

### Additional Features

- ✅ Responsive design
- ✅ Modern UI with CSS
- ✅ File upload with validation
- ✅ Date validation
- ✅ Error handling
- ✅ RESTful API design

## 🛠 Technology Stack

### Backend

- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Database**: MySQL 8.0
- **Security**: Spring Security with JWT
- **ORM**: Spring Data JPA (Hibernate)
- **Build Tool**: Maven
- **Libraries**:
  - JWT (jjwt 0.11.5)
  - Lombok
  - Validation

### Frontend

- **Framework**: React 18.2.0
- **Routing**: React Router DOM 6.20.0
- **Styling**: CSS3 (No frameworks)
- **Build Tool**: Create React App
- **HTTP Client**: Fetch API

## 📁 Project Structure

```
PM system/
├── promotion-system/          # Backend (Spring Boot)
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/example/promotion_system/
│   │   │   │       ├── config/          # Security, JWT, Web config
│   │   │   │       ├── controller/       # REST controllers
│   │   │   │       ├── dto/             # Data Transfer Objects
│   │   │   │       ├── entity/          # JPA entities
│   │   │   │       ├── repository/      # Spring Data JPA repositories
│   │   │   │       └── service/         # Business logic
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/                        # Test files
│   ├── pom.xml                          # Maven configuration
│   └── README.md                        # Backend documentation
│
└── frontend/                            # Frontend (React)
    ├── public/
    │   └── index.html
    ├── src/
    │   ├── components/                  # React components
    │   ├── services/                     # API services
    │   ├── App.js
    │   └── index.js
    ├── package.json                      # NPM configuration
    └── README.md                         # Frontend documentation
```

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Java 17** or later
- **Node.js 14** or later
- **MySQL 8.0** or later
- **Maven 3.6+** (or use Maven wrapper included)
- **Git** (for cloning the repository)


## 🚀 Installation & Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/mihindugunarathne/Promotion-Management-System.git
cd Promotion-Management-System
```

### Step 2: Database Setup

1. Start MySQL server
2. Create the database:

```sql
CREATE DATABASE promotion_db;
```

3. Update database credentials in `promotion-system/src/main/resources/application.properties`:

```properties
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD_HERE
```

### Step 3: Backend Setup

#### Option A: Using IntelliJ IDEA

1. Open IntelliJ IDEA
2. File → Open → Select `promotion-system` folder
3. Wait for Maven to sync dependencies
4. Run `PromotionSystemApplication.java`

#### Option B: Using Command Line

```bash
cd promotion-system
./mvnw spring-boot:run
# Or on Windows:
mvnw.cmd spring-boot:run
```

The backend will start on `http://localhost:8080`

### Step 4: Frontend Setup

#### Option A: Using VSCode

1. Open VSCode
2. File → Open Folder → Select `frontend` folder
3. Open terminal (Ctrl + `)
4. Run:

```bash
npm install
npm start
```

#### Option B: Using Command Line

```bash
cd frontend
npm install
npm start
```

The frontend will start on `http://localhost:3000`

## 🎮 Running the Application

### Running Both Services

**Terminal 1 (Backend):**

```bash
cd promotion-system
./mvnw spring-boot:run
```

**Terminal 2 (Frontend):**

```bash
cd frontend
npm start
```

## 🔐 Default Credentials

The following users are automatically created when the backend starts:

### Admin User

- **Username**: `admin`
- **Password**: `admin123`
- **Role**: ADMIN
- **Access**: Full access to all features including user management

### Regular User

- **Username**: `user`
- **Password**: `user123`
- **Role**: USER
- **Access**: Promotion management only

## 📡 API Documentation

### Base URL

```
http://localhost:8080/api
```

### Authentication

#### Login

```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

**Response:**

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

**Note**: Include the token in subsequent requests:

```
Authorization: Bearer <token>
```

### User Management (Admin Only)

| Method | Endpoint                | Description    |
| ------ | ----------------------- | -------------- |
| GET    | `/api/admin/users`      | Get all users  |
| POST   | `/api/admin/users`      | Create user    |
| GET    | `/api/admin/users/{id}` | Get user by ID |
| PUT    | `/api/admin/users/{id}` | Update user    |
| DELETE | `/api/admin/users/{id}` | Delete user    |

**Example - Create User:**

```http
POST /api/admin/users
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "username": "newuser",
  "password": "password123",
  "email": "user@example.com",
  "role": "USER"
}
```

### Promotion Management

| Method | Endpoint               | Description         |
| ------ | ---------------------- | ------------------- |
| GET    | `/api/promotions`      | Get all promotions  |
| POST   | `/api/promotions`      | Create promotion    |
| GET    | `/api/promotions/{id}` | Get promotion by ID |
| PUT    | `/api/promotions/{id}` | Update promotion    |
| DELETE | `/api/promotions/{id}` | Delete promotion    |

**Example - Create Promotion (with file upload):**

```http
POST /api/promotions
Authorization: Bearer <token>
Content-Type: multipart/form-data

promotion: {
  "name": "Summer Sale 2024",
  "startDate": "2024-06-01",
  "endDate": "2024-08-31"
}
file: [image file]
```

### File Access

```http
GET /uploads/{filename}
```
Access uploaded banner images directly via URL.


## 🧪 Testing

### Manual Testing

1. Login with admin credentials
2. Test user management (create, edit, delete)
3. Test promotion management (create with image, edit, delete)
4. Login with user credentials
5. Verify user cannot access admin endpoints

### API Testing

Use tools like:

- Postman
- cURL
- Browser DevTools

## 📝 Development Notes

### Design Patterns Used

- **Repository Pattern**: Spring Data JPA repositories
- **Service Layer Pattern**: Business logic separation
- **DTO Pattern**: Data transfer objects
- **Singleton Pattern**: Spring beans

### Security Features

- JWT token expiration (24 hours)
- Password encryption (BCrypt)
- Role-based access control
- CORS configuration
- Input validation

