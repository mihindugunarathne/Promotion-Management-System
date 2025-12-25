# Comprehensive Login Issue Diagnosis
$baseUrl = "http://localhost:8080"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Login Issue Diagnosis" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check if application is running
Write-Host "Step 1: Checking if application is running..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/diagnostic/all-users" -Method Get -ErrorAction Stop
    Write-Host "   [OK] Application is running`n" -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Application is NOT running!" -ForegroundColor Red
    Write-Host "   Please start the application first: mvn spring-boot:run`n" -ForegroundColor Yellow
    exit 1
}

# Check all users
Write-Host "Step 2: Checking all users in database..." -ForegroundColor Yellow
try {
    $users = Invoke-RestMethod -Uri "$baseUrl/api/diagnostic/all-users" -Method Get
    Write-Host "   Found $($users.Count) users:" -ForegroundColor Green
    foreach ($user in $users) {
        Write-Host "   - $($user.username) (Role: $($user.role), Active: $($user.isActive), ID: $($user.id))" -ForegroundColor Gray
    }
    Write-Host ""
} catch {
    Write-Host "   [ERROR] Could not retrieve users: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Check admin user specifically
Write-Host "Step 3: Checking admin user details..." -ForegroundColor Yellow
try {
    $adminCheck = Invoke-RestMethod -Uri "$baseUrl/api/diagnostic/check-user/admin" -Method Get
    if ($adminCheck.exists) {
        Write-Host "   [OK] Admin user exists" -ForegroundColor Green
        Write-Host "   - Username: $($adminCheck.username)" -ForegroundColor Gray
        Write-Host "   - Role: $($adminCheck.role)" -ForegroundColor Gray
        Write-Host "   - Active: $($adminCheck.isActive)" -ForegroundColor Gray
        Write-Host "   - Password matches 'admin123': $($adminCheck.passwordMatches_admin123)" -ForegroundColor $(if ($adminCheck.passwordMatches_admin123) { "Green" } else { "Red" })
        Write-Host ""
    } else {
        Write-Host "   [ERROR] Admin user does NOT exist!`n" -ForegroundColor Red
    }
} catch {
    Write-Host "   [ERROR] Could not check admin user: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Check regular user specifically
Write-Host "Step 4: Checking regular user details..." -ForegroundColor Yellow
try {
    $userCheck = Invoke-RestMethod -Uri "$baseUrl/api/diagnostic/check-user/user" -Method Get
    if ($userCheck.exists) {
        Write-Host "   [OK] User account exists" -ForegroundColor Green
        Write-Host "   - Username: $($userCheck.username)" -ForegroundColor Gray
        Write-Host "   - Role: $($userCheck.role)" -ForegroundColor Gray
        Write-Host "   - Active: $($userCheck.isActive)" -ForegroundColor Gray
        Write-Host "   - Password matches 'user123': $($userCheck.passwordMatches_user123)" -ForegroundColor $(if ($userCheck.passwordMatches_user123) { "Green" } else { "Red" })
        Write-Host ""
        
        if (-not $userCheck.passwordMatches_user123) {
            Write-Host "   [WARNING] Password does NOT match!" -ForegroundColor Red
            Write-Host "   This is the root cause of the login failure.`n" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   [ERROR] User account does NOT exist!" -ForegroundColor Red
        Write-Host "   The DataInitializer might not have run.`n" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   [ERROR] Could not check user: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test admin login
Write-Host "Step 5: Testing admin login..." -ForegroundColor Yellow
$adminLogin = @{ username = "admin"; password = "admin123" } | ConvertTo-Json
try {
    $adminResp = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -ContentType "application/json" -Body $adminLogin -ErrorAction Stop
    Write-Host "   [OK] Admin login successful!" -ForegroundColor Green
    Write-Host "   Token received: $($adminResp.token.Substring(0, 30))...`n" -ForegroundColor Gray
} catch {
    Write-Host "   [ERROR] Admin login failed!" -ForegroundColor Red
    Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Yellow
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "   Response: $responseBody`n" -ForegroundColor Yellow
    }
}

# Test user login
Write-Host "Step 6: Testing user login..." -ForegroundColor Yellow
$userLogin = @{ username = "user"; password = "user123" } | ConvertTo-Json
try {
    $userResp = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -ContentType "application/json" -Body $userLogin -ErrorAction Stop
    Write-Host "   [OK] User login successful!" -ForegroundColor Green
    Write-Host "   Token received: $($userResp.token.Substring(0, 30))...`n" -ForegroundColor Gray
} catch {
    Write-Host "   [ERROR] User login failed!" -ForegroundColor Red
    Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Yellow
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "   Response: $responseBody" -ForegroundColor Yellow
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Diagnosis Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Recommendations:" -ForegroundColor Yellow
Write-Host "1. If user doesn't exist: Restart the application to trigger DataInitializer" -ForegroundColor White
Write-Host "2. If password doesn't match: User might have been created with different password" -ForegroundColor White
Write-Host "3. If login still fails: Check application logs for detailed error messages" -ForegroundColor White
Write-Host ""

