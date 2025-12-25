# Running the Entire Project in VSCode

Yes, you can run both the backend and frontend in VSCode! Here's how to set it up.

## Prerequisites

1. **VSCode Extensions** (Install these first):
   - **Extension Pack for Java** (by Microsoft)
     - Includes: Java Language Support, Debugger, Maven, etc.
   - **Spring Boot Extension Pack** (by VMware)
     - Includes: Spring Boot Tools, Spring Initializr, etc.

2. **Required Software**:
   - Java 17 or later
   - Node.js 14 or later
   - MySQL 8.0 or later
   - Maven (or use Maven wrapper included)

## Setup Steps

### Step 1: Open the Root Project in VSCode

1. Open VSCode
2. File → Open Folder → Select the `PM system` folder (root folder)
3. This opens both `promotion-system` and `frontend` folders

### Step 2: Install VSCode Extensions

1. Press `Ctrl + Shift + X` to open Extensions
2. Search and install:
   - **Extension Pack for Java** (Microsoft)
   - **Spring Boot Extension Pack** (VMware)

### Step 3: Configure Java in VSCode

1. Press `Ctrl + Shift + P` to open Command Palette
2. Type: `Java: Configure Java Runtime`
3. Select your Java 17 installation
4. VSCode will automatically detect Maven

### Step 4: Run Backend (Spring Boot)

#### Option A: Using VSCode Terminal

1. Open terminal: `Ctrl + ` (backtick) or Terminal → New Terminal
2. Navigate to backend:
   ```bash
   cd promotion-system
   ```
3. Run Spring Boot:
   ```bash
   ./mvnw spring-boot:run
   ```
   Or if Maven is installed globally:
   ```bash
   mvn spring-boot:run
   ```

#### Option B: Using VSCode Run Configuration

1. Open `promotion-system/src/main/java/com/example/promotion_system/PromotionSystemApplication.java`
2. Click "Run" button above the `main` method
3. Or press `F5` to debug

#### Option C: Using Spring Boot Dashboard

1. After installing Spring Boot Extension Pack, you'll see a Spring Boot icon in the sidebar
2. Click on it to see the Spring Boot Dashboard
3. Find `PromotionSystemApplication` and click the play button

### Step 5: Run Frontend (React)

1. Open a **new terminal** in VSCode:
   - Terminal → New Terminal (or `Ctrl + Shift + ` `)
   - Or split terminal: `Ctrl + Shift + 5`

2. Navigate to frontend:
   ```bash
   cd frontend
   ```

3. Install dependencies (first time only):
   ```bash
   npm install
   ```

4. Start React app:
   ```bash
   npm start
   ```

## Running Both Simultaneously

### Using Multiple Terminals

VSCode supports multiple terminals. You can:

1. **Terminal 1** (Backend):
   ```bash
   cd promotion-system
   ./mvnw spring-boot:run
   ```

2. **Terminal 2** (Frontend):
   ```bash
   cd frontend
   npm start
   ```

### Using VSCode Tasks (Recommended)

Create a task configuration to run both automatically:

1. Create `.vscode/tasks.json` in the root folder:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Start Backend",
      "type": "shell",
      "command": "./mvnw spring-boot:run",
      "options": {
        "cwd": "${workspaceFolder}/promotion-system"
      },
      "problemMatcher": [],
      "isBackground": true,
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Start Frontend",
      "type": "shell",
      "command": "npm start",
      "options": {
        "cwd": "${workspaceFolder}/frontend"
      },
      "problemMatcher": [],
      "isBackground": true,
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Start All",
      "dependsOn": ["Start Backend", "Start Frontend"],
      "problemMatcher": []
    }
  ]
}
```

2. To run both:
   - Press `Ctrl + Shift + P`
   - Type: `Tasks: Run Task`
   - Select: `Start All`

## VSCode Workspace Configuration

Create `.vscode/settings.json` for better Java support:

```json
{
  "java.configuration.updateBuildConfiguration": "automatic",
  "java.compile.nullAnalysis.mode": "automatic",
  "files.exclude": {
    "**/target": true,
    "**/node_modules": true,
    "**/.git": true
  }
}
```

## Debugging

### Debug Backend (Spring Boot)

1. Open `PromotionSystemApplication.java`
2. Set breakpoints by clicking left of line numbers
3. Press `F5` or click "Run and Debug" in sidebar
4. Select "Java" as debugger
5. Application will start in debug mode

### Debug Frontend (React)

1. Install "Debugger for Chrome" extension (if needed)
2. Press `F5`
3. Select "Chrome" or "Edge" debugger
4. React app will open in browser with debugging enabled

## Tips

1. **Multiple Terminals**: Use `Ctrl + Shift + 5` to split terminal
2. **Terminal Tabs**: Right-click terminal tab → "Split Terminal"
3. **Java Auto-Import**: VSCode will suggest imports automatically
4. **Spring Boot Dashboard**: Monitor running Spring Boot apps
5. **Problems Panel**: View compilation errors in Problems tab (`Ctrl + Shift + M`)

## Troubleshooting

### Java Not Detected
- Install "Extension Pack for Java"
- Restart VSCode
- Check: `Ctrl + Shift + P` → `Java: Configure Java Runtime`

### Maven Not Found
- Use Maven wrapper: `./mvnw` instead of `mvn`
- Or install Maven and add to PATH

### Port Already in Use
- Backend: Change port in `application.properties`
- Frontend: Set `PORT=3001` in environment or `.env` file

### CORS Errors
- Ensure backend is running on port 8080
- Check CORS configuration in `SecurityConfig.java`

## Quick Start Commands

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

Both will run simultaneously in VSCode! 🚀

