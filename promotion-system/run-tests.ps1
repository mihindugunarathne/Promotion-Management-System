# Test script for Promotion Management System
Write-Host "Waiting for application to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 25

$baseUrl = "http://localhost:8080"
$adminToken = ""
$userToken = ""

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "Testing Promotion Management System API" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# Test 1: Login as Admin
Write-Host "Test 1: Login as Admin..." -ForegroundColor Yellow
try {
    $loginBody = @{
        username = "admin"
        password = "admin123"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody `
        -ErrorAction Stop
    
    $adminToken = $response.token
    Write-Host "[PASS] Admin login successful" -ForegroundColor Green
    Write-Host "  User: $($response.username), Role: $($response.role), ID: $($response.id)" -ForegroundColor Gray
} catch {
    Write-Host "[FAIL] Admin login failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Make sure the application is running on $baseUrl" -ForegroundColor Yellow
    exit 1
}

# Test 2: Get All Users (Admin)
Write-Host "`nTest 2: Get All Users (Admin Only)..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $adminToken"
    }
    $users = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" `
        -Method Get `
        -Headers $headers `
        -ErrorAction Stop
    
    Write-Host "[PASS] Retrieved $($users.Count) users" -ForegroundColor Green
    foreach ($user in $users) {
        Write-Host "  - $($user.username) ($($user.role))" -ForegroundColor Gray
    }
} catch {
    Write-Host "[FAIL] Get users failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Create a User (Admin)
Write-Host "`nTest 3: Create a New User (Admin Only)..." -ForegroundColor Yellow
try {
    $newUserBody = @{
        username = "testuser_$(Get-Date -Format 'HHmmss')"
        password = "test123"
        email = "testuser@example.com"
        role = "USER"
    } | ConvertTo-Json

    $headers = @{
        "Authorization" = "Bearer $adminToken"
        "Content-Type" = "application/json"
    }
    $newUser = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" `
        -Method Post `
        -Headers $headers `
        -Body $newUserBody `
        -ErrorAction Stop
    
    Write-Host "[PASS] User created successfully" -ForegroundColor Green
    Write-Host "  ID: $($newUser.id), Username: $($newUser.username)" -ForegroundColor Gray
    $createdUserId = $newUser.id
} catch {
    Write-Host "[FAIL] Create user failed: $($_.Exception.Message)" -ForegroundColor Red
    $createdUserId = $null
}

# Test 4: Get User by ID (Admin)
if ($createdUserId) {
    Write-Host "`nTest 4: Get User by ID (Admin Only)..." -ForegroundColor Yellow
    try {
        $headers = @{
            "Authorization" = "Bearer $adminToken"
        }
        $user = Invoke-RestMethod -Uri "$baseUrl/api/admin/users/$createdUserId" `
            -Method Get `
            -Headers $headers `
            -ErrorAction Stop
        
        Write-Host "[PASS] Retrieved user by ID" -ForegroundColor Green
        Write-Host "  Username: $($user.username), Email: $($user.email)" -ForegroundColor Gray
    } catch {
        Write-Host "[FAIL] Get user by ID failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 5: Login as Regular User
Write-Host "`nTest 5: Login as Regular User..." -ForegroundColor Yellow
try {
    $loginBody = @{
        username = "user"
        password = "user123"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody `
        -ErrorAction Stop
    
    $userToken = $response.token
    Write-Host "[PASS] User login successful" -ForegroundColor Green
    Write-Host "  User: $($response.username), Role: $($response.role)" -ForegroundColor Gray
} catch {
    Write-Host "[FAIL] User login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 6: Get All Promotions
Write-Host "`nTest 6: Get All Promotions..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $userToken"
    }
    $promotions = Invoke-RestMethod -Uri "$baseUrl/api/promotions" `
        -Method Get `
        -Headers $headers `
        -ErrorAction Stop
    
    Write-Host "[PASS] Retrieved $($promotions.Count) promotions" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Get promotions failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 7: Create Promotion (without file - PowerShell multipart is complex)
Write-Host "`nTest 7: Create Promotion (text only, no file)..." -ForegroundColor Yellow
Write-Host "  Note: File upload requires multipart/form-data. Use Postman for full file upload testing." -ForegroundColor Yellow
try {
    $promotionData = @{
        name = "Test Promotion $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        startDate = "2024-06-01"
        endDate = "2024-08-31"
    } | ConvertTo-Json

    $headers = @{
        "Authorization" = "Bearer $userToken"
    }
    
    # Create boundary for multipart
    $boundary = [System.Guid]::NewGuid().ToString()
    $bodyLines = @(
        "--$boundary",
        "Content-Disposition: form-data; name=`"promotion`"",
        "Content-Type: application/json",
        "",
        $promotionData,
        "--$boundary--"
    )
    $body = $bodyLines -join "`r`n"
    
    $promotion = Invoke-RestMethod -Uri "$baseUrl/api/promotions" `
        -Method Post `
        -Headers $headers `
        -ContentType "multipart/form-data; boundary=$boundary" `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
        -ErrorAction Stop
    
    Write-Host "[PASS] Promotion created successfully" -ForegroundColor Green
    Write-Host "  ID: $($promotion.id), Name: $($promotion.name)" -ForegroundColor Gray
    $createdPromotionId = $promotion.id
} catch {
    Write-Host "[FAIL] Create promotion failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Error details: $($_.Exception.Response)" -ForegroundColor Gray
    $createdPromotionId = $null
}

# Test 8: Get Promotion by ID
if ($createdPromotionId) {
    Write-Host "`nTest 8: Get Promotion by ID..." -ForegroundColor Yellow
    try {
        $headers = @{
            "Authorization" = "Bearer $userToken"
        }
        $promotion = Invoke-RestMethod -Uri "$baseUrl/api/promotions/$createdPromotionId" `
            -Method Get `
            -Headers $headers `
            -ErrorAction Stop
        
        Write-Host "[PASS] Retrieved promotion by ID" -ForegroundColor Green
        Write-Host "  Name: $($promotion.name), Dates: $($promotion.startDate) to $($promotion.endDate)" -ForegroundColor Gray
    } catch {
        Write-Host "[FAIL] Get promotion by ID failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 9: Test Unauthorized Access (try to access admin endpoint as user)
Write-Host "`nTest 9: Test Authorization (User trying to access Admin endpoint)..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $userToken"
    }
    $result = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" `
        -Method Get `
        -Headers $headers `
        -ErrorAction Stop
    
    Write-Host "[FAIL] User should not have access to admin endpoints" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq "Forbidden") {
        Write-Host "[PASS] Authorization working correctly (403 Forbidden)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Got error but not 403: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Test 10: Test Invalid Token
Write-Host "`nTest 10: Test Invalid Token..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer invalid_token_12345"
    }
    $result = Invoke-RestMethod -Uri "$baseUrl/api/promotions" `
        -Method Get `
        -Headers $headers `
        -ErrorAction Stop
    
    Write-Host "[FAIL] Should reject invalid token" -ForegroundColor Red
} catch {
    Write-Host "[PASS] Invalid token rejected correctly" -ForegroundColor Green
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Basic API tests completed!" -ForegroundColor Green
Write-Host "`nFor file upload testing, use:" -ForegroundColor Yellow
Write-Host "  - Postman (recommended)" -ForegroundColor White
Write-Host "  - cURL with multipart/form-data" -ForegroundColor White
Write-Host "  - Frontend application" -ForegroundColor White
Write-Host "`nSee TEST_API.md for detailed testing instructions.`n" -ForegroundColor Yellow

