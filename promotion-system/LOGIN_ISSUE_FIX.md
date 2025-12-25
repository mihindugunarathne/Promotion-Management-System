# Login Issue - Diagnosis and Fix

## Changes Made

### 1. Improved Error Handling in AuthController

The `AuthController` now properly handles different types of authentication exceptions:
- **BadCredentialsException** → Returns 401 with "Invalid username or password"
- **DisabledException** → Returns 401 with "User account is disabled"
- **Other AuthenticationException** → Returns 401 with detailed message
- **General Exception** → Returns 400 with error message

This will give you better error messages in Postman instead of generic 400 errors.

### 2. Added Diagnostic Endpoints

Created a `DiagnosticController` with two endpoints to help diagnose login issues:

#### Check Specific User
```
GET /api/diagnostic/check-user/{username}
```
Returns detailed information about a user including:
- User exists or not
- Username, email, role, active status
- Whether password matches expected value

#### Get All Users
```
GET /api/diagnostic/all-users
```
Returns list of all users in the database.

**Note:** These endpoints are public (no authentication required) for diagnostic purposes.

### 3. Created Diagnostic Script

Created `diagnose-login-issue.ps1` that will:
- Check if application is running
- List all users in database
- Check if admin/user accounts exist
- Verify password encoding matches
- Test both admin and user login
- Provide detailed error messages

---

## How to Diagnose the Issue

### Step 1: Restart the Application

Make sure the application is running with the latest code:

```bash
cd "D:\PROJECTS\PM system\promotion-system"
mvn spring-boot:run
```

Wait for the application to fully start (you'll see "Started PromotionSystemApplication").

### Step 2: Run the Diagnostic Script

```powershell
cd "D:\PROJECTS\PM system\promotion-system"
powershell -ExecutionPolicy Bypass -File .\diagnose-login-issue.ps1
```

This will show you:
- If users exist in the database
- If passwords are correctly encoded
- What the actual error is when trying to login

### Step 3: Check Diagnostic Endpoints in Postman

#### Check if User Exists:
```
GET http://localhost:8080/api/diagnostic/check-user/user
```

**Expected Response:**
```json
{
  "exists": true,
  "username": "user",
  "role": "USER",
  "isActive": true,
  "passwordMatches_user123": true
}
```

If `passwordMatches_user123` is `false`, that's the problem!

#### Get All Users:
```
GET http://localhost:8080/api/diagnostic/all-users
```

---

## Common Issues and Solutions

### Issue 1: User Doesn't Exist

**Symptoms:**
- Diagnostic shows `"exists": false`
- No user with username "user" in database

**Solution:**
1. Restart the application to trigger `DataInitializer`
2. Check application console for messages like:
   ```
   Regular user created: username=user, password=user123
   ```
3. If user still doesn't exist, check:
   - Database connection is working
   - `DataInitializer` is running (check logs)
   - No errors during application startup

### Issue 2: Password Doesn't Match

**Symptoms:**
- User exists but `passwordMatches_user123` is `false`
- Login returns 401 Unauthorized

**Solution:**
The user might have been created with a different password. Options:
1. **Delete and recreate the user:**
   - Login as admin
   - Delete the "user" account
   - Restart application (DataInitializer will recreate it)

2. **Update the user password:**
   - Login as admin
   - Use Update User endpoint to set password to "user123"

### Issue 3: User Account is Inactive

**Symptoms:**
- User exists but `isActive` is `false`
- Login returns 401 Unauthorized

**Solution:**
- Login as admin
- Update user to set `isActive: true`

### Issue 4: Application Not Running

**Symptoms:**
- All requests fail with connection error
- Diagnostic script can't connect

**Solution:**
```bash
cd "D:\PROJECTS\PM system\promotion-system"
mvn spring-boot:run
```

---

## Testing in Postman

### Step 1: Check User Exists
```
GET http://localhost:8080/api/diagnostic/check-user/user
```

### Step 2: Try Login with Better Error Messages

Now when you login, you'll get more specific error messages:

**Request:**
```
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "user",
  "password": "user123"
}
```

**Possible Responses:**

**Success (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 2,
  "username": "user",
  "email": "user@promotionsystem.com",
  "role": "USER"
}
```

**Invalid Credentials (401 Unauthorized):**
```json
"Error: Invalid username or password"
```

**User Disabled (401 Unauthorized):**
```json
"Error: User account is disabled"
```

**Other Error (400 Bad Request):**
```json
"Error: [specific error message]"
```

---

## Quick Fix: Recreate User Account

If the user account has issues, you can recreate it:

1. **Login as Admin:**
   ```
   POST http://localhost:8080/api/auth/login
   {
     "username": "admin",
     "password": "admin123"
   }
   ```

2. **Delete existing user (if exists):**
   ```
   DELETE http://localhost:8080/api/admin/users/{user_id}
   Authorization: Bearer {admin_token}
   ```

3. **Create new user:**
   ```
   POST http://localhost:8080/api/admin/users
   Authorization: Bearer {admin_token}
   {
     "username": "user",
     "password": "user123",
     "email": "user@promotionsystem.com",
     "role": "USER"
   }
   ```

4. **Test login with new user:**
   ```
   POST http://localhost:8080/api/auth/login
   {
     "username": "user",
     "password": "user123"
   }
   ```

---

## Summary

The improved error handling will now give you:
- ✅ Better error messages (401 vs 400)
- ✅ Specific error types (bad credentials, disabled account, etc.)
- ✅ Diagnostic endpoints to check user accounts
- ✅ Script to automatically diagnose issues

**Next Steps:**
1. Restart your application
2. Run the diagnostic script
3. Check the diagnostic endpoints in Postman
4. Use the improved error messages to identify the exact issue

If you still get 400 Bad Request, check:
- Application logs for detailed stack traces
- Database to see if user exists
- Password encoding in the database

