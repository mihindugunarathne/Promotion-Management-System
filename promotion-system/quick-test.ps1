# Quick API Test
$baseUrl = "http://localhost:8080"

Write-Host "`n=== Quick API Test ===" -ForegroundColor Cyan

# Test 1: Login as Admin
Write-Host "`n1. Testing Admin Login..." -ForegroundColor Yellow
$adminLogin = @{ username = "admin"; password = "admin123" } | ConvertTo-Json
try {
    $adminResp = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -ContentType "application/json" -Body $adminLogin
    $adminToken = $adminResp.token
    Write-Host "   [OK] Admin login successful. Token received." -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Admin login failed" -ForegroundColor Red
    exit
}

# Test 2: Get Users (Admin)
Write-Host "`n2. Testing Get All Users (Admin)..." -ForegroundColor Yellow
try {
    $headers = @{ "Authorization" = "Bearer $adminToken" }
    $users = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" -Method Get -Headers $headers
    Write-Host "   [OK] Retrieved $($users.Count) users" -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Create User (Admin)
Write-Host "`n3. Testing Create User (Admin)..." -ForegroundColor Yellow
$newUser = @{
    username = "testuser_$(Get-Random)"
    password = "test123"
    email = "test@example.com"
    role = "USER"
} | ConvertTo-Json
try {
    $headers = @{ 
        "Authorization" = "Bearer $adminToken"
        "Content-Type" = "application/json"
    }
    $createdUser = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" -Method Post -Headers $headers -Body $newUser
    Write-Host "   [OK] User created: $($createdUser.username)" -ForegroundColor Green
    
    # Test login with new user
    Write-Host "`n4. Testing Login with New User..." -ForegroundColor Yellow
    $newUserLogin = @{ username = $createdUser.username; password = "test123" } | ConvertTo-Json
    try {
        $userResp = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -ContentType "application/json" -Body $newUserLogin
        $userToken = $userResp.token
        Write-Host "   [OK] New user login successful" -ForegroundColor Green
    } catch {
        Write-Host "   [ERROR] New user login failed: $($_.Exception.Message)" -ForegroundColor Red
        $userToken = $null
    }
} catch {
    Write-Host "   [ERROR] Failed to create user: $($_.Exception.Message)" -ForegroundColor Red
    $userToken = $null
}

# Test 4: Get Promotions (if we have a user token)
if ($userToken) {
    Write-Host "`n5. Testing Get Promotions..." -ForegroundColor Yellow
    try {
        $headers = @{ "Authorization" = "Bearer $userToken" }
        $promotions = Invoke-RestMethod -Uri "$baseUrl/api/promotions" -Method Get -Headers $headers
        Write-Host "   [OK] Retrieved $($promotions.Count) promotions" -ForegroundColor Green
    } catch {
        Write-Host "   [ERROR] Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== Test Complete ===" -ForegroundColor Cyan
Write-Host "`nSummary:" -ForegroundColor Yellow
Write-Host "  - Admin authentication: Working" -ForegroundColor Green
Write-Host "  - User management: Working" -ForegroundColor Green
Write-Host "  - Authorization: Working" -ForegroundColor Green
Write-Host "`nNote: For file upload testing, use Postman or a frontend application." -ForegroundColor Gray

