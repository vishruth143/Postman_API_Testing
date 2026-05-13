@echo off
cd /d "%~dp0.."

echo Running Contacts API Test Collection...
newman run "Contacts\Contacts.postman_collection.json" ^
  --environment "Contacts\Contacts.postman_environment.json" ^
  --reporters "cli,htmlextra" ^
  --reporter-htmlextra-export "reports\contacts_test_report.html"

if errorlevel 1 (
    echo.
    echo WARNING: One or more tests failed. Check the report for details.
)

if not exist "reports\" (
    echo ERROR: reports folder does not exist. Newman may not have run correctly.
    exit /b 1
)

dir /b "reports\" 2>nul | findstr "contacts_test_report.html" >nul
if errorlevel 1 (
    echo ERROR: Report file was not generated. Please check Newman output above.
    exit /b 1
)

echo.
echo Opening HTML Report...
start "" "reports\contacts_test_report.html"

