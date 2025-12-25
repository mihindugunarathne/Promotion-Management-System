# Promotion Management System - Frontend

React frontend for the Promotion Management System.

## Technology Stack

- **Frontend**: React 18.2.0
- **Routing**: React Router DOM 6.20.0
- **Styling**: CSS3 (No frameworks)
- **Build Tool**: Create React App

## Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- VSCode (recommended) or any code editor
- Backend API running on `http://localhost:8080`

## Installation

1. Open VSCode
2. File → Open Folder → Select the `frontend` folder
3. Open terminal in VSCode (Ctrl + `)
4. Install dependencies:
```bash
npm install
```

## Running the Application

### Using VSCode

1. Open the `frontend` folder in VSCode
2. Open integrated terminal (Ctrl + ` or Terminal → New Terminal)
3. Run:
```bash
npm start
```
4. The application will open at `http://localhost:3000`

### Using Command Line

```bash
cd frontend
npm start
```

## Default Credentials

- **Admin**: username=`admin`, password=`admin123`
- **User**: username=`user`, password=`user123`

## Features

- **Authentication**: JWT-based login system
- **User Management** (Admin only): Create, view, edit, and delete users
- **Promotion Management**: Create, view, edit, and delete promotions with image upload
- **Role-based Access**: Different views for Admin and User roles
- **Modern UI**: Beautiful, responsive design

## Project Structure

```
frontend/
├── public/
│   └── index.html
├── src/
│   ├── components/
│   │   ├── Login.js & Login.css
│   │   ├── Dashboard.js & Dashboard.css
│   │   ├── UserManagement.js & UserManagement.css
│   │   ├── UserForm.js & UserForm.css
│   │   ├── PromotionManagement.js & PromotionManagement.css
│   │   └── PromotionForm.js & PromotionForm.css
│   ├── services/
│   │   ├── api.js          # API calls
│   │   └── auth.js         # Auth utilities
│   ├── App.js & App.css
│   ├── index.js & index.css
│   └── package.json
└── README.md
```

## Backend Integration

The frontend communicates with the backend API at `http://localhost:8080/api`.

**Important**: Make sure the backend is running before starting the frontend.

To start the backend separately (in IntelliJ IDEA or command line):
```bash
cd ../promotion-system
mvn spring-boot:run
```

## Available Scripts

- `npm start` - Start development server
- `npm run build` - Build for production
- `npm test` - Run tests
- `npm run eject` - Eject from Create React App (irreversible)

## Building for Production

```bash
npm run build
```

This creates an optimized production build in the `build` folder.

## API Endpoints Used

- `POST /api/auth/login` - Authentication
- `GET /api/admin/users` - Get all users (Admin)
- `POST /api/admin/users` - Create user (Admin)
- `PUT /api/admin/users/{id}` - Update user (Admin)
- `DELETE /api/admin/users/{id}` - Delete user (Admin)
- `GET /api/promotions` - Get all promotions
- `POST /api/promotions` - Create promotion
- `PUT /api/promotions/{id}` - Update promotion
- `DELETE /api/promotions/{id}` - Delete promotion
- `GET /uploads/{filename}` - Access banner images

## Troubleshooting

1. **CORS Errors**: Ensure backend is running and CORS is configured for localhost:3000
2. **API Connection Errors**: Verify backend is running on `http://localhost:8080`
3. **Module Not Found**: Run `npm install` to install dependencies
4. **Port 3000 in Use**: Change port by setting `PORT=3001` in environment

## Development Workflow

1. Start backend in IntelliJ IDEA (or separate terminal)
2. Start frontend in VSCode terminal: `npm start`
3. Open `http://localhost:3000` in browser
4. Login and test features

## Notes

- The application uses localStorage to store JWT tokens
- Images are served from `http://localhost:8080/uploads/`
- Maximum file upload size: 10MB
- Supported image formats: JPG, PNG, GIF

## License

This project is developed as an assignment submission.
