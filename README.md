# Promotion Management System

A full-stack web application for managing promotions with user authentication, role-based access control, and image upload capabilities. Built with Spring Boot backend and React frontend.

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen)
![React](https://img.shields.io/badge/React-18.2.0-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)

## Features

A secure, full-stack promotion management application with:

- JWT authentication and role-based authorization (ADMIN, USER)
- User management (CRUD) for administrators
- Promotion management (CRUD) with image upload and preview
- RESTful API, validation, and file upload support

## Technology

- Backend: Spring Boot 3.2.0 (Java 17), Spring Security (JWT), Spring Data JPA (Hibernate), Maven
- Frontend: React 18.2.0 (Create React App), Fetch API
- Database: MySQL
- Notable libraries: jjwt, Lombok

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

3. Create your `application.properties` from the provided template and add your credentials and secrets.

```bash
# Linux / macOS
cp promotion-system/src/main/resources/application.properties.template promotion-system/src/main/resources/application.properties

# Windows (PowerShell)
Copy-Item -Path "promotion-system\src\main\resources\application.properties.template" -Destination "promotion-system\src\main\resources\application.properties"
```

Then open `promotion-system/src/main/resources/application.properties` and replace the placeholders:

```properties
spring.datasource.username=YOUR_DB_USERNAME
spring.datasource.password=YOUR_DB_PASSWORD
jwt.secret=REPLACE_WITH_RANDOM_SECRET
```

### Step 3: Backend — Start

Run using the Maven wrapper or your IDE:

```bash
cd promotion-system
# macOS / Linux
./mvnw spring-boot:run
# Windows
mvnw.cmd spring-boot:run
```

The backend will start on `http://localhost:8080`.

### Step 4: Frontend — Start

Install dependencies and start the development server:

```bash
cd frontend
npm install
npm start
```

The frontend will be available at `http://localhost:3000`.

### ✅ VS Code — Full Workspace Setup (recommended)

Follow these steps to set up and run both backend and frontend entirely within Visual Studio Code.

1. Open VS Code and choose **File → Open Folder...** then select the repository root folder (`PM system`).
2. Recommended extensions to install:
   - **Java Extension Pack** (Microsoft) — Java language support and debugger
   - **Spring Boot Extension Pack** (Pivotal/VMware) — Spring Boot support
   - **Maven for Java** — Maven integration
   - **Debugger for Java** — run and debug Spring Boot app
   - **ESLint** — JavaScript linting
   - **Node.js Extension Pack** (optional) — Node debugging
3. Install frontend dependencies (once):

```bash
# In VS Code terminal (select workspace root then):
cd frontend
npm install
```

4. Use the built-in tasks to start services:

   - Run **Terminal → Run Task... → Start Backend** to start the backend (uses `mvnw.cmd spring-boot:run`).
   - Run **Terminal → Run Task... → Start Frontend** to start the frontend (`npm start`).
   - Or run **Start All** to start both at once.

5. Tips & checks:
   - Open **Run and Debug** to add or use a Spring Boot launch configuration if you prefer debugging the backend.
   - Use the integrated terminal to view logs and the Problems panel for errors.
   - Ensure the MySQL database (`promotion_db`) is running and credentials are set in `promotion-system/src/main/resources/application.properties`.

Ports:

- Backend: `http://localhost:8080`
- Frontend: `http://localhost:3000`

This setup keeps everything contained in VS Code and uses the provided tasks for quick startup and consistent behavior across Windows machines.

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

## Testing & Development

- For API testing use Postman or cURL. Key manual tests: authentication, user management (admin), and promotion CRUD with image upload.
- The codebase follows common Spring patterns (controllers, services, repositories) and includes standard security practices (JWT, BCrypt).
