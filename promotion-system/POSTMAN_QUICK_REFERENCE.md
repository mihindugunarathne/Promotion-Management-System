# Postman Quick Reference Card

## Setup (One-Time)

1. **Environment Variables:**
   - `baseUrl` = `http://localhost:8080`
   - `adminToken` = (set after login)
   - `userToken` = (set after login)

2. **Default Credentials:**
   - Admin: `admin` / `admin123`
   - User: `user` / `user123`

---

## Authentication

### Login as Admin
```
POST {{baseUrl}}/api/auth/login
Body (JSON):
{
  "username": "admin",
  "password": "admin123"
}
→ Save token to adminToken variable
```

### Login as User
```
POST {{baseUrl}}/api/auth/login
Body (JSON):
{
  "username": "user",
  "password": "user123"
}
→ Save token to userToken variable
```

---

## User Management (Admin Only)

### Get All Users
```
GET {{baseUrl}}/api/admin/users
Auth: Bearer {{adminToken}}
```

### Create User
```
POST {{baseUrl}}/api/admin/users
Auth: Bearer {{adminToken}}
Body (JSON):
{
  "username": "newuser",
  "password": "password123",
  "email": "user@example.com",
  "role": "USER"
}
```

### Get User by ID
```
GET {{baseUrl}}/api/admin/users/{id}
Auth: Bearer {{adminToken}}
```

### Update User
```
PUT {{baseUrl}}/api/admin/users/{id}
Auth: Bearer {{adminToken}}
Body (JSON): { same as Create User }
```

### Delete User
```
DELETE {{baseUrl}}/api/admin/users/{id}
Auth: Bearer {{adminToken}}
```

---

## Promotion Management

### Get All Promotions
```
GET {{baseUrl}}/api/promotions
Auth: Bearer {{userToken}}
```

### Create Promotion (WITH FILE)
```
POST {{baseUrl}}/api/promotions
Auth: Bearer {{userToken}}
Body (form-data):
  promotion (Text): {"name":"Sale","startDate":"2024-06-01","endDate":"2024-08-31"}
  file (File): [select image file]
```

### Create Promotion (NO FILE)
```
POST {{baseUrl}}/api/promotions
Auth: Bearer {{userToken}}
Body (form-data):
  promotion (Text): {"name":"Sale","startDate":"2024-06-01","endDate":"2024-08-31"}
```

### Get Promotion by ID
```
GET {{baseUrl}}/api/promotions/{id}
Auth: Bearer {{userToken}}
```

### Update Promotion
```
PUT {{baseUrl}}/api/promotions/{id}
Auth: Bearer {{userToken}}
Body (form-data): { same as Create }
```

### Delete Promotion
```
DELETE {{baseUrl}}/api/promotions/{id}
Auth: Bearer {{userToken}}
```

### Access Banner Image
```
GET {{baseUrl}}/uploads/{bannerImagePath}
No Auth needed
Example: {{baseUrl}}/uploads/abc123_banner.jpg
```

---

## Important Notes

### For File Upload:
- Use **form-data** (NOT raw JSON!)
- `promotion` field = **Text** type with JSON string
- `file` field = **File** type
- Max file size: 10MB

### Authorization:
- Admin endpoints: Use `{{adminToken}}`
- Promotion endpoints: Use `{{userToken}}` or `{{adminToken}}`
- Public endpoints: No auth needed (`/api/auth/login`, `/uploads/*`)

### Common Status Codes:
- `200` = Success
- `201` = Created
- `400` = Bad Request (check your JSON/body)
- `401` = Unauthorized (invalid/missing token)
- `403` = Forbidden (wrong role)
- `404` = Not Found (wrong ID/endpoint)

---

## Testing Checklist

- [ ] Login (Admin & User)
- [ ] Create/Read/Update/Delete User (Admin)
- [ ] Create/Read/Update/Delete Promotion
- [ ] File Upload (Create & Update)
- [ ] Access uploaded image
- [ ] Test authorization (user accessing admin endpoint)
- [ ] Test invalid token

---

## Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| 401 Unauthorized | Check token in Authorization header |
| 403 Forbidden | Use correct role token (admin vs user) |
| File upload fails | Use form-data, not raw JSON |
| Can't see image | Check bannerImagePath value in promotion object |
| 400 Bad Request | Validate JSON format and required fields |

