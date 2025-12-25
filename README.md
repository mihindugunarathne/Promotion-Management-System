# Promotion Management System

Full-stack Promotion Management System with Spring Boot backend and React frontend.

## Project Structure

```
PM system/
├── promotion-system/     # Backend (Spring Boot)
│   ├── src/             # Java source code
│   ├── pom.xml          # Maven configuration
│   └── README.md        # Backend documentation
└── frontend/            # Frontend (React)
    ├── src/             # React source code
    ├── package.json     # NPM configuration
    └── README.md        # Frontend documentation
```

## Quick Start

### Option 1: Run Everything in VSCode (Recommended)

1. Open VSCode
2. File → Open Folder → Select `PM system` folder (root)
3. Install extensions:
   - Extension Pack for Java (Microsoft)
   - Spring Boot Extension Pack (VMware)
4. Open terminal (Ctrl + `)
5. **Terminal 1** - Start Backend:
   ```bash
   cd promotion-system
   ./mvnw spring-boot:run
   ```
6. **Terminal 2** - Start Frontend:
   ```bash
   cd frontend
   npm install  # First time only
   npm start
   ```

Or use VSCode Tasks: `Ctrl + Shift + P` → `Tasks: Run Task` → `Start All`

See `VSCODE_SETUP.md` for detailed VSCode setup instructions.

### Option 2: Separate IDEs

**Backend in IntelliJ IDEA:**

1. Open IntelliJ IDEA
2. File → Open → Select `promotion-system` folder
3. Run `PromotionSystemApplication.java`
4. Backend runs on `http://localhost:8080`

**Frontend in VSCode:**

1. Open VSCode
2. File → Open Folder → Select `frontend` folder
3. Terminal: `npm install` then `npm start`
4. Frontend runs on `http://localhost:3000`

## Default Credentials

- **Admin**: `admin` / `admin123`
- **User**: `user` / `user123`

## Technology Stack

### Backend

- Spring Boot 3.2.0
- Java 17
- MySQL 8.0
- Spring Security with JWT
- Spring Data JPA

### Frontend

- React 18.2.0
- React Router DOM
- CSS3 (No frameworks)

## Features

- ✅ JWT-based authentication
- ✅ User management (Admin only)
- ✅ Promotion management with image upload
- ✅ Role-based access control
- ✅ RESTful API
- ✅ Modern responsive UI

## Documentation

- Backend details: See `promotion-system/README.md`
- Frontend details: See `frontend/README.md`

## Development Setup

### Prerequisites

- Java 17+
- Node.js 14+
- MySQL 8.0+
- IntelliJ IDEA (for backend)
- VSCode (for frontend)

### Database Setup

```sql
CREATE DATABASE promotion_db;
```

Update credentials in `promotion-system/src/main/resources/application.properties`

## License

This project is developed as an assignment submission.
