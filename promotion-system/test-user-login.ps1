# Test User Login Issue
$baseUrl = "http://localhost:8080"

Write-Host "Testing User Login..." -ForegroundColor Yellow

# First, login as admin to verify system works
Write-Host "`n1. Testing Admin Login (should work)..." -ForegroundColor Cyan
$adminLogin = @{ username = "admin"; password = "admin123" } | ConvertTo-Json
try {
    $adminResp = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -ContentType "application/json" -Body $adminLogin
    Write-Host "   [OK] Admin login successful" -ForegroundColor Green
    
    # Get all users to see what's in the database
    Write-Host "`n2. Getting all users to check database..." -ForegroundColor Cyan
    $headers = @{ "Authorization" = "Bearer $($adminResp.token)" }
    $users = Invoke-RestMethod -Uri "$baseUrl/api/admin/users" -Method Get -Headers $headers
    Write-Host "   Found $($users.Count) users:" -ForegroundColor Green
    foreach ($user in $users) {
        Write-Host "   - Username: $($user.username), Role: $($user.role), Active: $($user.isActive), ID: $($user.id)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   [ERROR] Admin login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

# Now test user login
Write-Host "`n3. Testing User Login..." -ForegroundColor Cyan
$userLogin = @{ username = "user"; password = "user123" } | ConvertTo-Json
Write-Host "   Request body: $userLogin" -ForegroundColor Gray

try {
    $userResp = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -ContentType "application/json" -Body $userLogin -ErrorAction Stop
    Write-Host "   [OK] User login successful!" -ForegroundColor Green
    Write-Host "   Token: $($userResp.token.Substring(0, 50))..." -ForegroundColor Gray
} catch {
    Write-Host "   [ERROR] User login failed!" -ForegroundColor Red
    Write-Host "   Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Yellow
    Write-Host "   Error Message: $($_.Exception.Message)" -ForegroundColor Yellow
    
    # Try to get response body
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "   Response Body: $responseBody" -ForegroundColor Yellow
    }
    
    # Check if user exists
    $userExists = $users | Where-Object { $_.username -eq "user" }
    if ($userExists) {
        Write-Host "`n   User account exists in database:" -ForegroundColor Cyan
        Write-Host "   - Username: $($userExists.username)" -ForegroundColor Gray
        Write-Host "   - Role: $($userExists.role)" -ForegroundColor Gray
        Write-Host "   - Active: $($userExists.isActive)" -ForegroundColor Gray
        Write-Host "   - Email: $($userExists.email)" -ForegroundColor Gray
    } else {
        Write-Host "`n   [WARNING] User 'user' does NOT exist in database!" -ForegroundColor Red
        Write-Host "   The DataInitializer might not have run properly." -ForegroundColor Yellow
    }
}

