# Postman Testing Guide for Promotion Management System

This guide will help you test all API endpoints using Postman.

## Prerequisites

1. **Start the Spring Boot Application**

   ```bash
   cd "D:\PROJECTS\PM system\promotion-system"
   mvn spring-boot:run
   ```

   Wait for the application to start (you'll see "Started PromotionSystemApplication" in the console)

2. **Ensure MySQL is running** and the database `promotion_db` exists

3. **Download Postman** (if not already installed): https://www.postman.com/downloads/

---

## Step 1: Create a Postman Collection

1. Open Postman
2. Click **"New"** → **"Collection"**
3. Name it: **"Promotion Management System"**
4. Click **"Create"**

---

## Step 2: Set Up Environment Variables

1. Click the **"Environments"** icon (left sidebar) or go to **View** → **Show Environments**
2. Click **"+"** to create a new environment
3. Name it: **"Local Development"**
4. Add these variables:

| Variable     | Initial Value           | Current Value           |
| ------------ | ----------------------- | ----------------------- |
| `baseUrl`    | `http://localhost:8080` | `http://localhost:8080` |
| `adminToken` | (leave empty)           | (leave empty)           |
| `userToken`  | (leave empty)           | (leave empty)           |

5. Click **"Save"**
6. Select **"Local Development"** from the environment dropdown (top right)

---

## Step 3: Create API Requests

### Request 1: Login as Admin

1. In your collection, click **"Add Request"**
2. Name it: **"1. Login - Admin"**
3. Set method to **POST**
4. Enter URL: `{{baseUrl}}/api/auth/login`
5. Go to **"Body"** tab
6. Select **"raw"** and **"JSON"** from dropdown
7. Enter this JSON:

```json
{
  "username": "admin",
  "password": "admin123"
}
```

8. Click **"Send"**
9. You should get a response with a token
10. **IMPORTANT**: Copy the `token` value from the response
11. Go to **Environments** → **Local Development**
12. Paste the token into `adminToken` variable's **Current Value**
13. Click **"Save"**

**Expected Response:**

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

---

### Request 2: Get All Users (Admin Only)

1. Add new request: **"2. Get All Users"**
2. Method: **GET**
3. URL: `{{baseUrl}}/api/admin/users`
4. Go to **"Authorization"** tab
5. Type: **"Bearer Token"**
6. Token: `{{adminToken}}`
7. Click **"Send"**

**Expected Response:** Array of user objects

---

### Request 3: Create User (Admin Only)

1. Add new request: **"3. Create User"**
2. Method: **POST**
3. URL: `{{baseUrl}}/api/admin/users`
4. **Authorization** tab: Bearer Token = `{{adminToken}}`
5. **Body** tab: Select **"raw"** and **"JSON"**
6. Enter:

```json
{
  "username": "newuser",
  "password": "password123",
  "email": "newuser@example.com",
  "role": "USER"
}
```

7. Click **"Send"**

**Expected Response:** Status 201 Created with user object

---

### Request 4: Get User by ID (Admin Only)

1. Add new request: **"4. Get User by ID"**
2. Method: **GET**
3. URL: `{{baseUrl}}/api/admin/users/1` (replace 1 with actual user ID)
4. **Authorization**: Bearer Token = `{{adminToken}}`
5. Click **"Send"**

**Expected Response:** User object with specified ID

---

### Request 5: Update User (Admin Only)

1. Add new request: **"5. Update User"**
2. Method: **PUT**
3. URL: `{{baseUrl}}/api/admin/users/2` (replace 2 with actual user ID)
4. **Authorization**: Bearer Token = `{{adminToken}}`
5. **Body** tab: Select **"raw"** and **"JSON"**
6. Enter:

```json
{
  "username": "updateduser",
  "password": "newpassword123",
  "email": "updated@example.com",
  "role": "USER"
}
```

7. Click **"Send"**

**Expected Response:** Updated user object

---

### Request 6: Delete User (Admin Only)

1. Add new request: **"6. Delete User"**
2. Method: **DELETE**
3. URL: `{{baseUrl}}/api/admin/users/3` (replace 3 with actual user ID)
4. **Authorization**: Bearer Token = `{{adminToken}}`
5. Click **"Send"**

**Expected Response:** "User deleted successfully"

---

### Request 7: Login as Regular User

1. Add new request: **"7. Login - User"**
2. Method: **POST**
3. URL: `{{baseUrl}}/api/auth/login`
4. **Body** tab: Select **"raw"** and **"JSON"**
5. Enter:

```json
{
  "username": "user",
  "password": "user123"
}
```

6. Click **"Send"**
7. Copy the `token` from response
8. Update `userToken` in environment variables

**Expected Response:** JWT token with user details

---

### Request 8: Get All Promotions

1. Add new request: **"8. Get All Promotions"**
2. Method: **GET**
3. URL: `{{baseUrl}}/api/promotions`
4. **Authorization**: Bearer Token = `{{userToken}}`
5. Click **"Send"**

**Expected Response:** Array of promotion objects

---

### Request 9: Create Promotion (WITH FILE UPLOAD)

This is the most important test for file upload functionality!

1. Add new request: **"9. Create Promotion with Banner"**
2. Method: **POST**
3. URL: `{{baseUrl}}/api/promotions`
4. **Authorization**: Bearer Token = `{{userToken}}`
5. Go to **"Body"** tab
6. Select **"form-data"** (NOT raw!)
7. Add two fields:

   **Field 1:**

   - Key: `promotion` (type: Text)
   - Value:

   ```json
   {
     "name": "Summer Sale 2024",
     "startDate": "2024-06-01",
     "endDate": "2024-08-31"
   }
   ```

   **Field 2:**

   - Key: `file` (type: File)
   - Value: Click **"Select Files"** and choose an image file (jpg, png, etc.)

8. Click **"Send"**

**Expected Response:** Promotion object with `bannerImagePath` field

**Important Notes:**

- The `promotion` field must be a JSON string (not a JSON object)
- The `file` field is optional - you can create promotions without files
- Maximum file size: 10MB

---

### Request 10: Get Promotion by ID

1. Add new request: **"10. Get Promotion by ID"**
2. Method: **GET**
3. URL: `{{baseUrl}}/api/promotions/1` (replace 1 with actual promotion ID)
4. **Authorization**: Bearer Token = `{{userToken}}`
5. Click **"Send"**

**Expected Response:** Promotion object

---

### Request 11: Update Promotion (WITH FILE UPLOAD)

1. Add new request: **"11. Update Promotion"**
2. Method: **PUT**
3. URL: `{{baseUrl}}/api/promotions/1` (replace 1 with actual promotion ID)
4. **Authorization**: Bearer Token = `{{userToken}}`
5. **Body** tab: Select **"form-data"**
6. Add fields:

   **Field 1:**

   - Key: `promotion` (type: Text)
   - Value:

   ```json
   {
     "name": "Updated Summer Sale 2024",
     "startDate": "2024-06-01",
     "endDate": "2024-09-30"
   }
   ```

   **Field 2 (Optional):**

   - Key: `file` (type: File)
   - Value: Select a new image file

7. Click **"Send"**

**Expected Response:** Updated promotion object

---

### Request 12: Delete Promotion

1. Add new request: **"12. Delete Promotion"**
2. Method: **DELETE**
3. URL: `{{baseUrl}}/api/promotions/1` (replace 1 with actual promotion ID)
4. **Authorization**: Bearer Token = `{{userToken}}`
5. Click **"Send"**

**Expected Response:** "Promotion deleted successfully"

---

### Request 13: Access Uploaded Banner Image

1. Add new request: **"13. Get Banner Image"**
2. Method: **GET**
3. URL: `{{baseUrl}}/uploads/{filename}`
   - Replace `{filename}` with the `bannerImagePath` value from a promotion object
   - Example: If `bannerImagePath` is `abc123_banner.jpg`, URL should be:
     `{{baseUrl}}/uploads/abc123_banner.jpg`
4. **No Authorization needed** (public endpoint)
5. Click **"Send"**

**Expected Response:** The image file (you should see the image in Postman)

---

### Request 14: Test Authorization (User trying to access Admin endpoint)

1. Add new request: **"14. Test Authorization - Should Fail"**
2. Method: **GET**
3. URL: `{{baseUrl}}/api/admin/users`
4. **Authorization**: Bearer Token = `{{userToken}}` (using USER token, not ADMIN)
5. Click \*\*"Send"`

**Expected Response:**

- Status: **403 Forbidden**
- This proves authorization is working correctly!

---

### Request 15: Test Invalid Token

1. Add new request: **"15. Test Invalid Token - Should Fail"**
2. Method: **GET**
3. URL: `{{baseUrl}}/api/promotions`
4. **Authorization**: Bearer Token = `invalid_token_12345`
5. Click \*\*"Send"`

**Expected Response:**

- Status: **401 Unauthorized** or **403 Forbidden**
- This proves JWT validation is working!

---

## Step 4: Organize Your Collection

1. Right-click on your collection
2. Select **"Add Folder"**
3. Create folders:

   - **"Authentication"** (Login requests)
   - **"User Management (Admin)"** (User CRUD)
   - **"Promotion Management"** (Promotion CRUD)
   - **"Testing"** (Authorization tests)

4. Drag requests into appropriate folders

---

## Step 5: Save and Export Collection

1. Click the **"..."** (three dots) next to your collection
2. Select **"Export"**
3. Choose **"Collection v2.1"**
4. Save the file (e.g., `Promotion-System-API.postman_collection.json`)

You can now share this collection or import it later!

---

## Testing Checklist

Use this checklist to ensure you've tested everything:

### Authentication

- [ ] Login as Admin
- [ ] Login as Regular User
- [ ] Test Invalid Token
- [ ] Test Missing Token

### User Management (Admin Only)

- [ ] Get All Users
- [ ] Create User
- [ ] Get User by ID
- [ ] Update User
- [ ] Delete User
- [ ] Test User trying to access Admin endpoint (should fail)

### Promotion Management

- [ ] Get All Promotions
- [ ] Create Promotion (without file)
- [ ] Create Promotion (with file upload) ⭐
- [ ] Get Promotion by ID
- [ ] Update Promotion (without file)
- [ ] Update Promotion (with new file) ⭐
- [ ] Delete Promotion
- [ ] Access Banner Image via URL

### File Upload Testing

- [ ] Upload small image (< 1MB)
- [ ] Upload medium image (1-5MB)
- [ ] Upload large image (5-10MB)
- [ ] Try uploading file > 10MB (should fail)
- [ ] Verify image is accessible via `/uploads/` endpoint
- [ ] Update promotion with new image (old image should be deleted)

---

## Common Issues and Solutions

### Issue 1: "401 Unauthorized"

**Solution:**

- Check if token is set correctly in environment variable
- Make sure token includes "Bearer " prefix (Postman adds this automatically)
- Token might have expired (login again to get new token)

### Issue 2: "403 Forbidden"

**Solution:**

- You're trying to access an admin endpoint with a user token
- Use `{{adminToken}}` for admin endpoints
- Use `{{userToken}}` for promotion endpoints

### Issue 3: File Upload Not Working

**Solution:**

- Make sure you selected **"form-data"** (NOT raw or x-www-form-urlencoded)
- The `promotion` field must be type **"Text"** with JSON string value
- The `file` field must be type **"File"**
- Check file size (max 10MB)

### Issue 4: "400 Bad Request" on Login

**Solution:**

- Check username and password are correct
- Default credentials:
  - Admin: `admin` / `admin123`
  - User: `user` / `user123`
- Make sure JSON is valid

### Issue 5: Cannot Access Banner Image

**Solution:**

- Check the `bannerImagePath` value from promotion object
- URL format: `http://localhost:8080/uploads/{bannerImagePath}`
- Make sure application is running
- Check if file exists in `uploads/banners/` directory

---

## Tips for Efficient Testing

1. **Use Collection Runner:**

   - Click on your collection
   - Click **"Run"**
   - Select requests to run in sequence
   - Useful for testing the full flow

2. **Use Pre-request Scripts:**

   - Automatically refresh tokens
   - Set dynamic values

3. **Use Tests Tab:**

   - Add assertions to verify responses
   - Example: Check status code is 200
   - Save tokens automatically

4. **Save Responses:**
   - Right-click on response
   - Select **"Save Response"**
   - Useful for documentation

---

## Example Test Script (Optional)

In the **"Tests"** tab of your Login request, you can add:

```javascript
// Automatically save token to environment
if (pm.response.code === 200) {
  var jsonData = pm.response.json();
  pm.environment.set("adminToken", jsonData.token);
  console.log("Token saved to environment");
}
```

This automatically saves the token when you login!

---

## Quick Reference: All Endpoints

| Method | Endpoint                | Auth Required | Role Required |
| ------ | ----------------------- | ------------- | ------------- |
| POST   | `/api/auth/login`       | No            | -             |
| GET    | `/api/admin/users`      | Yes           | ADMIN         |
| POST   | `/api/admin/users`      | Yes           | ADMIN         |
| GET    | `/api/admin/users/{id}` | Yes           | ADMIN         |
| PUT    | `/api/admin/users/{id}` | Yes           | ADMIN         |
| DELETE | `/api/admin/users/{id}` | Yes           | ADMIN         |
| GET    | `/api/promotions`       | Yes           | USER/ADMIN    |
| POST   | `/api/promotions`       | Yes           | USER/ADMIN    |
| GET    | `/api/promotions/{id}`  | Yes           | USER/ADMIN    |
| PUT    | `/api/promotions/{id}`  | Yes           | USER/ADMIN    |
| DELETE | `/api/promotions/{id}`  | Yes           | USER/ADMIN    |
| GET    | `/uploads/{filename}`   | No            | -             |

---

## Success Criteria

Your testing is complete when:

- ✅ All endpoints return expected status codes
- ✅ JWT tokens are generated and validated
- ✅ Admin can manage users
- ✅ Users can manage promotions
- ✅ File uploads work correctly
- ✅ Images are accessible via `/uploads/` endpoint
- ✅ Authorization is enforced (403 for unauthorized access)
- ✅ Invalid tokens are rejected (401/403)

---

Good luck with your testing! 🚀
