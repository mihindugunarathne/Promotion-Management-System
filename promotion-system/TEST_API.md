# API Testing Guide

This guide helps you test all the API endpoints of the Promotion Management System.

## Prerequisites

1. **Start MySQL** and ensure the database `promotion_db` exists
2. **Start the Spring Boot application**:
   ```bash
   mvn spring-boot:run
   ```
3. The application will be available at `http://localhost:8080`

## Test Credentials

- **Admin**: username=`admin`, password=`admin123`
- **User**: username=`user`, password=`user123`

---

## Testing Steps

### Step 1: Login as Admin

**Request:**

```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

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

**Save the token** for subsequent requests (replace `YOUR_ADMIN_TOKEN` with the actual token).

---

### Step 2: Create a User (Admin Only)

**Request:**

```bash
POST http://localhost:8080/api/admin/users
Authorization: Bearer YOUR_ADMIN_TOKEN
Content-Type: application/json

{
  "username": "testuser",
  "password": "test123",
  "email": "testuser@example.com",
  "role": "USER"
}
```

**Expected Response:** Status 201 Created with user object

---

### Step 3: Get All Users (Admin Only)

**Request:**

```bash
GET http://localhost:8080/api/admin/users
Authorization: Bearer YOUR_ADMIN_TOKEN
```

**Expected Response:** Array of user objects

---

### Step 4: Get User by ID (Admin Only)

**Request:**

```bash
GET http://localhost:8080/api/admin/users/1
Authorization: Bearer YOUR_ADMIN_TOKEN
```

**Expected Response:** User object with id 1

---

### Step 5: Update User (Admin Only)

**Request:**

```bash
PUT http://localhost:8080/api/admin/users/2
Authorization: Bearer YOUR_ADMIN_TOKEN
Content-Type: application/json

{
  "username": "updateduser",
  "password": "newpassword123",
  "email": "updated@example.com",
  "role": "USER"
}
```

**Expected Response:** Updated user object

---

### Step 6: Login as Regular User

**Request:**

```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "user",
  "password": "user123"
}
```

**Save the token** for promotion operations (replace `YOUR_USER_TOKEN` with the actual token).

---

### Step 7: Create a Promotion

**Request:**

```bash
POST http://localhost:8080/api/promotions
Authorization: Bearer YOUR_USER_TOKEN
Content-Type: multipart/form-data

promotion: {
  "name": "Summer Sale 2024",
  "startDate": "2024-06-01",
  "endDate": "2024-08-31"
}
file: [select an image file]
```

**Note:** For multipart/form-data, you'll need to use a tool like Postman, cURL, or a frontend form.

**Expected Response:** Status 201 Created with promotion object

---

### Step 8: Get All Promotions

**Request:**

```bash
GET http://localhost:8080/api/promotions
Authorization: Bearer YOUR_USER_TOKEN
```

**Expected Response:** Array of promotion objects

---

### Step 9: Get Promotion by ID

**Request:**

```bash
GET http://localhost:8080/api/promotions/1
Authorization: Bearer YOUR_USER_TOKEN
```

**Expected Response:** Promotion object with id 1

---

### Step 10: Update Promotion

**Request:**

```bash
PUT http://localhost:8080/api/promotions/1
Authorization: Bearer YOUR_USER_TOKEN
Content-Type: multipart/form-data

promotion: {
  "name": "Updated Summer Sale 2024",
  "startDate": "2024-06-01",
  "endDate": "2024-09-30"
}
file: [optional new image file]
```

**Expected Response:** Updated promotion object

---

### Step 11: Access Uploaded Banner Image

**Request:**

```bash
GET http://localhost:8080/uploads/{filename}
```

Replace `{filename}` with the `bannerImagePath` value from the promotion object.

**Expected Response:** The image file

---

### Step 12: Delete Promotion

**Request:**

```bash
DELETE http://localhost:8080/api/promotions/1
Authorization: Bearer YOUR_USER_TOKEN
```

**Expected Response:** "Promotion deleted successfully"

---

### Step 13: Delete User (Admin Only)

**Request:**

```bash
DELETE http://localhost:8080/api/admin/users/2
Authorization: Bearer YOUR_ADMIN_TOKEN
```

**Expected Response:** "User deleted successfully"

---

## Testing with cURL

Here are some cURL commands you can use:

### Login

```bash
curl -X POST http://localhost:8080/api/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"admin\",\"password\":\"admin123\"}"
```

### Get All Users (replace TOKEN with actual token)

```bash
curl -X GET http://localhost:8080/api/admin/users ^
  -H "Authorization: Bearer TOKEN"
```

### Create Promotion (replace TOKEN with actual token)

```bash
curl -X POST http://localhost:8080/api/promotions ^
  -H "Authorization: Bearer TOKEN" ^
  -F "promotion={\"name\":\"Test Promotion\",\"startDate\":\"2024-06-01\",\"endDate\":\"2024-08-31\"}" ^
  -F "file=@/path/to/image.jpg"
```

---

## Testing with Postman

1. **Create a new Collection** called "Promotion System API"
2. **Set Collection Variables:**

   - `baseUrl`: `http://localhost:8080`
   - `adminToken`: (will be set after login)
   - `userToken`: (will be set after login)

3. **Create Requests:**

   - Login (Admin) → Save token to `adminToken`
   - Login (User) → Save token to `userToken`
   - Create User (use `{{adminToken}}` in Authorization header)
   - Get All Users (use `{{adminToken}}`)
   - Create Promotion (use `{{userToken}}`, form-data body)
   - etc.

4. **For multipart/form-data requests:**
   - Set body type to "form-data"
   - Add key `promotion` (type: Text) with JSON string value
   - Add key `file` (type: File) and select an image file

---

## Expected Test Results

✅ **Success Criteria:**

- All endpoints return appropriate status codes (200, 201, 404, etc.)
- JWT tokens are generated and validated correctly
- Admin can manage users
- Users can manage promotions
- File uploads work correctly
- Images are accessible via `/uploads/` endpoint
- Authorization is enforced (non-admin cannot access admin endpoints)

---

## Troubleshooting

- **401 Unauthorized**: Check if token is included in Authorization header as `Bearer {token}`
- **403 Forbidden**: User role doesn't have permission (e.g., USER trying to access admin endpoints)
- **404 Not Found**: Resource doesn't exist or wrong endpoint URL
- **500 Internal Server Error**: Check application logs for details

---

## Database Verification

After testing, you can verify data in MySQL:

```sql
USE promotion_db;

-- Check users
SELECT * FROM users;

-- Check promotions
SELECT * FROM promotions;

-- Check uploaded files directory
-- Files should be in: promotion-system/uploads/banners/
```
