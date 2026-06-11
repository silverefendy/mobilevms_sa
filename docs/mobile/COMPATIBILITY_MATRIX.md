# Compatibility Matrix

## Overview
This document provides a detailed compatibility matrix between the legacy Flutter reference implementation (mobilevms_sa/reference) and the new production Flutter app (mobilevms_sa) with the vms_sa backend.

---

## API Endpoint Compatibility

### Authentication Endpoints

| Endpoint | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|----------|-------------------|------------------|------------------|---------|
| Login | `/api/method/login` (Frappe) | `/api/v1/auth/login` | `/api/v1/auth/login` | ✅ Migrated |
| Logout | `/api/method/logout` (Frappe) | `/api/v1/auth/logout` | `/api/v1/auth/logout` | ✅ Migrated |
| Refresh Token | Not implemented | `/api/v1/auth/refresh` | `/api/v1/auth/refresh` | ✅ New |
| Get Current User | `/api/method/frappe.auth.get_logged_user` | `/api/v1/auth/me` | `/api/v1/auth/me` | ✅ Migrated |
| Change Password | `/api/method/change_password` (Frappe) | `/api/v1/auth/change-password` | `/api/v1/auth/change-password` | ✅ Migrated |

### QR Operations Endpoints

| Endpoint | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|----------|-------------------|------------------|------------------|---------|
| Generate QR | Not implemented | `/api/v1/qr-operations/qr-codes/generate` | `/api/v1/qr-operations/qr-codes/generate` | ✅ New |
| Get QR Code | Not implemented | `/api/v1/qr-operations/qr-codes/{id}` | `/api/v1/qr-operations/qr-codes/{id}` | ✅ New |
| Revoke QR | Not implemented | `/api/v1/qr-operations/qr-codes/{id}/revoke` | `/api/v1/qr-operations/qr-codes/{id}/revoke` | ✅ New |
| Resolve Scan | `/api/method/resolve_scan` (custom) | `/api/v1/qr-operations/scans/resolve` | `/api/v1/qr-operations/scans/resolve` | ✅ Migrated |
| Execute Check-in | `/api/method/execute_scan` (custom) | `/api/v1/qr-operations/scans/execute` | `/api/v1/qr-operations/scans/execute` | ✅ Migrated |
| Check-out | `/api/method/check_out` (custom) | `/api/v1/qr-operations/visits/{id}/check-out` | `/api/v1/qr-operations/visits/{id}/check-out` | ✅ Migrated |
| Complete Visit | Not implemented | `/api/v1/qr-operations/visits/{id}/complete` | `/api/v1/qr-operations/visits/{id}/complete` | ✅ New |
| Visitor Logs | `/api/method/visitor_logs` (custom) | `/api/v1/qr-operations/visitor-logs` | `/api/v1/qr-operations/visitor-logs` | ✅ Migrated |

### Approval Endpoints

| Endpoint | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|----------|-------------------|------------------|------------------|---------|
| List Pending Tasks | `/api/method/pending_approvals` (custom) | `/api/v1/approvals/tasks` | `/api/v1/approvals/tasks` | ✅ Migrated |
| Get Task | Not implemented | `/api/v1/approvals/tasks/{id}` | `/api/v1/approvals/tasks/{id}` | ✅ New |
| Approve Task | `/api/method/approve_visit` (custom) | `/api/v1/approvals/tasks/{id}/approve` | `/api/v1/approvals/tasks/{id}/approve` | ✅ Migrated |
| Reject Task | `/api/method/reject_visit` (custom) | `/api/v1/approvals/tasks/{id}/reject` | `/api/v1/approvals/tasks/{id}/reject` | ✅ Migrated |
| Cancel Task | Not implemented | `/api/v1/approvals/tasks/{id}/cancel` | `/api/v1/approvals/tasks/{id}/cancel` | ✅ New |
| List Decisions | Not implemented | `/api/v1/approvals/decisions` | `/api/v1/approvals/decisions` | ✅ New |
| Get Decision | Not implemented | `/api/v1/approvals/decisions/{id}` | `/api/v1/approvals/decisions/{id}` | ✅ New |

### Dashboard Endpoints

| Endpoint | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|----------|-------------------|------------------|------------------|---------|
| Security Dashboard | Not implemented | `/api/v1/dashboard/security` | `/api/v1/dashboard/security` | ✅ New |
| Reception Dashboard | Not implemented | `/api/v1/dashboard/reception` | `/api/v1/dashboard/reception` | ✅ New |
| Manager Dashboard | Not implemented | `/api/v1/dashboard/manager` | `/api/v1/dashboard/manager` | ✅ New |
| HR Dashboard | Not implemented | `/api/v1/dashboard/hr` | `/api/v1/dashboard/hr` | ✅ New |
| Executive Dashboard | Not implemented | `/api/v1/dashboard/executive` | `/api/v1/dashboard/executive` | ✅ New |

### Lookup Endpoints

| Endpoint | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|----------|-------------------|------------------|------------------|---------|
| Departments | Not implemented | `/api/v1/lookups/departments` | `/api/v1/lookups/departments` | ✅ New |
| Employees | Not implemented | `/api/v1/lookups/employees` | `/api/v1/lookups/employees` | ✅ New |
| Gates | Not implemented | `/api/v1/lookups/gates` | `/api/v1/lookups/gates` | ✅ New |
| Visit Purposes | Not implemented | `/api/v1/lookups/visit-purposes` | `/api/v1/lookups/visit-purposes` | ✅ New |

---

## Data Model Compatibility

### Authentication Models

| Model | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|-------|-------------------|------------------|------------------|---------|
| Login Request | `usr`, `pwd` (form-encoded) | `username`, `password`, `companyCode` (JSON) | `username`, `password`, `company_code` | ✅ Migrated |
| Token Response | Session-based | `accessToken`, `refreshToken`, `tokenType`, `expiresIn` | `access_token`, `refresh_token`, `token_type`, `expires_in` | ✅ Migrated |
| User Info | Frappe User schema | `id`, `username`, `email`, `fullName`, `companyId`, `roles`, `permissions` | Same as New | ✅ Migrated |

### QR Models

| Model | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|-------|-------------------|------------------|------------------|---------|
| Scan Resolution | Custom schema | `valid`, `visitor`, `visit`, `warnings` | Same as New | ✅ Migrated |
| Check-in Event | Custom schema | `id`, `visitId`, `visitorId`, `checkedInAt`, `method` | Same as New | ✅ Migrated |
| Check-out Event | Custom schema | `id`, `visitId`, `visitorId`, `checkedOutAt`, `method` | Same as New | ✅ Migrated |
| Visitor Log | Custom schema | `id`, `visitorId`, `visitId`, `eventType`, `eventTime` | Same as New | ✅ Migrated |

### Approval Models

| Model | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|-------|-------------------|------------------|------------------|---------|
| Approval Task | Custom schema | `id`, `visitRequestId`, `approverUserId`, `status`, `dueAt` | Same as New | ✅ Migrated |
| Approval Decision | Not implemented | `id`, `approvalTaskId`, `decidedBy`, `decision`, `reason` | Same as New | ✅ New |
| Approve Request | Custom schema | `reason`, `comments` | Same as New | ✅ Migrated |
| Reject Request | Custom schema | `reason`, `comments` | Same as New | ✅ Migrated |

---

## Authentication Mechanism Compatibility

| Aspect | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|--------|-------------------|------------------|------------------|---------|
| Authentication Type | Session-based (Frappe) | JWT (Access + Refresh) | JWT (Access + Refresh) | ✅ Migrated |
| Token Storage | Cookies (CookieJar) | Secure Storage (flutter_secure_storage) | Redis (refresh tokens) | ✅ Migrated |
| CSRF Protection | Frappe CSRF tokens | Not required (JWT) | Not required (JWT) | ✅ Migrated |
| Token Refresh | Not implemented | Automatic on 401 | Supported | ✅ New |
| Company Code | Not required | Required in login | Required | ✅ New |
| Device ID | Not used | Optional in login | Optional | ✅ New |

---

## Feature Compatibility

| Feature | Legacy (Reference) | New (Production) | Backend (vms_sa) | Status |
|---------|-------------------|------------------|------------------|---------|
| Login | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| Logout | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| Server Setup | ✅ Implemented | ✅ Implemented | N/A | ✅ Compatible |
| QR Scanner | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| QR Resolve | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| QR Execute | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| QR Generate | ❌ Not implemented | ✅ Implemented | ✅ Supported | ✅ New |
| Approvals List | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| Approve Task | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| Reject Task | ✅ Implemented | ✅ Implemented | ✅ Supported | ✅ Compatible |
| Cancel Task | ❌ Not implemented | ✅ Implemented | ✅ Supported | ✅ New |
| Dashboard | ✅ Implemented | ⚠️ Placeholder | ✅ Supported | ⚠️ Partial |
| Lookups | ❌ Not implemented | ❌ Not implemented | ✅ Supported | ❌ Pending |
| Offline Queue | ✅ Implemented (configurable) | ❌ Not implemented | N/A | ❌ Removed |
| Push Notifications | ❌ Not implemented | ❌ Not implemented | ⚠️ Planned | ❌ Pending |

---

## Dependency Compatibility

| Dependency | Legacy (Reference) | New (Production) | Status |
|------------|-------------------|------------------|---------|
| Flutter SDK | Compatible | >=3.8.0 | ✅ Updated |
| dio | ^5.4.0 | ^5.4.0 | ✅ Same |
| provider | ^6.1.1 | ^6.1.1 | ✅ Same |
| mobile_scanner | ^7.2.0 | ^7.2.0 | ✅ Same |
| flutter_secure_storage | ^9.0.0 | ^9.0.0 | ✅ Same |
| go_router | ^13.2.0 | ^13.2.0 | ✅ Same |
| cookie_jar | ^4.0.0 | ❌ Removed | ✅ Removed |
| dio_cookie_manager | ^5.0.0 | ❌ Removed | ✅ Removed |
| json_annotation | ^4.8.1 | ^4.12.0 | ✅ Updated |
| json_serializable | ^6.7.1 | ^6.7.1 | ✅ Same |
| crypto | ^3.0.6 | ^3.0.6 | ✅ Same |
| path_provider | ^2.1.2 | ^2.1.2 | ✅ Same |
| shared_preferences | ^2.2.3 | ^2.2.3 | ✅ Same |
| uuid | ^4.0.0 | ^4.0.0 | ✅ Same |

---

## Platform Compatibility

| Platform | Legacy (Reference) | New (Production) | Status |
|----------|-------------------|------------------|---------|
| Android | ✅ Supported | ✅ Supported | ✅ Compatible |
| iOS | ✅ Supported | ✅ Supported | ✅ Compatible |
| Web | ❌ Not supported | ❌ Not supported | ✅ Same |
| Windows | ❌ Not supported | ❌ Not supported | ✅ Same |
| macOS | ❌ Not supported | ❌ Not supported | ✅ Same |
| Linux | ❌ Not supported | ❌ Not supported | ✅ Same |

---

## Breaking Changes

### Authentication
- **Major**: Session-based authentication replaced with JWT
- **Major**: Company code now required for login
- **Major**: CSRF tokens no longer used
- **Major**: Cookie-based storage replaced with secure storage

### API Endpoints
- **Major**: All API endpoints changed from Frappe format to REST API format
- **Major**: Request/response formats changed from Frappe schema to Pydantic schemas
- **Major**: Base URL configuration moved from runtime to setup screen

### Data Models
- **Major**: All data models updated to match backend Pydantic schemas
- **Major**: Field naming conventions changed (snake_case in backend, camelCase in Flutter)

### Features
- **Major**: Offline queue feature removed (not required for production)
- **Minor**: Dashboard is placeholder (full implementation pending)

---

## Migration Notes

### Data Migration
- No data migration required for the app (backend handles data)
- User credentials remain the same
- Company code must be known before migration

### Configuration Migration
- Server URL must be reconfigured in the new app
- Company code must be provided during login
- No automatic configuration migration from legacy app

### User Experience Changes
- Login screen now requires company code
- Server setup screen added for initial configuration
- Token refresh is automatic (no user action required)
- Logout now clears all tokens (no session persistence)

---

## Summary

### Compatible Features
- ✅ Authentication (login, logout, token refresh)
- ✅ QR Scanner (resolve, execute)
- ✅ Approvals (list, approve, reject)
- ✅ Server Setup
- ✅ Dashboard (placeholder)

### New Features
- ✅ JWT-based authentication with auto-refresh
- ✅ QR code generation
- ✅ Approval task cancellation
- ✅ Approval decisions history
- ✅ Dashboard metrics (multiple roles)
- ✅ Lookup services (departments, employees, gates, visit purposes)

### Removed Features
- ❌ Offline queue (not required for production)
- ❌ Cookie-based authentication
- ❌ CSRF token management

### Pending Features
- ⚠️ Full dashboard implementation
- ⚠️ Lookup service integration
- ⚠️ Push notification readiness
- ⚠️ Offline strategy review

### Overall Status
- **High-Priority Features**: ✅ Complete
- **Medium-Priority Features**: ⚠️ Partial
- **Low-Priority Features**: ❌ Pending
