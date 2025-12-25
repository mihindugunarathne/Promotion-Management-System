# PowerShell script to test Promotion Management System API
# Make sure the application is running on http://localhost:8080

$baseUrl = "http://localhost:8080"
$adminToken = ""
$userToken = ""

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Promotion Management System API Test" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Login as Admin
Write-Host "Step 1: Login as Admin..." -ForegroundColor Yellow
$loginBody = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody
    
    $adminToken = $response.token
    Write-Host "✓ Admin login successful!" -ForegroundColor Green
    Write-Host "  Token: $($adminToken.Substring(0, 50))..." -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Admin login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Get All Users (Admin)
Write-Host "Step 2: Get All Users (Admin)..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $adminToken"
    }
    $users = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" `
        -Method Get `
        -Headers $headers
    
    Write-Host "✓ Retrieved $($users.Count) users" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ Failed to get users: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Create a User (Admin)
Write-Host "Step 3: Create a User (Admin)..." -ForegroundColor Yellow
$newUserBody = @{
    username = "testuser"
    password = "test123"
    email = "testuser@example.com"
    role = "USER"
} | ConvertTo-Json

try {
    $headers = @{
        "Authorization" = "Bearer $adminToken"
        "Content-Type" = "application/json"
    }
    $newUser = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" `
        -Method Post `
        -Headers $headers `
        -Body $newUserBody
    
    Write-Host "✓ User created successfully! ID: $($newUser.id)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ Failed to create user: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Login as Regular User
Write-Host "Step 4: Login as Regular User..." -ForegroundColor Yellow
$loginBody = @{
    username = "user"
    password = "user123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody
    
    $userToken = $response.token
    Write-Host "✓ User login successful!" -ForegroundColor Green
    Write-Host "  Token: $($userToken.Substring(0, 50))..." -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ User login failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 5: Create a Promotion
Write-Host "Step 5: Create a Promotion..." -ForegroundColor Yellow
$promotionData = @{
    name = "Test Promotion"
    startDate = "2024-06-01"
    endDate = "2024-08-31"
} | ConvertTo-Json

try {
    $headers = @{
        "Authorization" = "Bearer $userToken"
    }
    
    # Note: File upload requires multipart/form-data which is complex in PowerShell
    # This will create promotion without file
    $boundary = [System.Guid]::NewGuid().ToString()
    $bodyLines = @(
        "--$boundary",
        "Content-Disposition: form-data; name=`"promotion`"",
        "",
        $promotionData,
        "--$boundary--"
    )
    $body = $bodyLines -join "`r`n"
    
    $promotion = Invoke-RestMethod -Uri "$baseUrl/api/promotions" `
        -Method Post `
        -Headers $headers `
        -ContentType "multipart/form-data; boundary=$boundary" `
        -Body $body
    
    Write-Host "✓ Promotion created successfully! ID: $($promotion.id)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ Failed to create promotion: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Note: File upload requires multipart/form-data. Use Postman for full testing." -ForegroundColor Yellow
}

# Step 6: Get All Promotions
Write-Host "Step 6: Get All Promotions..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $userToken"
    }
    $promotions = Invoke-RestMethod -Uri "$baseUrl/api/promotions" `
        -Method Get `
        -Headers $headers
    
    Write-Host "✓ Retrieved $($promotions.Count) promotions" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ Failed to get promotions: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Test completed!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: For file upload testing, use Postman or a frontend application." -ForegroundColor Yellow
Write-Host "See TEST_API.md for detailed testing instructions." -ForegroundColor Yellow

