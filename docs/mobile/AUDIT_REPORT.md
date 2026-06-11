# Mobile Migration Audit Report

**Project:** VMS Mobile Migration
**Date:** June 11, 2026
**Phase:** Phase A - Repository Audit
**Status:** In Progress

---

## Executive Summary

This audit report provides a comprehensive analysis of the source of truth backend (vms_sa) and the reference Flutter implementation (mobilevms_sa/reference). The audit identifies significant architectural differences, particularly in authentication mechanisms, that must be addressed during migration.

**Key Finding:** The backend uses JWT-based authentication while the reference implementation uses ERPNext/Frappe session-based authentication with cookies. This is a critical migration blocker that requires complete authentication layer replacement.

---

## 1. Feature Inventory

### 1.1 Backend Features (vms_sa)

#### Authentication
- JWT Access Token authentication
- JWT Refresh Token with Redis storage
- Login with username/password/company_code
- Token refresh mechanism
- Logout with session invalidation
- Password change functionality
- User profile retrieval (/me endpoint)
- Account lockout after failed attempts
- Session management with Redis

#### QR Operations
- QR Code Generation (with configurable expiry)
- QR Code Resolution (preview without execution)
- QR Code Execution (check-in)
- QR Code Revocation
- QR Code Validation (security checks)
- Check-In Event tracking
- Check-Out Event tracking
- Visit Completion (scheduler)
- Visitor Log tracking
- Gate and Gate Device support

#### Approval Workflow
- Approval Task creation with assignment strategies
- Approval Task listing (with pagination)
- Pending Tasks endpoint
- Approval Task approval
- Approval Task rejection (with reason)
- Approval Task cancellation
- Approval Task expiration (scheduler)
- Approval Decision history
- Notification integration

#### Dashboard
- Security Dashboard metrics
- Reception Dashboard metrics
- Manager Dashboard metrics
- HR Dashboard metrics
- Executive Dashboard metrics
- Redis caching support
- Audit logging

#### Lookup Services
- Department lookup (autocomplete)
- Employee lookup (autocomplete)
- Gate lookup (autocomplete)
- Visit Purpose lookup (autocomplete)

#### Visitors & Visit Requests
- Visitor CRUD operations
- Visit Request CRUD operations
- Visit Lifecycle management
- Visit State Machine
- Visit Purpose management
- File upload support
- Badge management

#### Notifications
- Notification creation from templates
- Notification delivery
- Notification history
- Email notification support

#### Reports & Exports
- Report generation
- Export functionality
- Analytics support

#### Scheduler
- Job scheduling
- Job history
- Automation support

### 1.2 Flutter Reference Features (mobilevms_sa/reference)

#### Authentication
- ERPNext/Frappe session-based authentication
- Cookie-based session management
- CSRF token handling
- Server setup screen
- Login screen
- Splash screen
- Session restoration
- Session validation

#### QR Scanner
- QR Code scanning with mobile_scanner
- Scan Coordinator with state management
- Resolve Scan Action (preview)
- Execute Scan Action (check-in/out)
- Scan validation
- Scan cooldown protection
- Offline queue support
- Torch control
- Haptic feedback

#### Approvals
- Pending Approvals listing
- Approval action (approve)
- Rejection action (reject with reason)
- Simple approval UI

#### Dashboard
- Dashboard section widget
- Dashboard controller
- Basic dashboard structure

#### Visitors
- Visitors listing
- Visitors controller
- Active visitors support

#### Activity
- Recent activity tracking
- Activity events

#### Core Features
- Connectivity monitoring
- Error handling
- Logging
- Network client with Dio
- Secure storage
- QR validation service
- Resilience (pending operation queue)
- Server configuration
- Theme management

---

## 2. Architecture Inventory

### 2.1 Backend Architecture (vms_sa)

#### Technology Stack
- **Framework:** FastAPI
- **Database:** PostgreSQL with SQLAlchemy (async)
- **Cache:** Redis
- **Authentication:** JWT (access + refresh tokens)
- **API Style:** RESTful with OpenAPI documentation

#### Layer Structure
```
backend/app/
├── api/
│   ├── dependencies/      # Dependency injection
│   └── v1/
│       ├── endpoints/      # API route handlers
│       └── router.py       # Route aggregation
├── core/                   # Core functionality
│   ├── config.py
│   ├── logging.py
│   ├── rate_limit.py
│   ├── security.py
│   └── redis_client.py
├── database/               # Database session management
├── models/                 # SQLAlchemy ORM models
├── repositories/           # Data access layer
├── schemas/                # Pydantic schemas (DTOs)
├── services/               # Business logic layer
└── utils/                  # Utility functions
```

#### Key Architectural Patterns
- **Repository Pattern:** Data access abstraction
- **Service Layer:** Business logic encapsulation
- **Dependency Injection:** FastAPI Depends
- **State Machine:** Visit and VisitRequest state transitions
- **Strategy Pattern:** Approval assignment strategies
- **Template Method:** Notification templates

#### Security Features
- JWT token validation
- Role-based access control (RBAC)
- Permission-based authorization
- Rate limiting
- CSRF protection
- SQL injection prevention (ORM)
- Audit logging
- Security event tracking

### 2.2 Flutter Reference Architecture (mobilevms_sa/reference)

#### Technology Stack
- **Framework:** Flutter (SDK >=3.3.0)
- **State Management:** Provider
- **Navigation:** go_router
- **HTTP Client:** Dio with cookie support
- **Storage:** flutter_secure_storage, shared_preferences
- **QR Scanning:** mobile_scanner
- **Encryption:** crypto

#### Layer Structure
```
lib/
├── app.dart                # App initialization
├── main.dart               # Entry point
├── config/                 # Configuration
├── core/                   # Core functionality
│   ├── auth/              # Authentication controller
│   ├── connectivity/      # Network monitoring
│   ├── errors/            # Error handling
│   ├── lifecycle/         # App lifecycle
│   ├── logging/           # Logging
│   ├── network/           # API client
│   ├── qr/                # QR validation
│   ├── resilience/        # Offline queue
│   ├── server_config/     # Server configuration
│   ├── settings/          # App settings
│   ├── storage/           # Secure storage
│   └── theme/             # Theme management
├── data/                  # Data layer
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer
│   ├── models/            # Domain models
│   └── repositories/      # Repository interfaces
├── features/              # Feature modules
│   ├── activity/
│   ├── approvals/
│   ├── auth/
│   ├── dashboard/
│   ├── employee/
│   ├── menu/
│   ├── scanner/
│   ├── settings/
│   ├── visitors/
│   └── widgets/
└── theme/                 # Theme definitions
```

#### Key Architectural Patterns
- **Clean Architecture:** Domain/Data separation
- **Repository Pattern:** Data access abstraction
- **Provider Pattern:** State management
- **Coordinator Pattern:** Scan coordination
- **Observer Pattern:** ChangeNotifier
- **Strategy Pattern:** Scan outcome handling

#### Security Features
- Secure storage for session data
- Cookie management with Dio
- CSRF token handling
- Session validation
- Unauthorized handler

---

## 3. Dependency Inventory

### 3.1 Backend Dependencies

#### Core Framework
- FastAPI
- SQLAlchemy (async)
- Pydantic
- uvicorn (ASGI server)

#### Database & Cache
- PostgreSQL driver
- Redis (async)

#### Authentication & Security
- python-jose (JWT)
- passlib (password hashing)
- bcrypt

#### Utilities
- python-multipart
- alembic (migrations)

### 3.2 Flutter Reference Dependencies

#### Core Flutter
- flutter (SDK)
- cupertino_icons

#### Networking
- dio (^5.4.0) - HTTP client
- cookie_jar (^4.0.8) - Cookie management
- dio_cookie_manager (^3.1.1) - Dio cookie integration

#### State Management
- provider (^6.1.1)

#### Navigation
- go_router (^13.2.0)

#### Storage
- flutter_secure_storage (^9.0.0)
- shared_preferences (^2.2.3)
- path_provider (^2.1.2)

#### QR Scanning
- mobile_scanner (^7.2.0)

#### Security
- crypto (^3.0.6)

---

## 4. Technical Risks

### 4.1 Critical Risks

#### 1. Authentication Mechanism Mismatch
**Risk Level:** CRITICAL
**Description:** Backend uses JWT tokens (access + refresh) while Flutter reference uses ERPNext session-based authentication with cookies.
**Impact:** Complete authentication layer replacement required. Cannot reuse existing auth implementation.
**Mitigation:** Implement new JWT-based authentication following backend API contracts.

#### 2. API Contract Incompatibility
**Risk Level:** CRITICAL
**Description:** Flutter reference calls Frappe API methods (`/api/method/...`) while backend uses REST API endpoints (`/api/v1/...`).
**Impact:** All API calls must be rewritten to match backend REST endpoints.
**Mitigation:** Create new API client implementation following backend API contracts.

### 4.2 High Risks

#### 3. QR Token Format Differences
**Risk Level:** HIGH
**Description:** Backend uses JWT-based QR tokens with security validation, Flutter reference may use different QR format.
**Impact:** QR generation and validation logic may need complete rewrite.
**Mitigation:** Verify QR token format compatibility and implement backend QR security service.

#### 4. State Machine Differences
**Risk Level:** HIGH
**Description:** Backend has comprehensive visit state machine with validation, Flutter reference may have simplified state handling.
**Impact:** State transitions may not align, causing business rule violations.
**Mitigation:** Implement backend state machine validation in Flutter app.

#### 5. RBAC Implementation Gap
**Risk Level:** HIGH
**Description:** Backend has comprehensive RBAC with roles and permissions, Flutter reference has basic role handling.
**Impact:** Authorization checks may be insufficient, leading to security vulnerabilities.
**Mitigation:** Implement permission-based UI rendering and API call authorization.

### 4.3 Medium Risks

#### 6. Error Handling Incompatibility
**Risk Level:** MEDIUM
**Description:** Backend uses structured error responses with specific HTTP status codes, Flutter reference may have different error handling.
**Impact:** Error messages may not display correctly, user experience degraded.
**Mitigation:** Implement centralized error handling matching backend error contract.

#### 7. Data Model Mismatches
**Risk Level:** MEDIUM
**Description:** Backend models use UUIDs and specific field names, Flutter reference may use different formats.
**Impact:** Data serialization/deserialization failures.
**Mitigation:** Update all domain models to match backend schemas.

#### 8. Pagination Differences
**Risk Level:** MEDIUM
**Description:** Backend uses cursor-based or offset-based pagination with specific response structure, Flutter reference may use different pagination.
**Impact:** List views may not work correctly.
**Mitigation:** Implement pagination matching backend API contracts.

### 4.4 Low Risks

#### 9. UI/UX Adaptation
**Risk Level:** LOW
**Description:** Flutter reference UI may need adaptation for new backend features.
**Impact:** Minor UI adjustments required.
**Mitigation:** Reuse existing UI components, adapt as needed.

#### 10. Dependency Updates
**Risk Level:** LOW
**Description:** Some Flutter dependencies may need updates for compatibility.
**Impact:** Minor version conflicts possible.
**Mitigation:** Update dependencies as needed during migration.

---

## 5. Migration Risks

### 5.1 Architecture Migration Risks

#### 1. Clean Architecture Preservation
**Risk:** Migration may compromise clean architecture principles.
**Mitigation:** Maintain domain/data separation, follow SOLID principles.

#### 2. State Management Migration
**Risk:** Provider-based state management may need adaptation for JWT authentication.
**Mitigation:** Extend AuthController to handle JWT tokens and auto-refresh.

### 5.2 Data Migration Risks

#### 3. Session Data Migration
**Risk:** Existing session data (cookies) cannot be migrated to JWT tokens.
**Mitigation:** Force logout of all users after migration, require re-authentication.

#### 4. Offline Queue Compatibility
**Risk:** Offline queue may not work with new API endpoints.
**Mitigation:** Update offline queue to use new API contracts.

### 5.3 Feature Migration Risks

#### 5. QR Workflow Security
**Risk:** Direct check-in without resolve may be possible if not properly implemented.
**Mitigation:** Enforce resolve → execute pattern in Flutter app.

#### 6. Approval Workflow Completeness
**Risk:** Flutter reference has basic approval UI, backend has comprehensive approval workflow.
**Mitigation:** Implement full approval workflow with task details, history, and decisions.

### 5.4 Testing Risks

#### 7. Test Coverage Gap
**Risk:** Existing tests may not cover new authentication and API contracts.
**Mitigation:** Write comprehensive unit, widget, and integration tests for migrated code.

#### 8. Integration Testing Complexity
**Risk:** Integration tests require backend API availability.
**Mitigation:** Use mock backend for testing, implement integration tests with test backend.

### 5.5 Deployment Risks

#### 9. Rollback Complexity
**Risk:** Migration involves authentication changes, rollback may be complex.
**Mitigation:** Plan rollback strategy, maintain backup of previous version.

#### 10. User Training
**Risk:** Users may need training for new authentication flow (if UI changes).
**Mitigation:** Keep UI changes minimal, provide clear documentation.

---

## 6. Recommendations

### 6.1 Immediate Actions

1. **Phase D - Authentication Migration:** Prioritize JWT authentication implementation as it's a critical blocker.
2. **Phase E - API Client Migration:** Create new API client following backend REST API contracts.
3. **Phase F - Model Mapping:** Update all domain models to match backend schemas.

### 6.2 Architectural Decisions

1. **Reuse Clean Architecture:** Maintain the excellent clean architecture from Flutter reference.
2. **Extend AuthController:** Adapt AuthController to handle JWT tokens and auto-refresh.
3. **Reuse Scan Coordinator:** The Scan Coordinator pattern is excellent and aligns with backend resolve → execute workflow.
4. **Implement Permission Checks:** Add permission-based UI rendering throughout the app.

### 6.3 Risk Mitigation

1. **Incremental Migration:** Migrate feature by feature to minimize risk.
2. **Comprehensive Testing:** Implement unit, widget, and integration tests for each migrated feature.
3. **Backend-First Approach:** Ensure backend API is stable before Flutter implementation.
4. **Documentation:** Document all API contracts and data models for reference.

---

## 7. Next Steps

1. **Phase B - Gap Analysis:** Compare backend and Flutter reference in detail to identify all gaps.
2. **Phase C - Implementation Plan:** Create detailed implementation plan with priorities and estimates.
3. **Phase D - Authentication Migration:** Begin JWT authentication implementation.
4. **Phase E - API Client Migration:** Create new API client layer.
5. **Phase F - Model Mapping:** Update domain models to match backend schemas.

---

## Appendix

### A. Backend API Endpoints Summary

| Module | Endpoints | Authentication |
|--------|-----------|----------------|
| Auth | /login, /refresh, /logout, /me, /change-password | Public (except /me, /logout, /change-password) |
| QR Operations | /qr-codes/generate, /qr-codes/{id}, /qr-codes/{id}/revoke, /scans/resolve, /scans/execute, /visits/{id}/check-out, /visits/{id}/complete, /visitor-logs | JWT Required |
| Approvals | /tasks, /tasks/pending, /tasks/{id}, /tasks/{id}/approve, /tasks/{id}/reject, /tasks/{id}/cancel, /decisions, /decisions/{id} | JWT Required |
| Dashboard | /security, /reception, /manager, /hr, /executive | JWT Required |
| Lookups | /departments, /employees, /gates, /visit-purposes | JWT Required |
| Visitors | /visitors, /visitors/{id} | JWT Required |
| Visit Requests | /visit-requests, /visit-requests/{id} | JWT Required |
| Employees | /employees, /employees/{id} | JWT Required |
| Departments | /departments, /departments/{id} | JWT Required |
| Gates | /gates, /gates/{id} | JWT Required |
| Notifications | /notifications, /notifications/{id} | JWT Required |
| Reports | /reports | JWT Required |
| Files | /api/v1/files | JWT Required |
| Badges | /api/v1/badges | JWT Required |

### B. Flutter Reference API Calls Summary

| Feature | API Endpoint | Method | Notes |
|---------|--------------|--------|-------|
| Login | /api/method/login | POST (form-encoded) | ERPNext authentication |
| Get Logged User | /api/method/frappe.auth.get_logged_user | GET | Session validation |
| Get CSRF Token | /api/method/...get_csrf_token | GET | CSRF token retrieval |
| Resolve Scan Action | /api/method/visitor_management.mobile.resolve_scan_action | POST | QR resolve |
| Execute Scan Action | /api/method/visitor_management.mobile.execute_scan_action | POST | QR execute |
| Get Visitor by QR | /api/method/visitor_management.visitor_management.api.get_visitor_by_qr | GET | Visitor status |
| Get Active Visitors | /api/method/visitor_management.mobile.get_active_visitors | GET | Active visitors list |
| Get Pending Approvals | /api/method/visitor_management.mobile.get_pending_approvals | GET | Pending approvals |
| Submit Approval | /api/method/visitor_management.mobile.submit_approval | POST | Approve/reject |
| Get Recent Activity | /api/method/visitor_management.mobile.get_recent_activity | GET | Activity feed |
| Logout | /api/method/logout | POST | Session termination |

### C. Authentication Flow Comparison

#### Backend JWT Flow
```
1. User enters credentials (username, password, company_code)
2. POST /api/v1/auth/login
3. Backend validates credentials
4. Backend generates access_token (JWT) and refresh_token
5. Backend returns tokens + user info
6. Client stores access_token and refresh_token securely
7. Client uses access_token in Authorization header for API calls
8. When access_token expires, client calls /api/v1/auth/refresh with refresh_token
9. Backend validates refresh_token, issues new tokens
10. Client updates stored tokens
11. Logout: POST /api/v1/auth/logout with refresh_token
```

#### Flutter Reference ERPNext Flow
```
1. User enters credentials (username, password)
2. POST /api/method/login (form-encoded)
3. ERPNext validates credentials
4. ERPNext sets session cookie
5. Client retrieves CSRF token
6. Client stores CSRF token
7. Client uses cookie + CSRF token for API calls
8. Session validation: GET /api/method/frappe.auth.get_logged_user
9. Logout: POST /api/method/logout
10. Client clears cookies and CSRF token
```

---

**Report Generated:** June 11, 2026
**Next Review:** After Phase B - Gap Analysis
