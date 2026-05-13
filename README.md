<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# 🧪 Postman API Testing — Contacts

**Automated API test suite for the Contact List REST API covering CRUD, authentication, and negative/edge-case validation.**

![Postman](https://img.shields.io/badge/Postman-12.2.3-FF6C37?logo=postman&logoColor=white)
![Newman](https://img.shields.io/badge/Newman-CLI-43B02A?logo=npm&logoColor=white)
![API](https://img.shields.io/badge/API-REST-blue)
![Auth](https://img.shields.io/badge/Auth-Bearer%20Token-informational)
![Tests](https://img.shields.io/badge/Tests-15%20Requests%20%7C%2034%20Assertions-success)
![License](https://img.shields.io/badge/License-MIT-green)

Built with Postman · Newman · Bearer Token Auth · JavaScript Test Scripts

Covers Login · Get · Add · Update (PUT & PATCH) · Delete · Negative & Edge-Case Scenarios

</div>

---

## 📑 Table of Contents

1. [Features](#-features)
2. [Prerequisites](#-prerequisites)
3. [Project Structure](#-project-structure)
4. [Environment Variables](#-environment-variables)
5. [Test Suites](#-test-suites)
   - [Basic Endpoint Tests](#1-basic-endpoint-tests)
   - [Negative Tests](#2-negative-tests)
6. [Global Test Assertion](#-global-test-assertion)
7. [Authentication Flow](#-authentication-flow)
8. [Running the Collection](#%EF%B8%8F-running-the-collection)
   - [Via Postman UI](#via-postman-ui)
   - [Via Newman (CLI / CI)](#via-newman-cli--ci)
   - [Via Executor Script (Windows — One-Click)](#via-executor-script-windows--one-click)
9. [Test Coverage Summary](#-test-coverage-summary)

---

## ✨ Features

| #  | Feature                                                                    | Status |
|----|----------------------------------------------------------------------------|:------:|
| 1  | 🔐 Bearer Token authentication with automatic token extraction             | ✅     |
| 2  | 📋 Full CRUD coverage — GET, POST, PUT, PATCH, DELETE                      | ✅     |
| 3  | ✅ Happy-path (Basic Endpoint) tests for the full contact lifecycle         | ✅     |
| 4  | ❌ Negative tests — unauthorized access, missing fields, invalid data       | ✅     |
| 5  | ⚡ Global performance SLA assertion (< 3 000 ms per request)               | ✅     |
| 6  | 🔄 Environment-variable-driven requests (no hard-coded URLs or IDs)        | ✅     |
| 7  | 🧪 JavaScript test scripts with `pm.test` assertions                       | ✅     |
| 8  | 🔁 Auto-chaining — `token` and `contact_id` stored and reused across tests | ✅     |
| 9  | 🖥️ Newman CLI support for headless / CI-CD execution                      | ✅     |
| 10 | 📊 HTML Extra report generation via Newman                                 | ✅     |
| 11 | 🧹 Setup & Cleanup requests to keep test data tidy                         | ✅     |

---

## 🛠 Prerequisites

| Tool | Version | Purpose | Install |
|------|---------|---------|---------|
| Postman | v12+ | Collection authoring, manual execution | [postman.com](https://www.postman.com/downloads/) |
| Node.js | 18+ | Required by Newman CLI | [nodejs.org](https://nodejs.org/) |
| Newman | v6+ | Headless / CI-CD collection runner | `npm install -g newman` |
| newman-reporter-htmlextra | Latest | Rich HTML test reports | `npm install -g newman-reporter-htmlextra` |

> **Note:** Newman and the HTML reporter are only required for CLI / CI-CD execution. Postman Desktop is sufficient for manual runs.

---

## 🚀 Project Structure

```text
Postman_API_Testing/
├── Contacts/
│   ├── Contacts.postman_collection.json       # Main test collection (15 requests, 2 folders)
│   └── Contacts.postman_environment.json      # Environment variable definitions (14 variables)
├── executor/
│   └── contacts_tests_executor.bat            # One-click executor: runs Newman + opens HTML report
├── reports/
│   └── contacts_test_report.html              # Auto-generated HTML report (after first run)
└── README.md                                  # This document
```

---

## 🌱 Environment Variables

All variables are defined in `Contacts/Contacts.postman_environment.json`. Populate the required ones before running the collection.

> **📌 Note:** Before exporting the environment, ensure all variables are marked as **Shared** in Postman. To do this, open the environment editor, select the variables you want to share, and toggle the **Shared** column to `on` for each variable. This ensures that variable *names* (but not secret *values*) are included when the environment file is exported and shared with teammates.

| Variable | Type | Set By | Description |
|---|---|---|---|
| `base_url` | `default` | **Manual** | Base URL of the API server (e.g. `https://thinking-tester-contact-list.herokuapp.com`) |
| `token` | `any` | **Auto** — Login test script | Bearer token extracted from the Login response |
| `contact_id` | `default` | **Auto** — Add / Get Contact scripts | `_id` of the most recently created or fetched contact |
| `firstName` | `default` | Manual | Contact first name used in Add/Get request bodies |
| `lastName` | `default` | Manual | Contact last name used in Add/Get request bodies |
| `birthdate` | `default` | Manual | Contact date of birth — format `YYYY-MM-DD` |
| `email` | `default` | Manual | Contact email address |
| `phone` | `default` | Manual | Contact phone number (digits only) |
| `street1` | `default` | Manual | Primary street address line |
| `street2` | `default` | Manual | Secondary address line (apartment, suite, etc.) |
| `city` | `default` | Manual | City |
| `stateProvince` | `default` | Manual | State or province abbreviation |
| `postalCode` | `default` | Manual | ZIP / postal code |
| `country` | `default` | Manual | Country code or name (e.g. `USA`) |

---

## 🧪 Test Suites

### 1. Basic Endpoint Tests

Happy-path tests covering the full contact lifecycle in execution order.

| # | Request Name | Method | Endpoint | Expected Status | Assertions |
|---|---|---|---|---|---|
| 1 | **Login** | `POST` | `/users/login` | `200 OK` | Extracts and stores `{{token}}` environment variable |
| 2 | **Get Contact List** | `GET` | `/contacts` | `200 OK` | Status 200, `Content-Type: application/json`, stores first `{{contact_id}}` |
| 3 | **Add Contact** | `POST` | `/contacts` | `201 Created` | Status 201, stores new `{{contact_id}}` |
| 4 | **Get Contact** | `GET` | `/contacts/{{contact_id}}` | `200 OK` | Status 200, email match, `firstName` match, `lastName` match |
| 5 | **Update Contact (PUT)** | `PUT` | `/contacts/{{contact_id}}` | `200 OK` | Status 200 — full record replacement |
| 6 | **Update Contact (PATCH)** | `PATCH` | `/contacts/{{contact_id}}` | `200 OK` | Status 200 — partial field update |
| 7 | **Delete Contact** | `DELETE` | `/contacts/{{contact_id}}` | `200 OK` | Status 200 |

---

### 2. Negative Tests

Edge-case and error-handling tests that validate API resilience and input validation.

| # | Request Name | Method | Endpoint | Expected Status | Assertions |
|---|---|---|---|---|---|
| 1 | **Setup — Add Contact** | `POST` | `/contacts` | `201 Created` | Stores `{{contact_id}}` for use in subsequent negative tests |
| 2 | **Get Contact List — Unauthorized** | `GET` | `/contacts` | `401 Unauthorized` | Status 401 — empty / invalid token |
| 3 | **Get Contact — Not Found** | `GET` | `/contacts/123` | `400 Bad Request` | Status 400 — invalid ID format |
| 4 | **Add Contact — Missing Required Fields** | `POST` | `/contacts` | `400 Bad Request` | Status 400, response includes `` `firstName` is required `` and `` `lastName` is required `` |
| 5 | **Add Contact — Last Name Too Long** | `POST` | `/contacts` | `400 Bad Request` | Status 400 — field length validation |
| 6 | **Add Contact — Invalid Birthday** | `POST` | `/contacts` | `400 Bad Request` | Status 400, response includes `Birthdate is invalid` |
| 7 | **Update Contact — Invalid Email** | `PUT` | `/contacts/{{contact_id}}` | `400 Bad Request` | Status 400, response includes `Email is invalid` |
| 8 | **Cleanup — Delete Contact** | `DELETE` | `/contacts/{{contact_id}}` | `200 OK` | Status 200 — test data removed |

---

## ⚡ Global Test Assertion

A **collection-level test script** runs automatically after **every** request in the collection:

```javascript
pm.test("Response time is less than 3000ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(3000);
});
```

This enforces a performance SLA of **< 3 seconds** across all 15 requests without repeating the assertion in each individual test.

---

## 🔐 Authentication Flow

1. The **Login** request (`POST /users/login`) sends `email` and `password` as a JSON body.
2. On a `200 OK` response the post-request test script captures the token:

   ```javascript
   var jsondata = pm.response.json();
   pm.environment.set("token", jsondata.token);
   ```

3. All subsequent requests pass the token via **Bearer Token** authentication:

   ```
   Authorization: Bearer {{token}}
   ```

> ⚠️ **Security Note:** Never commit real credentials or production tokens to source control. Use Postman Vault or CI secret managers (e.g. GitHub Actions secrets) for sensitive values.

---

## ▶️ Running the Collection

### Via Postman UI

1. Open Postman → **Import** → select `Contacts/Contacts.postman_collection.json`.
2. **Import** → select `Contacts/Contacts.postman_environment.json`.
3. Set `Contacts` as the **active environment**.
4. Re-enable `firstName` and `city` variables and populate `base_url` and the remaining contact field variables (`firstName`, `lastName`, etc.).
5. Open the **Collection Runner** → select the `Contacts` collection → click **Run Contacts**.

---

### Via Newman (CLI / CI)

#### Step 1 — Install Newman and the HTML Extra reporter (one-time)

```powershell
npm install -g newman
npm install -g newman-reporter-htmlextra
```

#### Step 2 — Verify installation

```powershell
newman --version
```

#### Step 3 — Run the collection

```powershell
newman run "Contacts\Contacts.postman_collection.json" `
  --environment "Contacts\Contacts.postman_environment.json" `
  --reporters "cli,htmlextra" `
  --reporter-htmlextra-export "./reports/contacts_test_report.html"
```

#### Step 4 — View the report

Open `reports/contacts_test_report.html` in any browser.

#### Run with environment variable overrides (optional)

```powershell
newman run "Contacts\Contacts.postman_collection.json" `
  --environment "Contacts\Contacts.postman_environment.json" `
  --env-var "base_url=https://thinking-tester-contact-list.herokuapp.com" `
  --env-var "firstName=John" `
  --env-var "lastName=Doe" `
  --env-var "birthdate=1970-01-01" `
  --env-var "email=jdoe@fake.com" `
  --env-var "phone=8005555555" `
  --env-var "street1=1 Main St." `
  --env-var "street2=Apartment A" `
  --env-var "city=Anytown" `
  --env-var "stateProvince=KS" `
  --env-var "postalCode=12345" `
  --env-var "country=USA" `
  --reporters "cli,htmlextra" `
  --reporter-htmlextra-export "./reports/contacts_test_report.html"
```

> **Tip:** Use `--bail` to stop on first failure, or `--iteration-count <n>` to run the collection multiple times.

---

### Via Executor Script (Windows — One-Click)

A ready-made Windows batch script mirrors the pattern used in the companion Selenium framework.  
It runs Newman, validates the report was generated, and **automatically opens** the HTML report in your default browser.

#### Run the executor

```bat
executor\contacts_tests_executor.bat
```

> Run this from the `C:\Postman_API_Testing` root directory, or double-click the file in Windows Explorer.

#### What the executor does

| Step | Action |
|------|--------|
| 1 | Sets the working directory to the project root |
| 2 | Runs Newman with `cli` + `htmlextra` reporters |
| 3 | Validates the `reports\` folder and report file exist |
| 4 | Opens `reports\contacts_test_report.html` automatically in the default browser |

> **Note:** If any tests fail, Newman exits with a non-zero code and a warning is printed, but the report is still generated and opened so you can inspect the failures.

---

## 📊 Test Coverage Summary

| Category | Total Requests | Automated Assertions |
|---|---|---|
| Basic Endpoint Tests | 7 | 9 |
| Negative Tests | 8 | 10 |
| Global (all requests) | — | 1 per request (15 total) |
| **Total** | **15** | **34** |

---

<div align="center">

### 🧪 Happy Testing! 🧪

</div>

````
