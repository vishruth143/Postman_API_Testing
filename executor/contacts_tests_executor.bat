@echo off
echo ================================================
echo   Running Contacts Collection with Newman...
echo ================================================

call newman run "%~dp0..\Collections\Contacts\Contacts.postman_collection.json" ^
  --environment "%~dp0..\Collections\Contacts\Contacts.postman_environment.json" ^
  --reporters cli,htmlextra ^
  --reporter-htmlextra-export "%~dp0..\output\html_report\contacts_report.html"

start "" "%~dp0..\output\html_report\contacts_report.html"
